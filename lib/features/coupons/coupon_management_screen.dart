import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/coupon_provider.dart';
import '../../core/theme/app_theme.dart';

class CouponManagementScreen extends ConsumerWidget {
  const CouponManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final couponsAsync = ref.watch(couponsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coupons & Promotions'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () => _showAddDialog(context, ref)),
        ],
      ),
      body: couponsAsync.when(
        data: (coupons) {
          if (coupons.isEmpty) {
            return const Center(child: Text('No coupons yet. Create your first one!'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: coupons.length,
            itemBuilder: (context, index) {
              final coupon = coupons[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.goldColor,
                    child: const Icon(Icons.local_offer, color: Colors.white),
                  ),
                  title: Text(coupon.code, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${coupon.discountType == 'percentage' ? '${coupon.discountValue}%' : '\$${coupon.discountValue}'} off • Used: ${coupon.usedCount}/${coupon.maxUses ?? "∞"}'),
                  trailing: PopupMenuButton(
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 'delete', child: Text('Delete')),
                    ],
                    onSelected: (value) async {
                      if (value == 'delete') {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Coupon'),
                            content: const Text('Are you sure?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                              ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await ref.read(couponNotifierProvider.notifier).deleteCoupon(coupon.id);
                        }
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final codeController = TextEditingController();
    final valueController = TextEditingController();
    String discountType = 'percentage';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Create Coupon'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: codeController, decoration: const InputDecoration(labelText: 'Coupon Code')),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: discountType,
                items: const [
                  DropdownMenuItem(value: 'percentage', child: Text('Percentage')),
                  DropdownMenuItem(value: 'fixed', child: Text('Fixed Amount')),
                ],
                onChanged: (value) => setState(() => discountType = value!),
                decoration: const InputDecoration(labelText: 'Discount Type'),
              ),
              const SizedBox(height: 16),
              TextField(controller: valueController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Discount Value')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                try {
                  await ref.read(couponNotifierProvider.notifier).createCoupon({
                    'code': codeController.text.toUpperCase(),
                    'discount_type': discountType,
                    'discount_value': double.parse(valueController.text),
                    'max_uses': 100,
                  });
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Coupon created!')));
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
