import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/employee_dashboard_provider.dart';
import '../../../models/employee_dashboard_dto.dart';

/// POS Services Tab - displays salon services for sales
class PosServicesTab extends ConsumerStatefulWidget {
  final String salonId;

  const PosServicesTab({
    required this.salonId,
    super.key,
  });

  @override
  ConsumerState<PosServicesTab> createState() => _PosServicesTabState();
}

class _PosServicesTabState extends ConsumerState<PosServicesTab> {
  String? _selectedCategory;
  List<SalonServiceDto> _filteredServices = [];

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
            : services
                .where((s) => s.category == _selectedCategory)
                .toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Filter Chips
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: const Text('Alle'),
                        selected: _selectedCategory == null,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = null;
                          });
                        },
                      ),
                    ),
                    ...categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category ?? 'Sonstiges'),
                          selected: _selectedCategory == category,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = selected ? category : null;
                            });
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Services List
              Text(
                'Services (${_filteredServices.length})',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),

              _filteredServices.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.inbox,
                            size: 48,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Keine Services gefunden',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _filteredServices.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final service = _filteredServices[index];
                        return _buildServiceCard(context, service);
                      },
                    ),
            ],
          ),
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
            Text(
              'Fehler beim Laden der Services',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(salonServicesProvider(widget.salonId));
              },
              icon: const Icon(LucideIcons.rotateCw),
              label: const Text('Erneut versuchen'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, SalonServiceDto service) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Name and Category
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    service.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (service.category != null)
                  Chip(
                    label: Text(
                      service.category!,
                      style: const TextStyle(fontSize: 12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // Description
            if (service.description != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  service.description!,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            // Details Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailItem(
                  LucideIcons.clock,
                  '${service.durationMinutes} min',
                ),
                _buildDetailItem(
                  LucideIcons.euro,
                  '${service.price.toStringAsFixed(2)}€',
                ),
                if (service.depositAmount > 0)
                  _buildDetailItem(
                    LucideIcons.wallet,
                    'Kaution: ${service.depositAmount}€',
                  ),
              ],
            ),

            // Buffers (if not default)
            if (service.bufferBefore > 0 || service.bufferAfter > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    if (service.bufferBefore > 0)
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Text(
                          'Vorher: ${service.bufferBefore}min',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    if (service.bufferAfter > 0)
                      Text(
                        'Nachher: ${service.bufferAfter}min',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),

            // Action Button
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showAddToCart(context, service),
                icon: const Icon(LucideIcons.shoppingCart),
                label: const Text('Zum Warenkorb'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddToCart(BuildContext context, SalonServiceDto service) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${service.name} zum Warenkorb hinzugefügt'),
        action: SnackBarAction(
          label: 'Rückgängig',
          onPressed: () {},
        ),
      ),
    );
  }
}
