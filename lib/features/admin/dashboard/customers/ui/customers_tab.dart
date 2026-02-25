import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/customer_providers.dart';
import '../data/models/customer_profile.dart';
import 'widgets/customer_list_item.dart';
import 'widgets/upcoming_birthdays_card.dart';
import 'customer_detail_screen.dart';
import 'customer_form_dialog.dart';

class CustomersTab extends ConsumerStatefulWidget {
  final String salonId;

  const CustomersTab({super.key, required this.salonId});

  @override
  ConsumerState<CustomersTab> createState() => _CustomersTabState();
}

class _CustomersTabState extends ConsumerState<CustomersTab> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    // Load customers on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(customerListProvider(widget.salonId).notifier).loadCustomers();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    ref.read(customerSearchQueryProvider.notifier).state = query;
    ref
        .read(customerListProvider(widget.salonId).notifier)
        .searchCustomers(query);
  }

  Future<void> _refresh() async {
    await ref.read(customerListProvider(widget.salonId).notifier).refresh();
  }

  void _showAddCustomerDialog() {
    showDialog(
      context: context,
      builder: (context) => CustomerFormDialog(
        salonId: widget.salonId,
        onSave: (customer) async {
          await ref
              .read(customerListProvider(widget.salonId).notifier)
              .createCustomer(customer);
        },
      ),
    );
  }

  void _navigateToCustomerDetail(CustomerProfile customer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerDetailScreen(customer: customer),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customerListState = ref.watch(customerListProvider(widget.salonId));
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Header with search and add button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.people, color: theme.primaryColor, size: 28),
                    const SizedBox(width: 12),
                    const Text(
                      'Kundenverwaltung',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Suche nach Name, Email, Telefon oder Adresse...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: _showAddCustomerDialog,
                      icon: const Icon(Icons.person_add),
                      label: const Text('Neuer Kunde'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        minimumSize: const Size(0, 56),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Customer list
          Expanded(
            child: customerListState.when(
              initial: () => const Center(child: CircularProgressIndicator()),
              loading: () => const Center(child: CircularProgressIndicator()),
              loaded: (customers) {
                if (customers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchController.text.isEmpty
                              ? 'Keine Kunden vorhanden'
                              : 'Keine Kunden gefunden',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        if (_searchController.text.isEmpty) ...[
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _showAddCustomerDialog,
                            icon: const Icon(Icons.person_add),
                            label: const Text('Ersten Kunden hinzufügen'),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Birthday Card (only when not searching)
                      if (_searchController.text.isEmpty) ...[
                        UpcomingBirthdaysCard(customers: customers),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            const Icon(Icons.people_outline, size: 20),
                            const SizedBox(width: 8),
                            const Text(
                              'Alle Kunden',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: theme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${customers.length} ${customers.length == 1 ? "Kunde" : "Kunden"}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: theme.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                      // Customer List
                      ...customers.map((customer) {
                        return CustomerListItem(
                          customer: customer,
                          onTap: () => _navigateToCustomerDetail(customer),
                          onDelete: () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Kunde löschen?'),
                                content: Text(
                                  'Möchten Sie ${customer.fullName} wirklich löschen?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Abbrechen'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    child: const Text('Löschen'),
                                  ),
                                ],
                              ),
                            );

                            if (confirmed == true && mounted) {
                              await ref
                                  .read(
                                    customerListProvider(
                                      widget.salonId,
                                    ).notifier,
                                  )
                                  .deleteCustomer(customer.id);
                            }
                          },
                        );
                      }),
                    ],
                  ),
                );
              },
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        'Fehler beim Laden der Kunden:\n$message',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _refresh,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Erneut versuchen'),
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
}
