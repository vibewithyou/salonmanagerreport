import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/billing_repository.dart';
import '../../../services/supabase_service.dart';

class POSScreen extends ConsumerStatefulWidget {
  const POSScreen({super.key});

  @override
  ConsumerState<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends ConsumerState<POSScreen> {
  final TextEditingController _searchController = TextEditingController();

  bool _loading = true;
  String? _salonId;
  String? _error;

  List<POSCatalogItem> _services = [];
  List<POSCatalogItem> _products = [];
  List<POSCartItem> _cart = [];

  @override
  void initState() {
    super.initState();
    _loadCatalog();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCatalog() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final supabaseService = ref.read(supabaseServiceProvider);
      final user = supabaseService.currentUser;
      if (user == null) {
        throw Exception('User not authenticated.');
      }

      final repo = ref.read(billingRepositoryProvider);
      final salonId = await repo.resolveSalonId(user.id);

      if (salonId == null || salonId.isEmpty) {
        throw Exception('No salon found for current user.');
      }

      final services = await repo.fetchServices(salonId);
      final products = await repo.fetchProducts(salonId);

      if (!mounted) return;
      setState(() {
        _salonId = salonId;
        _services = services;
        _products = products;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  List<POSCatalogItem> get _filteredCatalog {
    final query = _searchController.text.trim().toLowerCase();
    final catalog = [..._services, ..._products];
    if (query.isEmpty) {
      return catalog;
    }
    return catalog
        .where((item) => item.name.toLowerCase().contains(query))
        .toList();
  }

  double get _subtotal => _cart.fold(
        0,
        (sum, item) => sum + (item.unitPrice * item.quantity),
      );

  double get _tax => _subtotal * 0.19;

  double get _total => _subtotal + _tax;

  void _addToCart(POSCatalogItem item) {
    final index = _cart.indexWhere(
      (cartItem) => cartItem.id == item.id && cartItem.type == item.type,
    );

    setState(() {
      if (index == -1) {
        _cart.add(
          POSCartItem(
            id: item.id,
            name: item.name,
            unitPrice: item.unitPrice,
            type: item.type,
            quantity: 1,
          ),
        );
      } else {
        _cart[index] = _cart[index].copyWith(quantity: _cart[index].quantity + 1);
      }
    });
  }

  void _changeQty(POSCartItem item, int delta) {
    final index = _cart.indexWhere(
      (cartItem) => cartItem.id == item.id && cartItem.type == item.type,
    );
    if (index == -1) {
      return;
    }

    final newQty = _cart[index].quantity + delta;

    setState(() {
      if (newQty <= 0) {
        _cart.removeAt(index);
      } else {
        _cart[index] = _cart[index].copyWith(quantity: newQty);
      }
    });
  }

  Future<void> _showCheckoutModal() async {
    String method = 'cash';

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Checkout',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: method,
                    items: const [
                      DropdownMenuItem(value: 'cash', child: Text('Bar (cash)')),
                      DropdownMenuItem(value: 'card', child: Text('EC / Karte')),
                    ],
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setSheetState(() => method = value);
                    },
                    decoration: const InputDecoration(
                      labelText: 'Payment method',
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await _finalize(method);
                      },
                      child: Text('Finalize • €${_total.toStringAsFixed(2)}'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _finalize(String paymentMethod) async {
    if (_salonId == null || _cart.isEmpty) {
      return;
    }

    try {
      await ref.read(billingRepositoryProvider).finalizeSale(
            salonId: _salonId!,
            items: _cart,
            paymentMethod: paymentMethod,
          );

      if (!mounted) {
        return;
      }

      setState(() => _cart = []);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invoice & payment created.')),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Finalize failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text(_error!));
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search services or products',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredCatalog.length,
                    itemBuilder: (context, index) {
                      final item = _filteredCatalog[index];
                      return Card(
                        child: ListTile(
                          title: Text(item.name),
                          subtitle: Text(
                            '${item.type.name} • €${item.unitPrice.toStringAsFixed(2)}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => _addToCart(item),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Warenkorb',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: _cart.isEmpty
                          ? const Center(child: Text('Noch keine Positionen'))
                          : ListView.builder(
                              itemCount: _cart.length,
                              itemBuilder: (context, index) {
                                final item = _cart[index];
                                final line = item.unitPrice * item.quantity;
                                return ListTile(
                                  dense: true,
                                  title: Text(item.name),
                                  subtitle: Text(
                                    '${item.quantity} × €${item.unitPrice.toStringAsFixed(2)}',
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () => _changeQty(item, -1),
                                        icon: const Icon(Icons.remove),
                                      ),
                                      IconButton(
                                        onPressed: () => _changeQty(item, 1),
                                        icon: const Icon(Icons.add),
                                      ),
                                      Text('€${line.toStringAsFixed(2)}'),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                    const Divider(),
                    _summaryRow('Subtotal', _subtotal),
                    _summaryRow('Steuer (19%)', _tax),
                    _summaryRow('Total', _total, bold: true),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _cart.isEmpty ? null : _showCheckoutModal,
                        child: const Text('Checkout'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, double value, {bool bold = false}) {
    final style = TextStyle(
      fontWeight: bold ? FontWeight.bold : FontWeight.w400,
      fontSize: bold ? 16 : 14,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text('€${value.toStringAsFixed(2)}', style: style),
        ],
      ),
    );
  }
}
