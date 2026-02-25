import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/employee_dashboard_dto.dart';
import '../../../providers/employee_dashboard_provider.dart';

/// CustomersTab Widget - displays salon customers with search and filter
class CustomersTab extends ConsumerStatefulWidget {
  final String salonId;

  const CustomersTab({
    required this.salonId,
    super.key,
  });

  @override
  ConsumerState<CustomersTab> createState() => _CustomersTabState();
}

class _CustomersTabState extends ConsumerState<CustomersTab> {
  late TextEditingController _searchController;
  String _sortBy = 'name'; // name, visits, spending
  bool _ascending = true;
  List<SalonCustomerDto> _filteredCustomers = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      setState(() {
        _filterCustomers();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCustomers() {
    final query = _searchController.text.toLowerCase().trim();
    
    _filteredCustomers = _filteredCustomers.where((customer) {
      final name = '${customer.firstName} ${customer.lastName}'.toLowerCase();
      final email = customer.email?.toLowerCase() ?? '';
      final phone = customer.phone ?? '';
      return name.contains(query) || email.contains(query) || phone.contains(query);
    }).toList();

    _sortCustomers();
  }

  void _sortCustomers() {
    switch (_sortBy) {
      case 'visits':
        _filteredCustomers.sort((a, b) => (b.appointments.length).compareTo(a.appointments.length));
        break;
      case 'spending':
        _filteredCustomers.sort((a, b) => (b.totalSpending).compareTo(a.totalSpending));
        break;
      case 'name':
      default:
        _filteredCustomers.sort((a, b) => 
          '${a.firstName} ${a.lastName}'.compareTo('${b.firstName} ${b.lastName}')
        );
    }
    
    if (!_ascending) {
      _filteredCustomers = _filteredCustomers.reversed.toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(salonCustomersProvider(widget.salonId));

    return customersAsync.when(
      data: (customers) {
        _filteredCustomers = List.from(customers);
        _filterCustomers();

        return Column(
          children: [
            // Search Bar
            Container(
              color: Colors.black,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Search Field
                  TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Suche nach Name, Email oder Telefon...',
                      hintStyle: const TextStyle(color: Colors.white54),
                      prefixIcon: const Icon(LucideIcons.search, color: AppColors.gold),
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.gold, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.gold, width: 2),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(LucideIcons.x, color: AppColors.gold),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _filterCustomers());
                              },
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Sort & Filter Options
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildSortChip('Name', 'name'),
                        const SizedBox(width: 8),
                        _buildSortChip('Besuche', 'visits'),
                        const SizedBox(width: 8),
                        _buildSortChip('Ausgaben', 'spending'),
                        const SizedBox(width: 8),
                        FilterChip(
                          label: Icon(
                            _ascending ? LucideIcons.arrowUp : LucideIcons.arrowDown,
                            size: 14,
                            color: _sortBy.isNotEmpty ? AppColors.gold : Colors.white70,
                          ),
                          onSelected: (selected) {
                            setState(() {
                              _ascending = !_ascending;
                              _sortCustomers();
                            });
                          },
                          backgroundColor: Colors.grey[900],
                          selectedColor: AppColors.gold.withOpacity(0.3),
                          side: BorderSide(
                            color: _sortBy.isNotEmpty ? AppColors.gold : Colors.white24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Customer List
            Expanded(
              child: _filteredCustomers.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      itemCount: _filteredCustomers.length,
                      itemBuilder: (context, index) {
                        return _CustomerCard(
                          customer: _filteredCustomers[index],
                          onTap: () => _showCustomerDetails(
                            context,
                            _filteredCustomers[index],
                          ),
                        );
                      },
                    ),
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
              'Fehler beim Laden der Kunden',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(salonCustomersProvider(widget.salonId));
              },
              icon: const Icon(LucideIcons.rotateCw),
              label: const Text('Erneut versuchen'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortChip(String label, String value) {
    final isSelected = _sortBy == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _sortBy = selected ? value : 'name';
          _sortCustomers();
        });
      },
      backgroundColor: Colors.grey[900],
      selectedColor: AppColors.gold.withOpacity(0.3),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.gold : Colors.white70,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.gold : Colors.white24,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.inbox,
              size: 48,
              color: AppColors.gold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Keine Kunden gefunden',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Versuchen Sie eine andere Suche',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showCustomerDetails(BuildContext context, SalonCustomerDto customer) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _CustomerDetailsSheet(customer: customer),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  final SalonCustomerDto customer;
  final VoidCallback onTap;

  const _CustomerCard({
    required this.customer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.gold.withOpacity(0.6), AppColors.gold.withOpacity(0.3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.gold, width: 2),
                ),
                child: Center(
                  child: Text(
                    '${customer.firstName[0]}${customer.lastName[0]}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Customer Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${customer.firstName} ${customer.lastName}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (customer.email != null)
                      Text(
                        customer.email!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(LucideIcons.calendar, size: 12, color: AppColors.gold),
                        const SizedBox(width: 4),
                        Text(
                          '${customer.appointments.length} Besuche',
                          style: const TextStyle(
                            color: AppColors.gold,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(LucideIcons.euro, size: 12, color: AppColors.gold),
                        const SizedBox(width: 4),
                        Text(
                          '€${customer.totalSpending.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: AppColors.gold,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Chevron
              const Icon(LucideIcons.chevronRight, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomerDetailsSheet extends StatelessWidget {
  final SalonCustomerDto customer;

  const _CustomerDetailsSheet({required this.customer});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(top: BorderSide(color: AppColors.gold, width: 2)),
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.gold.withOpacity(0.6), AppColors.gold.withOpacity(0.3)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.gold, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        '${customer.firstName[0]}${customer.lastName[0]}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${customer.firstName} ${customer.lastName}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Kunde seit ${DateFormat('d. MMM yyyy', 'de').format(customer.createdAt)}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(LucideIcons.x, color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Contact Information
              _buildDetailSection(
                'Kontaktinformation',
                [
                  if (customer.phone != null)
                    _buildDetailItem(LucideIcons.phone, 'Telefon', customer.phone!),
                  if (customer.email != null)
                    _buildDetailItem(LucideIcons.mail, 'E-Mail', customer.email!),
                ],
              ),
              const SizedBox(height: 24),

              // Statistics
              _buildStatisticsGrid(),
              const SizedBox(height: 24),

              // Appointment History
              _buildDetailSection(
                'Buchungshistorie (${customer.appointments.length})',
                [
                  if (customer.appointments.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Noch keine Buchungen',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    )
                  else
                    ...customer.appointments
                        .asMap()
                        .entries
                        .take(5)
                        .map((entry) => _buildAppointmentItem(entry.value))
                        .toList(),
                  if (customer.appointments.length > 5)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        'und ${customer.appointments.length - 5} weitere...',
                        style: const TextStyle(
                          color: AppColors.gold,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),

              // Action Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(LucideIcons.messageSquare),
                  label: const Text('Nachricht senden'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(LucideIcons.phone),
                  label: const Text('Anrufen'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.gold,
                    side: const BorderSide(color: AppColors.gold),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsGrid() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.gold.withOpacity(0.2), Colors.amber.withOpacity(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStat('Besuche', '${customer.appointments.length}', LucideIcons.calendar),
          Container(height: 40, width: 1, color: AppColors.gold.withOpacity(0.3)),
          _buildStat('Gesamtausgaben', '€${customer.totalSpending.toStringAsFixed(2)}', LucideIcons.euro),
          Container(height: 40, width: 1, color: AppColors.gold.withOpacity(0.3)),
          _buildStat(
            'Letzter Besuch',
            customer.lastVisitDate != null
                ? DateFormat('d. MMM', 'de').format(customer.lastVisitDate!)
                : 'Keine',
            LucideIcons.calendarDays,
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.gold, size: 20),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.gold,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDetailSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(LucideIcons.info, color: AppColors.gold, size: 18),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...items,
      ],
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.gold, size: 18),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentItem(AppointmentSummaryDto appointment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(LucideIcons.calendar, color: AppColors.gold, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('d. MMMM yyyy • HH:mm', 'de').format(appointment.startTime),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                Text(
                  'Status: ${_getStatusLabel(appointment.status)}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (appointment.price != null)
            Text(
              '€${appointment.price!.toStringAsFixed(2)}',
              style: const TextStyle(
                color: AppColors.gold,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
        ],
      ),
    );
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'completed':
        return 'Abgeschlossen';
      case 'cancelled':
        return 'Abgebrochen';
      case 'confirmed':
        return 'Bestätigt';
      case 'pending':
        return 'Ausstehend';
      default:
        return status;
    }
  }
}
