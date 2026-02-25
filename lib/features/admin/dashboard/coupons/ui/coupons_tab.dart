import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../customers/data/models/customer_profile.dart';
import '../../customers/state/customer_providers.dart';
import '../state/coupon_providers.dart';
import '../data/models/coupon.dart';

class CouponsTab extends ConsumerStatefulWidget {
  final String salonId;

  const CouponsTab({super.key, required this.salonId});

  @override
  ConsumerState<CouponsTab> createState() => _CouponsTabState();
}

class _CouponsTabState extends ConsumerState<CouponsTab> {
  @override
  Widget build(BuildContext context) {
    final couponListState = ref.watch(
      couponListNotifierProvider(widget.salonId),
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                IconButton(
                  tooltip: 'Zurück',
                  onPressed: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    } else {
                      context.go('/admin?tab=marketing');
                    }
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Gutscheine & Rabatte',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 220,
                  child: ElevatedButton.icon(
                    onPressed: () => _showCreateCouponDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Neuer Gutschein'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Coupon list
            Expanded(
              child: couponListState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (message) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text('Fehler: $message'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref
                            .read(
                              couponListNotifierProvider(
                                widget.salonId,
                              ).notifier,
                            )
                            .loadCoupons(),
                        child: const Text('Erneut versuchen'),
                      ),
                    ],
                  ),
                ),
                loaded: (coupons) {
                  if (coupons.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.local_offer_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Keine Gutscheine vorhanden',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Erstellen Sie Ihren ersten Gutschein',
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: coupons.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final coupon = coupons[index];
                      return _CouponCard(
                        coupon: coupon,
                        salonId: widget.salonId,
                        onEdit: () => _showEditCouponDialog(context, coupon),
                        onDelete: () => _confirmDelete(context, coupon),
                        onRedeem: () =>
                            _showRedeemCouponDialog(context, coupon),
                        onToggleStatus: (isActive) => ref
                            .read(
                              couponListNotifierProvider(
                                widget.salonId,
                              ).notifier,
                            )
                            .toggleCouponStatus(coupon.id, isActive),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateCouponDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _CouponFormDialog(
        salonId: widget.salonId,
        onSave: (data) async {
          await ref
              .read(couponListNotifierProvider(widget.salonId).notifier)
              .createCoupon(data);
        },
      ),
    );
  }

  void _showEditCouponDialog(BuildContext context, Coupon coupon) {
    showDialog(
      context: context,
      builder: (context) => _CouponFormDialog(
        salonId: widget.salonId,
        coupon: coupon,
        onSave: (data) async {
          await ref
              .read(couponListNotifierProvider(widget.salonId).notifier)
              .updateCoupon(coupon.id, data);
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, Coupon coupon) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gutschein löschen'),
        content: Text(
          'Möchten Sie den Gutschein "${coupon.code}" wirklich löschen?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await ref
                  .read(couponListNotifierProvider(widget.salonId).notifier)
                  .deleteCoupon(coupon.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Gutschein gelöscht')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
  }

  void _showRedeemCouponDialog(BuildContext context, Coupon coupon) {
    showDialog(
      context: context,
      builder: (context) => _RedeemCouponDialog(
        salonId: widget.salonId,
        coupon: coupon,
        onRedeem: (customerId, transactionId) async {
          await ref
              .read(couponListNotifierProvider(widget.salonId).notifier)
              .redeemCoupon(
                couponId: coupon.id,
                customerProfileId: customerId,
                transactionId: transactionId,
              );
        },
      ),
    );
  }
}

class _CouponCard extends ConsumerStatefulWidget {
  final Coupon coupon;
  final String salonId;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onRedeem;
  final Function(bool) onToggleStatus;

  const _CouponCard({
    required this.coupon,
    required this.salonId,
    required this.onEdit,
    required this.onDelete,
    required this.onRedeem,
    required this.onToggleStatus,
  });

  @override
  ConsumerState<_CouponCard> createState() => _CouponCardState();
}

class _CouponCardState extends ConsumerState<_CouponCard> {
  bool _showRedemptions = false;

  @override
  Widget build(BuildContext context) {
    final coupon = widget.coupon;
    final redemptionCountAsync = ref.watch(
      couponRedemptionCountProvider(coupon.id),
    );
    final dateFormat = DateFormat('dd.MM.yyyy');
    final now = DateTime.now();
    final inDateRange =
        (coupon.startDate == null || !now.isBefore(coupon.startDate!)) &&
        (coupon.endDate == null || !now.isAfter(coupon.endDate!));
    final canRedeem = coupon.isActive && inDateRange;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Coupon icon and code
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: coupon.isActive
                        ? Colors.green[100]
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.local_offer,
                        color: coupon.isActive
                            ? Colors.green[700]
                            : Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        coupon.code,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: coupon.isActive
                              ? Colors.green[700]
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: coupon.isActive ? Colors.green : Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    coupon.isActive ? 'Aktiv' : 'Inaktiv',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Actions
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        widget.onEdit();
                        break;
                      case 'toggle':
                        widget.onToggleStatus(!coupon.isActive);
                        break;
                      case 'redeem':
                        if (canRedeem) {
                          widget.onRedeem();
                        }
                        break;
                      case 'delete':
                        widget.onDelete();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text('Bearbeiten'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'toggle',
                      child: Row(
                        children: [
                          Icon(
                            coupon.isActive
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          const SizedBox(width: 8),
                          Text(coupon.isActive ? 'Deaktivieren' : 'Aktivieren'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'redeem',
                      child: Row(
                        children: [
                          Icon(Icons.redeem),
                          SizedBox(width: 8),
                          Text('Einlösen'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Löschen', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Title and description
            if (coupon.title != null) ...[
              Text(
                coupon.title!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
            ],
            if (coupon.description != null) ...[
              Text(
                coupon.description!,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
            ],
            // Discount info
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    coupon.discountType == 'percentage'
                        ? '${coupon.discountValue.toInt()}% Rabatt'
                        : '${coupon.discountValue.toStringAsFixed(2)} € Rabatt',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                redemptionCountAsync.when(
                  data: (count) => Text(
                    'Eingelöst: $count mal',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  loading: () => const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  error: (_, __) => const Text('Fehler beim Laden'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: canRedeem ? widget.onRedeem : null,
                  icon: const Icon(Icons.redeem),
                  label: const Text('Einlösen'),
                ),
                const SizedBox(width: 12),
                TextButton.icon(
                  onPressed: () {
                    setState(() => _showRedemptions = !_showRedemptions);
                  },
                  icon: Icon(
                    _showRedemptions ? Icons.expand_less : Icons.expand_more,
                  ),
                  label: Text(
                    _showRedemptions
                        ? 'Einlösungen ausblenden'
                        : 'Einlösungen anzeigen',
                  ),
                ),
              ],
            ),
            if (!canRedeem)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Gutschein ist deaktiviert oder außerhalb des Gültigkeitszeitraums.',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ),
            if (_showRedemptions) ...[
              const SizedBox(height: 12),
              _RedemptionsList(couponId: coupon.id),
            ],
            const SizedBox(height: 8),
            // Date range
            if (coupon.startDate != null || coupon.endDate != null) ...[
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    'Gültig: ${coupon.startDate != null ? dateFormat.format(coupon.startDate!) : 'Sofort'} - ${coupon.endDate != null ? dateFormat.format(coupon.endDate!) : 'Unbegrenzt'}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ],
            // Target tags
            if (coupon.targetTags != null && coupon.targetTags!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.label, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Ziel-Tags: ${coupon.targetTags!.join(', ')}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RedemptionsList extends ConsumerWidget {
  final String couponId;

  const _RedemptionsList({required this.couponId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final redemptionsAsync = ref.watch(couponRedemptionsProvider(couponId));
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: redemptionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Text('Fehler beim Laden: $error'),
        data: (redemptions) {
          if (redemptions.isEmpty) {
            return const Text('Keine Einlösungen vorhanden.');
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Einlösungen',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...redemptions.map((redemption) {
                final customerName =
                    redemption.customerName ?? 'Unbekannter Kunde';
                final redeemedAt = dateFormat.format(redemption.redeemedAt);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.person, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(child: Text(customerName)),
                      Text(
                        redeemedAt,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

class _RedeemCouponDialog extends ConsumerStatefulWidget {
  final String salonId;
  final Coupon coupon;
  final Future<void> Function(String customerId, String? transactionId)
  onRedeem;

  const _RedeemCouponDialog({
    required this.salonId,
    required this.coupon,
    required this.onRedeem,
  });

  @override
  ConsumerState<_RedeemCouponDialog> createState() =>
      _RedeemCouponDialogState();
}

class _RedeemCouponDialogState extends ConsumerState<_RedeemCouponDialog> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _transactionIdController =
      TextEditingController();
  String? _selectedCustomerId;
  bool _isSaving = false;

  @override
  void dispose() {
    _searchController.dispose();
    _transactionIdController.dispose();
    super.dispose();
  }

  List<CustomerProfile> _filterCustomers(
    List<CustomerProfile> customers,
    String query,
  ) {
    if (query.isEmpty) return customers;
    final q = query.toLowerCase();
    return customers.where((customer) {
      return customer.firstName.toLowerCase().contains(q) ||
          customer.lastName.toLowerCase().contains(q) ||
          (customer.email?.toLowerCase().contains(q) ?? false) ||
          (customer.phone?.contains(query) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final customerState = ref.watch(customerListProvider(widget.salonId));

    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gutschein einlösen: ${widget.coupon.code}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Kunde suchen',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: customerState.when(
                initial: () => const Center(child: CircularProgressIndicator()),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (message) => Center(child: Text('Fehler: $message')),
                loaded: (customers) {
                  final filtered = _filterCustomers(
                    customers,
                    _searchController.text,
                  );
                  if (filtered.isEmpty) {
                    return const Center(child: Text('Keine Kunden gefunden.'));
                  }

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final customer = filtered[index];
                      return RadioListTile<String>(
                        value: customer.id,
                        groupValue: _selectedCustomerId,
                        title: Text(customer.fullName),
                        subtitle: Text(
                          customer.email ??
                              customer.phone ??
                              'Keine Kontaktdaten',
                        ),
                        onChanged: (value) {
                          setState(() => _selectedCustomerId = value);
                        },
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _transactionIdController,
              decoration: const InputDecoration(
                labelText: 'Transaktions-ID (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isSaving
                      ? null
                      : () => Navigator.of(context).pop(),
                  child: const Text('Abbrechen'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _isSaving || _selectedCustomerId == null
                      ? null
                      : () async {
                          setState(() => _isSaving = true);
                          try {
                            await widget.onRedeem(
                              _selectedCustomerId!,
                              _transactionIdController.text.trim().isEmpty
                                  ? null
                                  : _transactionIdController.text.trim(),
                            );
                            ref.invalidate(
                              couponRedemptionCountProvider(widget.coupon.id),
                            );
                            ref.invalidate(
                              couponRedemptionsProvider(widget.coupon.id),
                            );
                            if (mounted) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Gutschein eingelöst'),
                                ),
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Fehler: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } finally {
                            if (mounted) {
                              setState(() => _isSaving = false);
                            }
                          }
                        },
                  child: _isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Einlösen'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CouponFormDialog extends StatefulWidget {
  final String salonId;
  final Coupon? coupon;
  final Future<void> Function(Map<String, dynamic>) onSave;

  const _CouponFormDialog({
    required this.salonId,
    this.coupon,
    required this.onSave,
  });

  @override
  State<_CouponFormDialog> createState() => _CouponFormDialogState();
}

class _CouponFormDialogState extends State<_CouponFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codeController;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _discountValueController;
  late TextEditingController _minPointsController;

  String _discountType = 'percentage';
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isActive = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.coupon?.code ?? '');
    _titleController = TextEditingController(text: widget.coupon?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.coupon?.description ?? '',
    );
    _discountValueController = TextEditingController(
      text: widget.coupon?.discountValue.toString() ?? '',
    );
    _minPointsController = TextEditingController(
      text: widget.coupon?.minPoints?.toString() ?? '',
    );
    _discountType = widget.coupon?.discountType ?? 'percentage';
    _startDate = widget.coupon?.startDate;
    _endDate = widget.coupon?.endDate;
    _isActive = widget.coupon?.isActive ?? true;
  }

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _discountValueController.dispose();
    _minPointsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final data = <String, dynamic>{
        'code': _codeController.text.toUpperCase(),
        'title': _titleController.text.isEmpty ? null : _titleController.text,
        'description': _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        'discount_type': _discountType,
        'discount_value': double.parse(_discountValueController.text),
        'start_date': _startDate?.toIso8601String(),
        'end_date': _endDate?.toIso8601String(),
        'min_points': _minPointsController.text.isEmpty
            ? null
            : double.parse(_minPointsController.text),
        'is_active': _isActive,
      };

      await widget.onSave(data);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.coupon == null
                  ? 'Gutschein erstellt'
                  : 'Gutschein aktualisiert',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: (isStartDate ? _startDate : _endDate) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM.yyyy');

    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.coupon == null
                      ? 'Neuer Gutschein'
                      : 'Gutschein bearbeiten',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // Code
                TextFormField(
                  controller: _codeController,
                  decoration: const InputDecoration(
                    labelText: 'Gutscheincode *',
                    hintText: 'z.B. SUMMER2024',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte einen Code eingeben';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Title
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Titel',
                    hintText: 'z.B. Sommer-Aktion',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Beschreibung',
                    hintText: 'Details zum Gutschein',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                // Discount Type & Value
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _discountType,
                        decoration: const InputDecoration(
                          labelText: 'Rabatt-Typ',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'percentage',
                            child: Text('Prozent (%)'),
                          ),
                          DropdownMenuItem(
                            value: 'fixed',
                            child: Text('Fester Betrag (€)'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() => _discountType = value!);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _discountValueController,
                        decoration: InputDecoration(
                          labelText: 'Wert *',
                          hintText: _discountType == 'percentage'
                              ? '10'
                              : '5.00',
                          border: const OutlineInputBorder(),
                          suffixText: _discountType == 'percentage' ? '%' : '€',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Bitte einen Wert eingeben';
                          }
                          final number = double.tryParse(value);
                          if (number == null || number <= 0) {
                            return 'Ungültiger Wert';
                          }
                          if (_discountType == 'percentage' && number > 100) {
                            return 'Max. 100%';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Date range
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context, true),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Startdatum',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            _startDate != null
                                ? dateFormat.format(_startDate!)
                                : 'Sofort',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context, false),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Enddatum',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            _endDate != null
                                ? dateFormat.format(_endDate!)
                                : 'Unbegrenzt',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Min Points (for loyalty)
                TextFormField(
                  controller: _minPointsController,
                  decoration: const InputDecoration(
                    labelText: 'Mindest-Punkte',
                    hintText: 'Optional (für Treueprogramm)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                // Active switch
                SwitchListTile(
                  title: const Text('Gutschein aktiv'),
                  value: _isActive,
                  onChanged: (value) {
                    setState(() => _isActive = value);
                  },
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 24),

                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isSaving
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: const Text('Abbrechen'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _isSaving ? null : _save,
                      child: _isSaving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              widget.coupon == null ? 'Erstellen' : 'Speichern',
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
