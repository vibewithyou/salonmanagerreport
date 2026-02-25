import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/employee_dashboard_dto.dart';
import '../../../providers/employee_dashboard_provider.dart';

/// POSTab Widget - complete POS system with cart and checkout
class POSTabEnhanced extends ConsumerStatefulWidget {
  final String salonId;
  final String employeeId;

  const POSTabEnhanced({
    required this.salonId,
    required this.employeeId,
    super.key,
  });

  @override
  ConsumerState<POSTabEnhanced> createState() => _POSTabEnhancedState();
}

class _POSTabEnhancedState extends ConsumerState<POSTabEnhanced> {
  String? _selectedCategory;
  List<SalonServiceDto> _filteredServices = [];
  
  // Cart State
  final List<CartItem> _cartItems = [];
  String _paymentMethod = 'cash'; // cash, card, ec
  double _discountPercent = 0;

  @override
  Widget build(BuildContext context) {
    final servicesAsync = ref.watch(salonServicesProvider(widget.salonId));

    return servicesAsync.when(
      data: (services) {
        // Get unique categories
        final categories = <String?>{};
        for (var service in services) {
          categories.add(service.category);
        }

        // Filter services by category
        _filteredServices = _selectedCategory == null
            ? services
            : services.where((s) => s.category == _selectedCategory).toList();

        return Row(
          children: [
            // Services List (Left)
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  // Category Filter
                  Container(
                    color: Colors.black,
                    padding: const EdgeInsets.all(12),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FilterChip(
                            label: const Text('Alle'),
                            selected: _selectedCategory == null,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = null;
                              });
                            },
                            backgroundColor: Colors.grey[900],
                            selectedColor: AppColors.gold.withOpacity(0.3),
                            labelStyle: TextStyle(
                              color: _selectedCategory == null
                                  ? AppColors.gold
                                  : Colors.white70,
                            ),
                            side: BorderSide(
                              color: _selectedCategory == null
                                  ? AppColors.gold
                                  : Colors.white24,
                            ),
                          ),
                          ...categories.map((category) {
                            final isSelected = _selectedCategory == category;
                            return Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: FilterChip(
                                label: Text(category ?? 'Sonstiges'),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedCategory =
                                        selected ? category : null;
                                  });
                                },
                                backgroundColor: Colors.grey[900],
                                selectedColor:
                                    AppColors.gold.withOpacity(0.3),
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? AppColors.gold
                                      : Colors.white70,
                                ),
                                side: BorderSide(
                                  color: isSelected
                                      ? AppColors.gold
                                      : Colors.white24,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  // Services List
                  Expanded(
                    child: _filteredServices.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  LucideIcons.inbox,
                                  size: 48,
                                  color: Colors.white54,
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Keine Services',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(12),
                            itemCount: _filteredServices.length,
                            itemBuilder: (context, index) {
                              final service = _filteredServices[index];
                              return _ServiceTile(
                                service: service,
                                onTap: () => _addToCart(service),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),

            // Divider
            Container(
              width: 1,
              color: Colors.white10,
            ),

            // Cart & Checkout (Right)
            Expanded(
              flex: 1,
              child: _buildCartPanel(),
            ),
          ],
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.alertCircle,
              size: 48,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            const Text(
              'Fehler beim Laden der Services',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart(SalonServiceDto service) {
    setState(() {
      final existingIndex =
          _cartItems.indexWhere((item) => item.service.id == service.id);
      if (existingIndex >= 0) {
        _cartItems[existingIndex].quantity++;
      } else {
        _cartItems.add(CartItem(service: service, quantity: 1));
      }
    });
  }

  void _removeFromCart(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  void _updateQuantity(int index, int quantity) {
    setState(() {
      if (quantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index].quantity = quantity;
      }
    });
  }

  double _calculateSubtotal() {
    return _cartItems.fold(0, (sum, item) => sum + (item.total));
  }

  double _calculateDiscount() {
    return _calculateSubtotal() * (_discountPercent / 100);
  }

  double _calculateTotal() {
    return _calculateSubtotal() - _calculateDiscount();
  }

  Widget _buildCartPanel() {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Warenkorb',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_cartItems.length} Artikel',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Cart Items
          Expanded(
            child: _cartItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.shoppingCart,
                          size: 48,
                          color: Colors.white54,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Warenkorb leer',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      return _CartItemTile(
                        item: item,
                        onQuantityChanged: (qty) =>
                            _updateQuantity(index, qty),
                        onRemove: () => _removeFromCart(index),
                      );
                    },
                  ),
          ),

          // Totals & Payment
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.white10)),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Discount Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Rabatt (%)',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    SizedBox(
                      width: 60,
                      child: TextField(
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: '0',
                          hintStyle: const TextStyle(color: Colors.white54),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                              color: Colors.white24,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            _discountPercent =
                                double.tryParse(value) ?? 0;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Subtotal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Summe',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      '€${_calculateSubtotal().toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                if (_calculateDiscount() > 0) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Rabatt',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                      Text(
                        '-€${_calculateDiscount().toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.white24),
                      bottom: BorderSide(color: Colors.white24),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Gesamtbetrag',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '€${_calculateTotal().toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: AppColors.gold,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Payment Method Selection
                const Text(
                  'Zahlungsart',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildPaymentButton('Bar', 'cash',
                          LucideIcons.wallet),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildPaymentButton('Karte', 'card',
                          LucideIcons.creditCard),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildPaymentButton('EC', 'ec',
                          LucideIcons.creditCard),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Checkout Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _cartItems.isEmpty
                        ? null
                        : () => _showCheckoutDialog(context),
                    icon: const Icon(LucideIcons.checkCircle),
                    label: const Text('Abrechnen'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: Colors.black,
                      disabledBackgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentButton(
    String label,
    String value,
    IconData icon,
  ) {
    final isSelected = _paymentMethod == value;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _paymentMethod = value;
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.gold.withOpacity(0.3)
                : Colors.grey[900],
            border: Border.all(
              color: isSelected ? AppColors.gold : Colors.white24,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.gold : Colors.white54,
                size: 18,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppColors.gold : Colors.white54,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCheckoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Abrechnung',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Gesamtbetrag:',
                  style: TextStyle(color: Colors.white70),
                ),
                Text(
                  '€${_calculateTotal().toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Zahlungsart:',
                  style: TextStyle(color: Colors.white70),
                ),
                Text(
                  _getPaymentMethodLabel(_paymentMethod),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${_cartItems.length} Artikel',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Abbrechen',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _processCheckout();
            },
            child: const Text(
              'Bestätigen',
              style: TextStyle(color: AppColors.gold),
            ),
          ),
        ],
      ),
    );
  }

  String _getPaymentMethodLabel(String method) {
    switch (method) {
      case 'cash':
        return 'Bar';
      case 'card':
        return 'Karte';
      case 'ec':
        return 'EC';
      default:
        return method;
    }
  }

  void _processCheckout() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(LucideIcons.checkCircle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Abrechnung erfolgreich!\n€${_calculateTotal().toStringAsFixed(2)} erhalten',
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );

    // Clear cart
    setState(() {
      _cartItems.clear();
      _discountPercent = 0;
      _paymentMethod = 'cash';
    });
  }
}

class CartItem {
  final SalonServiceDto service;
  int quantity;

  CartItem({
    required this.service,
    required this.quantity,
  });

  double get total => service.price * quantity;
}

class _ServiceTile extends StatelessWidget {
  final SalonServiceDto service;
  final VoidCallback onTap;

  const _ServiceTile({
    required this.service,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                service.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(LucideIcons.clock, size: 12, color: Colors.white54),
                  const SizedBox(width: 4),
                  Text(
                    '${service.durationMinutes}min',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(LucideIcons.euro, size: 12, color: AppColors.gold),
                  const SizedBox(width: 4),
                  Text(
                    '${service.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: AppColors.gold,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItem item;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const _CartItemTile({
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.service.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '€${item.service.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Quantity Controls
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () =>
                        onQuantityChanged(item.quantity - 1),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        LucideIcons.minus,
                        size: 14,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '${item.quantity}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () =>
                        onQuantityChanged(item.quantity + 1),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        LucideIcons.plus,
                        size: 14,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '€${item.total.toStringAsFixed(2)}',
            style: const TextStyle(
              color: AppColors.gold,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onRemove,
              child: const Icon(
                LucideIcons.trash,
                size: 14,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
