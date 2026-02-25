import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../services/supabase_service.dart';

class InventoryScreen extends StatefulWidget {
  final String? salonId;

  const InventoryScreen({super.key, this.salonId});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _items = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String? _salonId;

  @override
  void initState() {
    super.initState();
    _loadInventory();
  }

  @override
  void didUpdateWidget(covariant InventoryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.salonId != widget.salonId) {
      _loadInventory();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInventory() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      String? salonId = widget.salonId;

      if (salonId == null || salonId.isEmpty) {
        final user = _supabaseService.currentUser;
        if (user == null) {
          setState(() {
            _isLoading = false;
            _items = [];
          });
          return;
        }

        final employee = await _supabaseService.client
            .from('employees')
            .select('salon_id')
            .eq('user_id', user.id)
            .maybeSingle();

        salonId = employee?['salon_id'] as String?;

        if (salonId == null || salonId.isEmpty) {
          final salon = await _supabaseService.client
              .from('salons')
              .select('id')
              .eq('owner_id', user.id)
              .maybeSingle();
          salonId = salon?['id'] as String?;
        }
      }

      if (salonId == null || salonId.isEmpty) {
        setState(() {
          _salonId = null;
          _items = [];
          _isLoading = false;
        });
        return;
      }

      final data = await _supabaseService.client
          .from('inventory')
          .select('*')
          .eq('salon_id', salonId)
          .order('name', ascending: true);

      setState(() {
        _salonId = salonId;
        _items = (data as List).cast<Map<String, dynamic>>();
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _items = [];
      });
    }
  }

  List<Map<String, dynamic>> get _filteredItems {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return _items;
    return _items.where((item) {
      final name = (item['name'] ?? '').toString().toLowerCase();
      return name.contains(query);
    }).toList();
  }

  List<Map<String, dynamic>> get _lowStockItems {
    return _items.where((item) {
      final quantity = (item['quantity'] as num?)?.toInt() ?? 0;
      final minQuantity = (item['min_quantity'] as num?)?.toInt() ?? 5;
      return quantity <= minQuantity;
    }).toList();
  }

  List<Map<String, dynamic>> get _expiringSoonItems {
    return _items.where((item) {
      final expiryDateRaw = item['expiry_date'];
      if (expiryDateRaw == null) return false;

      final expiryDate = DateTime.tryParse(expiryDateRaw.toString());
      if (expiryDate == null) return false;

      final daysUntilExpiry = expiryDate.difference(DateTime.now()).inDays;

      return daysUntilExpiry > 0 && daysUntilExpiry <= 30;
    }).toList();
  }

  String _formatDate(String? value) {
    if (value == null || value.isEmpty) return '-';
    final date = DateTime.tryParse(value);
    if (date == null) return value;
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year.toString();
    return '$d.$m.$y';
  }

  Future<void> _deleteItem(String id) async {
    await _supabaseService.client.from('inventory').delete().eq('id', id);
    await _loadInventory();
  }

  Future<void> _openItemDialog({Map<String, dynamic>? item}) async {
    final isEdit = item != null;
    final nameController = TextEditingController(
      text: (item?['name'] ?? '').toString(),
    );
    final descriptionController = TextEditingController(
      text: (item?['description'] ?? '').toString(),
    );
    final quantityController = TextEditingController(
      text: ((item?['quantity'] as num?)?.toInt() ?? 0).toString(),
    );
    final minQuantityController = TextEditingController(
      text: ((item?['min_quantity'] as num?)?.toInt() ?? 5).toString(),
    );
    final priceController = TextEditingController(
      text: ((item?['price'] as num?)?.toDouble() ?? 0).toString(),
    );
    final unitController = TextEditingController(
      text: (item?['unit'] ?? 'Stück').toString(),
    );
    DateTime? expiryDate = DateTime.tryParse(
      (item?['expiry_date'] ?? '').toString(),
    );

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(isEdit ? 'Artikel bearbeiten' : 'Artikel hinzufügen'),
              content: SizedBox(
                width: 520,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Beschreibung',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: quantityController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Menge',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: minQuantityController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Mindestmenge',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: priceController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: const InputDecoration(
                                labelText: 'Preis (€)',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: unitController,
                              decoration: const InputDecoration(
                                labelText: 'Einheit',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Ablaufdatum'),
                        subtitle: Text(
                          expiryDate == null
                              ? 'Kein Datum gewählt'
                              : _formatDate(expiryDate!.toIso8601String()),
                        ),
                        trailing: TextButton(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: expiryDate ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setDialogState(() {
                                expiryDate = picked;
                              });
                            }
                          },
                          child: const Text('Wählen'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Abbrechen'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_salonId == null ||
                        nameController.text.trim().isEmpty) {
                      return;
                    }

                    final payload = {
                      'name': nameController.text.trim(),
                      'description': descriptionController.text.trim().isEmpty
                          ? null
                          : descriptionController.text.trim(),
                      'quantity':
                          int.tryParse(quantityController.text.trim()) ?? 0,
                      'min_quantity':
                          int.tryParse(minQuantityController.text.trim()) ?? 5,
                      'price': double.tryParse(
                        priceController.text.trim().replaceAll(',', '.'),
                      ),
                      'unit': unitController.text.trim().isEmpty
                          ? 'Stück'
                          : unitController.text.trim(),
                      'expiry_date': expiryDate
                          ?.toIso8601String()
                          .split('T')
                          .first,
                    };

                    if (isEdit) {
                      await _supabaseService.client
                          .from('inventory')
                          .update(payload)
                          .eq('id', item['id']);
                    } else {
                      await _supabaseService.client.from('inventory').insert({
                        ...payload,
                        'salon_id': _salonId,
                      });
                    }

                    if (!mounted) return;
                    Navigator.of(context).pop();
                    await _loadInventory();
                  },
                  child: Text(isEdit ? 'Speichern' : 'Anlegen'),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    descriptionController.dispose();
    quantityController.dispose();
    minQuantityController.dispose();
    priceController.dispose();
    unitController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'inventory.title'.tr(),
                style: Theme.of(
                  context,
                ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 180,
                child: ElevatedButton.icon(
                  onPressed: () => _openItemDialog(),
                  icon: const Icon(LucideIcons.plus),
                  label: Text('inventory.addItem'.tr()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 40),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_lowStockItems.isNotEmpty || _expiringSoonItems.isNotEmpty)
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                if (_lowStockItems.isNotEmpty)
                  _AlertCard(
                    icon: LucideIcons.alertTriangle,
                    title: 'Niedriger Bestand',
                    subtitle:
                        '${_lowStockItems.length} Artikel unter Mindestmenge',
                  ),
                if (_expiringSoonItems.isNotEmpty)
                  _AlertCard(
                    icon: LucideIcons.clock3,
                    title: 'Bald ablaufend',
                    subtitle:
                        '${_expiringSoonItems.length} Artikel laufen bald ab',
                  ),
              ],
            ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              prefixIcon: const Icon(LucideIcons.search),
              hintText: 'Suchen...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: () => context.go('/suppliers'),
                child: const Text('Lieferanten verwalten'),
              ),
              OutlinedButton(
                onPressed: () => context.go('/service-consumption'),
                child: const Text('Service-Verbrauch definieren'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_filteredItems.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                'Keine Lager-Daten vorhanden',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          else
            ..._filteredItems.map((item) {
              final quantity = (item['quantity'] as num?)?.toInt() ?? 0;
              final minQuantity = (item['min_quantity'] as num?)?.toInt() ?? 5;
              final isLowStock = quantity <= minQuantity;
              final expiry = item['expiry_date']?.toString();
              final isExpiring =
                  expiry != null &&
                  expiry.isNotEmpty &&
                  DateTime.tryParse(expiry) != null &&
                  DateTime.parse(expiry).difference(DateTime.now()).inDays <=
                      30;

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.black12),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              (item['name'] ?? '').toString(),
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          if (isLowStock)
                            const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Chip(
                                label: Text('Niedrig'),
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                          if (isExpiring)
                            const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Chip(
                                label: Text('Ablaufend'),
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            '${'inventory.stock'.tr()}: $quantity ${(item['unit'] ?? 'Stück')}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const Spacer(),
                          if (item['price'] != null)
                            Text(
                              '€ ${(item['price'] as num).toStringAsFixed(2)}',
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Min: $minQuantity',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (expiry != null && expiry.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'Läuft ab: ${_formatDate(expiry)}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          TextButton.icon(
                            onPressed: () => _openItemDialog(item: item),
                            icon: const Icon(LucideIcons.edit2, size: 16),
                            label: const Text('Bearbeiten'),
                          ),
                          const SizedBox(width: 8),
                          TextButton.icon(
                            onPressed: () => _deleteItem(item['id'] as String),
                            icon: const Icon(LucideIcons.trash2, size: 16),
                            label: const Text('Löschen'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _AlertCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.gold),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
