import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/customer_model.dart';
import '../../../providers/customer_provider.dart';
import '../application/customer_notes_provider.dart';
import '../domain/customer_note.dart';

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
  late TextEditingController _newNoteController;

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
    _newNoteController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    _newNoteController.dispose();
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

  Future<void> _saveChanges() async {
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
    } catch (_) {
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

  Future<void> _addNote(Customer customer) async {
    final note = _newNoteController.text.trim();
    if (note.isEmpty) return;

    try {
      await ref.read(customerNotesNotifierProvider.notifier).addNote(
            customerId: widget.customerId,
            salonId: customer.salonId,
            note: note,
          );
      _newNoteController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notiz gespeichert')),
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notiz konnte nicht gespeichert werden'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteNote(String noteId) async {
    try {
      await ref.read(customerNotesNotifierProvider.notifier).deleteNote(
            customerId: widget.customerId,
            noteId: noteId,
          );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notiz konnte nicht gelöscht werden'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final customerAsync = ref.watch(customerDetailProvider(widget.customerId));
    final transactionsAsync =
        ref.watch(customerTransactionsProvider(widget.customerId));
    final customerNotesAsync = ref.watch(customerNotesProvider(widget.customerId));

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('customer.details'.tr()),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
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
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Übersicht'),
              Tab(text: 'Historie'),
              Tab(text: 'Notizen'),
            ],
          ),
        ),
        body: customerAsync.when(
          data: (customer) {
            if (customer == null) {
              return Center(
                child: Text('customer.not_found'.tr()),
              );
            }

            return TabBarView(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildCustomerInfoCard(customer),
                      const SizedBox(height: 24),
                      _buildStatisticsCard(customer),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _buildTransactionsCard(transactionsAsync),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _buildNotesTab(customer, customerNotesAsync),
                ),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (err, _) => Center(
            child: Text('Error: $err'),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerInfoCard(Customer customer) {
    return Container(
      decoration: BoxDecoration(gradient: AppTheme.liquidGlass),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.2),
              border: customer.isVIP == true
                  ? Border.all(
                      color: const Color(0xFFE8A08F),
                      width: 3,
                    )
                  : null,
            ),
            child: Center(
              child: Text(
                '${customer.firstName[0]}${customer.lastName[0]}'.toUpperCase(),
                style: AppStyles.headlineLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_isEditing)
            Column(
              children: [
                TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'customer.first_name'.tr(),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'customer.last_name'.tr(),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'customer.email'.tr(),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'customer.phone'.tr(),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'customer.address'.tr(),
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    labelText: 'customer.notes'.tr(),
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
              ],
            )
          else
            Column(
              children: [
                Text(
                  '${customer.firstName} ${customer.lastName}',
                  style: AppStyles.headlineSmall,
                ),
                const SizedBox(height: 8),
                if (customer.isVIP == true)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8A08F).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'VIP Member',
                      style: AppStyles.labelSmall.copyWith(
                        color: const Color(0xFFE8A08F),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                _buildInfoRow('📧', customer.email),
                const SizedBox(height: 12),
                _buildInfoRow('📱', customer.phone),
                if (customer.address != null && customer.address!.isNotEmpty)
                  Column(
                    children: [
                      const SizedBox(height: 12),
                      _buildInfoRow('📍', customer.address!),
                    ],
                  ),
                if (customer.notes != null && customer.notes!.isNotEmpty)
                  Column(
                    children: [
                      const SizedBox(height: 12),
                      _buildInfoRow('📝', customer.notes!),
                    ],
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard(Customer customer) {
    return Container(
      decoration: BoxDecoration(gradient: AppTheme.liquidGlass),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'customer.statistics'.tr(),
            style: AppStyles.headlineSmall,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatItem(
                'Total Visits',
                customer.totalVisits?.toString() ?? '0',
                Icons.event,
              ),
              const SizedBox(width: 12),
              _buildStatItem(
                'Total Spent',
                '\$${customer.totalSpent?.toStringAsFixed(2) ?? '0.00'}',
                Icons.attach_money,
              ),
            ],
          ),
          if (customer.lastVisit != null)
            Column(
              children: [
                const SizedBox(height: 12),
                _buildInfoRow(
                  '📅',
                  'customer.last_visit_date'.tr(
                    args: [DateFormat('dd.MM.yyyy').format(customer.lastVisit!)],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTransactionsCard(AsyncValue<List<CustomerTransaction>> transactionsAsync) {
    return Container(
      decoration: BoxDecoration(gradient: AppTheme.liquidGlass),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'customer.transaction_history'.tr(),
            style: AppStyles.headlineSmall,
          ),
          const SizedBox(height: 16),
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
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (err, _) => Center(
              child: Text('Error: $err'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesTab(
    Customer customer,
    AsyncValue<List<CustomerNote>> customerNotesAsync,
  ) {
    return Container(
      decoration: BoxDecoration(gradient: AppTheme.liquidGlass),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Interne Notizen', style: AppStyles.headlineSmall),
          const SizedBox(height: 12),
          TextField(
            controller: _newNoteController,
            decoration: InputDecoration(
              hintText: 'Notiz hinzufügen…',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () => _addNote(customer),
                icon: const Icon(Icons.send),
              ),
            ),
            maxLines: 3,
            minLines: 2,
          ),
          const SizedBox(height: 16),
          customerNotesAsync.when(
            data: (notes) {
              if (notes.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('Noch keine Notizen vorhanden.'),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: notes.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(note.note),
                    subtitle: Text(
                      DateFormat('dd.MM.yyyy HH:mm').format(note.createdAt),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _deleteNote(note.id),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Text('Fehler beim Laden: $err'),
          ),
        ],
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
