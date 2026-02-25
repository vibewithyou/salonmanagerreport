import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/customer_model.dart';
import '../../../providers/customer_provider.dart';
import 'customer_detail_screen.dart';
import 'add_customer_dialog.dart';

class CustomerManagementScreen extends ConsumerStatefulWidget {
  const CustomerManagementScreen({super.key});

  @override
  ConsumerState<CustomerManagementScreen> createState() => _CustomerManagementScreenState();
}

class _CustomerManagementScreenState extends ConsumerState<CustomerManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddCustomerDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddCustomerDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customersAsync = _searchQuery.isEmpty
        ? ref.watch(customersProvider)
        : ref.watch(searchCustomersProvider(_searchQuery));
    final summaryAsync = ref.watch(customerSummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('customer.management'.tr()),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: ElevatedButton.icon(
                onPressed: _showAddCustomerDialog,
                icon: const Icon(Icons.add),
                label: Text('customer.add_new'.tr()),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Statistics Cards
            summaryAsync.when(
              data: (summary) => _buildStatisticsCards(summary),
              loading: () => const SizedBox(
                height: 120,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => SizedBox(
                height: 120,
                child: Center(child: Text('Error: $err')),
              ),
            ),
            const SizedBox(height: 24),
            // Search Bar
            Container(
              decoration: BoxDecoration(gradient: AppTheme.liquidGlass),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'customer.search'.tr(),
                  border: InputBorder.none,
                  icon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                          icon: const Icon(Icons.clear),
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Customers List
            customersAsync.when(
              data: (customers) {
                if (customers.isEmpty) {
                  return Container(
                    decoration: BoxDecoration(gradient: AppTheme.liquidGlass),
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: AppColors.primary.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'customer.no_customers'.tr(),
                          style: AppStyles.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'customer.add_first_customer'.tr(),
                          style: AppStyles.bodyMedium.copyWith(
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: customers.length,
                  itemBuilder: (context, index) {
                    final customer = customers[index];
                    return _buildCustomerCard(customer, context);
                  },
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => Padding(
                padding: const EdgeInsets.all(32),
                child: Center(child: Text('Error: $err')),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsCards(CustomerSummary summary) {
    return Column(
      children: [
        Row(
          children: [
            _buildStatCard(
              'customer.total'.tr(),
              summary.totalCustomers.toString(),
              AppColors.primary,
            ),
            const SizedBox(width: 12),
            _buildStatCard(
              'customer.vip'.tr(),
              summary.vipCustomers.toString(),
              const Color(0xFFE8A08F), // Rose
            ),
            const SizedBox(width: 12),
            _buildStatCard(
              'customer.new_month'.tr(),
              summary.newCustomersThisMonth.toString(),
              Colors.green,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildStatCard(
              'customer.avg_visits'.tr(),
              summary.avgVisitsPerCustomer.toStringAsFixed(1),
              Colors.orange,
            ),
            const SizedBox(width: 12),
            _buildStatCard(
              'customer.avg_spend'.tr(),
              '\$${summary.avgMonthlySpend.toStringAsFixed(2)}',
              Colors.blue,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppStyles.headlineMedium.copyWith(
                color: color,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppStyles.labelSmall.copyWith(fontSize: 10),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerCard(Customer customer, BuildContext context) {
    final fullName = '${customer.firstName} ${customer.lastName}';
    final lastVisitText = customer.lastVisit != null
        ? DateFormat('dd.MM.yyyy').format(customer.lastVisit!)
        : 'customer.never_visited'.tr();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withOpacity(0.2),
            border: customer.isVIP == true
                ? Border.all(color: const Color(0xFFE8A08F), width: 2)
                : null,
          ),
          child: Center(
            child: Text(
              fullName[0].toUpperCase(),
              style: AppStyles.headlineMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                fullName,
                style: AppStyles.titleMedium,
              ),
            ),
            if (customer.isVIP == true)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8A08F).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'VIP',
                  style: AppStyles.labelSmall.copyWith(
                    color: const Color(0xFFE8A08F),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${customer.phone} • ${customer.email}',
              style: AppStyles.labelSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.history, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${'customer.visits'.tr()}: ${customer.totalVisits ?? 0}',
                  style: AppStyles.labelSmall.copyWith(fontSize: 10),
                ),
                const SizedBox(width: 12),
                Text(
                  '${'customer.last_visit'.tr()}: $lastVisitText',
                  style: AppStyles.labelSmall.copyWith(fontSize: 10),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Row(
                children: [
                  const Icon(Icons.person),
                  const SizedBox(width: 12),
                  Text('customer.view_details'.tr()),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CustomerDetailScreen(customerId: customer.id),
                  ),
                );
              },
            ),
            if (customer.isVIP == true)
              PopupMenuItem(
                child: Row(
                  children: [
                    const Icon(Icons.star_outline),
                    const SizedBox(width: 12),
                    Text('customer.remove_vip'.tr()),
                  ],
                ),
                onTap: () {
                  ref
                      .read(customerNotifierProvider.notifier)
                      .toggleVIP(customer.id, false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('customer.vip_removed'.tr()),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
              )
            else
              PopupMenuItem(
                child: Row(
                  children: [
                    const Icon(Icons.star),
                    const SizedBox(width: 12),
                    Text('customer.make_vip'.tr()),
                  ],
                ),
                onTap: () {
                  ref
                      .read(customerNotifierProvider.notifier)
                      .toggleVIP(customer.id, true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('customer.vip_added'.tr()),
                      backgroundColor: const Color(0xFFE8A08F),
                    ),
                  );
                },
              ),
            PopupMenuItem(
              child: Row(
                children: [
                  const Icon(Icons.delete, color: Colors.red),
                  const SizedBox(width: 12),
                  Text('common.delete'.tr()),
                ],
              ),
              onTap: () {
                _showDeleteConfirmation(context, customer);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Customer customer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('customer.delete_title'.tr()),
        content: Text(
          'customer.delete_confirmation'.tr(
            args: ['${customer.firstName} ${customer.lastName}'],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.cancel'.tr()),
          ),
          TextButton(
            onPressed: () {
              ref.read(customerNotifierProvider.notifier).deleteCustomer(customer.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('customer.deleted'.tr()),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('common.delete'.tr()),
          ),
        ],
      ),
    );
  }
}
