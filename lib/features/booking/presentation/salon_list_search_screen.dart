import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/salon_search_provider.dart';
import '../../../providers/location_provider.dart';
import '../../salons/data/salon_repository.dart';

/// Salon List Screen - zeigt Salons in Liste mit Sort/Filter Optionen
class SalonListSearchScreen extends ConsumerStatefulWidget {
  const SalonListSearchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SalonListSearchScreenState();
}

class _SalonListSearchScreenState extends ConsumerState<SalonListSearchScreen> {
  bool _showFilters = false;
  String _sortBy = 'nearest'; // nearest, rating, price

  @override
  Widget build(BuildContext context) {
    final salonsAsync = ref.watch(filteredSalonsProvider);
    final searchRadius = ref.watch(searchRadiusProvider);
    final filters = ref.watch(salonSearchFiltersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Salon-Liste'),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.sliders),
            onPressed: () {
              setState(() => _showFilters = !_showFilters);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Radius & Sort
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.grey.shade100,
            child: Column(
              children: [
                // Radius Slider
                Row(
                  children: [
                    const Icon(LucideIcons.navigation2, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Slider(
                        value: searchRadius.toDouble(),
                        min: 1,
                        max: 100,
                        divisions: 10,
                        label: '${searchRadius.toStringAsFixed(0)} km',
                        onChanged: (value) {
                          ref.read(searchRadiusProvider.notifier).state = value;
                        },
                      ),
                    ),
                    Text(
                      '${searchRadius.toStringAsFixed(0)} km',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Sort Dropdown
                DropdownButton<String>(
                  value: _sortBy,
                  isExpanded: true,
                  underline: Container(),
                  items: [
                    const DropdownMenuItem(
                      value: 'nearest',
                      child: Text('Sortieren: Nächstgelegene zuerst'),
                    ),
                    const DropdownMenuItem(
                      value: 'rating',
                      child: Text('Sortieren: Beste Bewertung'),
                    ),
                    const DropdownMenuItem(
                      value: 'price',
                      child: Text('Sortieren: Günstigste zuerst'),
                    ),
                  ],
                  onChanged: (val) {
                    setState(() => _sortBy = val ?? 'nearest');
                  },
                ),
              ],
            ),
          ),

          // Filter Panel
          if (_showFilters) _buildFilterPanel(context, filters),

          // Salons List
          Expanded(
            child: salonsAsync.when(
              data: (salons) {
                if (salons.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.searchX,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Keine Salons gefunden',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Probiere andere Filter oder einen größeren Radius',
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: salons.length,
                  itemBuilder: (context, index) {
                    final salon = salons[index];
                    return _buildSalonListItem(context, salon);
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (err, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.alertCircle,
                      size: 64,
                      color: Colors.red.shade300,
                    ),
                    const SizedBox(height: 16),
                    const Text('Fehler beim Laden'),
                    const SizedBox(height: 8),
                    Text(err.toString()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPanel(BuildContext context, SalonSearchFilters filters) {
    final categoriesAsync = ref.watch(allServiceCategoriesProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              IconButton(
                icon: const Icon(LucideIcons.x),
                onPressed: () {
                  setState(() => _showFilters = false);
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Rating
          const Text('Mindestbewertung:', style: TextStyle(fontWeight: FontWeight.bold)),
          Slider(
            value: filters.minRating ?? 0,
            min: 0,
            max: 5,
            divisions: 5,
            onChanged: (value) {
              ref.read(salonSearchFiltersProvider.notifier).state =
                  filters.copyWith(minRating: value);
            },
          ),
          const SizedBox(height: 12),

          // Price Range
          const Text('Preisrange:', style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Min €',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    ref.read(salonSearchFiltersProvider.notifier).state =
                        filters.copyWith(minPrice: double.tryParse(val));
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Max €',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    ref.read(salonSearchFiltersProvider.notifier).state =
                        filters.copyWith(maxPrice: double.tryParse(val));
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Categories
          const Text('Kategorien:', style: TextStyle(fontWeight: FontWeight.bold)),
          categoriesAsync.when(
            data: (categories) {
              return Wrap(
                spacing: 8,
                children: categories.map((cat) {
                  final isSelected = filters.categories?.contains(cat.id) ?? false;
                  return FilterChip(
                    label: Text(cat.name),
                    selected: isSelected,
                    onSelected: (selected) {
                      final newCategories =
                          <String>[...(filters.categories ?? <String>[])];
                      if (selected) {
                        newCategories.add(cat.id);
                      } else {
                        newCategories.remove(cat.id);
                      }
                      ref.read(salonSearchFiltersProvider.notifier).state =
                          filters.copyWith(
                            categories: newCategories.isEmpty ? null : newCategories,
                          );
                    },
                  );
                }).toList(),
              );
            },
            loading: () => const SizedBox(
              height: 40,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, _) => const Text('Fehler beim Laden'),
          ),
          const SizedBox(height: 16),

          // Reset & Close
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(LucideIcons.rotateCcw),
                  label: const Text('Zurücksetzen'),
                  onPressed: () {
                    ref.read(salonSearchFiltersProvider.notifier).state =
                        SalonSearchFilters();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(LucideIcons.check),
                  label: const Text('Fertig'),
                  onPressed: () {
                    setState(() => _showFilters = false);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSalonListItem(BuildContext context, SalonData salon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: InkWell(
        onTap: () {
          // Navigate to salon details / booking
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${salon.name} details'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          salon.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (salon.address != null)
                          Row(
                            children: [
                              const Icon(LucideIcons.mapPin, size: 14),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  salon.address!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Rating Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          salon.rating?.toStringAsFixed(1) ?? 'N/A',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (salon.description != null)
                Text(
                  salon.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to booking for this salon
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Termin buchen'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
