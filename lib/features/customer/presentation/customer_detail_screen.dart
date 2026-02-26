import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/customer_model.dart';
import '../../../providers/customer_provider.dart';

class CustomerDetailScreen extends ConsumerStatefulWidget {
  final String customerId;

  const CustomerDetailScreen({
    required this.customerId,
    super.key,
  });

  @override
  ConsumerState<CustomerDetailScreen> createState() =>
      _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends ConsumerState<CustomerDetailScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _notesController;

  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _populateFields(Customer customer) {
    _firstNameController.text = customer.firstName;
    _lastNameController.text = customer.lastName;
    _emailController.text = customer.email;
    _phoneController.text = customer.phone;
    _addressController.text = customer.address ?? '';
    _notesController.text = customer.notes ?? '';
  }

  void _saveChanges() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(customerNotifierProvider.notifier).updateCustomer(
        widget.customerId,
        {
          'first_name': _firstNameController.text,
          'last_name': _lastNameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'address': _addressController.text,
          'notes': _notesController.text,
        },
      );
      setState(() => _isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('customer.updated'.tr()),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('customer.update_failed'.tr()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final customerAsync = ref.watch(customerDetailProvider(widget.customerId));
    final transactionsAsync = ref.watch(customerTransactionsProvider(widget.customerId));
    // TODO: Replace with real provider for before/after media
    final beforeAfterMedia = <Map<String, dynamic>>[ // Dummy data
      {
        'bookingId': 'B123',
        'date': '2026-02-21',
        'before': [
          'https://via.placeholder.com/120x120?text=Vorher1',
          'https://via.placeholder.com/120x120?text=Vorher2',
        ],
        'after': [
          'https://via.placeholder.com/120x120?text=Nachher1',
        ],
      },
      {
        'bookingId': 'B124',
        'date': '2026-02-22',
        'before': [
          'https://via.placeholder.com/120x120?text=Vorher',
        ],
        'after': [
          'https://via.placeholder.com/120x120?text=Nachher',
        ],
      },
    ];

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('customer.details'.tr()),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Info'),
              Tab(text: 'Statistik'),
              Tab(text: 'Transaktionen'),
              Tab(text: 'Bilder'),
            ],
          ),
          actions: [
            if (!_isEditing)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: TextButton.icon(
                    onPressed: () {
                      if (customerAsync.valueOrNull != null) {
                        _populateFields(customerAsync.value!);
                        setState(() => _isEditing = true);
                      }
                    },
                    icon: const Icon(Icons.edit),
                    label: Text('common.edit'.tr()),
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () => setState(() => _isEditing = false),
                      child: Text('common.cancel'.tr()),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _saveChanges,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text('common.save'.tr()),
                    ),
                  ],
                ),
              ),
          ],
        ),
        body: TabBarView(
          children: [
            // Info Tab
            customerAsync.when(
              data: (customer) {
                if (customer == null) {
                  return Center(child: Text('customer.not_found'.tr()));
                }
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // ...existing code...
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
            // Statistik Tab
            customerAsync.when(
              data: (customer) {
                if (customer == null) {
                  return Center(child: Text('customer.not_found'.tr()));
                }
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // ...existing code...
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
            // Transaktionen Tab
            transactionsAsync.when(
              data: (transactions) {
                if (transactions.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text('customer.no_transactions'.tr()),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    return ListTile(
                      title: Text(tx.description),
                      subtitle: Text(
                        DateFormat('dd.MM.yyyy HH:mm')
                            .format(DateTime.parse(tx.date.toString())),
                      ),
                      trailing: Text(
                        '\$${tx.amount.toStringAsFixed(2)}',
                        style: AppStyles.titleMedium.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
            // Bilder Tab
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bilder nach Buchung', style: AppStyles.headlineSmall),
                  const SizedBox(height: 16),
                  ...beforeAfterMedia.map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Buchung: ${entry['bookingId']} • ${entry['date']}', style: AppStyles.labelSmall),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text('Vorher:', style: AppStyles.labelSmall),
                            const SizedBox(width: 8),
                            ...List<Widget>.from((entry['before'] as List).map((url) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(url, width: 80, height: 80, fit: BoxFit.cover),
                              ),
                            ))),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text('Nachher:', style: AppStyles.labelSmall),
                            const SizedBox(width: 8),
                            ...List<Widget>.from((entry['after'] as List).map((url) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(url, width: 80, height: 80, fit: BoxFit.cover),
                              ),
                            ))),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(icon, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: AppStyles.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppStyles.headlineMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppStyles.labelSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
