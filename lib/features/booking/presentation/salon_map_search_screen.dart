import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/salon_search_provider.dart';
import '../../../providers/location_provider.dart';
import '../../salons/data/salon_repository.dart';

/// Salon Map Search Screen - zeigt Salons auf Karte mit Filtern
class SalonMapSearchScreen extends ConsumerStatefulWidget {
  const SalonMapSearchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SalonMapSearchScreenState();
}

class _SalonMapSearchScreenState extends ConsumerState<SalonMapSearchScreen> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  bool _showFilters = false;

  @override
  Widget build(BuildContext context) {
    final locationAsync = ref.watch(userLocationProvider);
    final salonsAsync = ref.watch(filteredSalonsProvider);
    final searchRadius = ref.watch(searchRadiusProvider);
    final filters = ref.watch(salonSearchFiltersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Salons finden'),
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
      body: Stack(
        children: [
          locationAsync.when(
            data: (location) {
              if (location == null) {
                return _buildMapError();
              }

              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(location.latitude, location.longitude),
                  zoom: 12.0,
                ),
                onMapCreated: (controller) {
                  _mapController = controller;
                  _updateMarkers(salonsAsync);
                },
                markers: _markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: false,
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => _buildMapError(),
          ),
          if (_showFilters) _buildFilterPanel(context, filters),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildSalonListBottom(salonsAsync),
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Radius: ${searchRadius.toStringAsFixed(0)} km',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        salonsAsync.maybeWhen(
                          data: (salons) => '${salons.length} Salons',
                          orElse: () => 'Lädt...',
                        ),
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  Slider(
                    value: searchRadius.toDouble(),
                    min: 1,
                    max: 100,
                    divisions: 10,
                    onChanged: (value) {
                      ref.read(searchRadiusProvider.notifier).state = value;
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.mapPin,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          const Text(
            'Standort wird gesucht...',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPanel(BuildContext context, SalonSearchFilters filters) {
    final categoriesAsync = ref.watch(allServiceCategoriesProvider);

    return Positioned(
      top: 80,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Minimum Bewertung',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
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
              Text(
                '${(filters.minRating ?? 0).toStringAsFixed(1)} ⭐',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              const Text(
                'Preisrange',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Min',
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
                        labelText: 'Max',
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
              const SizedBox(height: 16),
              const Text(
                'Service-Kategorien',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              categoriesAsync.when(
                data: (categories) {
                  return Wrap(
                    spacing: 8,
                    children: categories.map((cat) {
                      final isSelected =
                          filters.categories?.contains(cat.id) ?? false;
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
                            categories:
                                newCategories.isEmpty ? null : newCategories,
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
                error: (err, _) =>
                    const Text('Fehler beim Laden der Kategorien'),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(LucideIcons.rotateCcw),
                  label: const Text('Filter zurücksetzen'),
                  onPressed: () {
                    ref.read(salonSearchFiltersProvider.notifier).state =
                        SalonSearchFilters();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSalonListBottom(AsyncValue<List<SalonData>> salonsAsync) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(51, 0, 0, 0),
            blurRadius: 8,
          ),
        ],
      ),
      child: salonsAsync.when(
        data: (salons) {
          if (salons.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.search,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Keine Salons in dieser Region',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }

          return SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(12),
              itemCount: salons.length,
              itemBuilder: (context, index) {
                final salon = salons[index];
                return _buildSalonCard(context, salon);
              },
            ),
          );
        },
        loading: () => Container(
          padding: const EdgeInsets.all(24),
          height: 180,
          child: const Center(child: CircularProgressIndicator()),
        ),
        error: (err, _) => Container(
          padding: const EdgeInsets.all(24),
          height: 180,
          child: Center(
            child: Text('Fehler: $err'),
          ),
        ),
      ),
    );
  }

  Widget _buildSalonCard(BuildContext context, SalonData salon) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${salon.name} selected')),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: Icon(
                    LucideIcons.store,
                    size: 40,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    salon.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  if (salon.rating != null)
                    Row(
                      children: [
                        const Icon(LucideIcons.star,
                            size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          '${salon.rating?.toStringAsFixed(1)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateMarkers(AsyncValue<List<SalonData>> salonsAsync) {
    salonsAsync.whenData((salons) {
      final markers = <Marker>{};
      for (final salon in salons) {
        if (salon.latitude != null && salon.longitude != null) {
          markers.add(
            Marker(
              markerId: MarkerId(salon.id),
              position: LatLng(salon.latitude!, salon.longitude!),
              infoWindow: InfoWindow(
                title: salon.name,
                snippet: salon.rating != null
                    ? '${salon.rating!.toStringAsFixed(1)} ⭐'
                    : null,
              ),
            ),
          );
        }
      }
      setState(() => _markers = markers);
    });
  }
}
