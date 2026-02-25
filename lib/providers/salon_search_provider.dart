import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'location_provider.dart';
import '../features/salons/data/salon_repository.dart';
import '../features/services/data/service_repository.dart';

/// Filter criteria for salon search
class SalonSearchFilters {
  final double? minRating;
  final double? minPrice;
  final double? maxPrice;
  final List<String>? categories;
  final bool? hasAvailability;

  SalonSearchFilters({
    this.minRating,
    this.minPrice,
    this.maxPrice,
    this.categories,
    this.hasAvailability,
  });

  SalonSearchFilters copyWith({
    double? minRating,
    double? minPrice,
    double? maxPrice,
    List<String>? categories,
    bool? hasAvailability,
  }) {
    return SalonSearchFilters(
      minRating: minRating ?? this.minRating,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      categories: categories ?? this.categories,
      hasAvailability: hasAvailability ?? this.hasAvailability,
    );
  }
}

/// Provider for salon search filters
final salonSearchFiltersProvider = StateProvider<SalonSearchFilters>((ref) {
  return SalonSearchFilters();
});

/// Provider for salons within radius based on current location
final salonsWithinRadiusProvider = FutureProvider<List<SalonData>>((ref) async {
  final locationAsync = ref.watch(userLocationProvider);
  final searchRadius = ref.watch(searchRadiusProvider);
  final salonRepository = ref.watch(salonRepositoryProvider);

  return locationAsync.when(
    data: (location) {
      if (location == null) {
        return salonRepository.getSalonsWithinRadius(
          latitude: 52.5200, // Berlin default
          longitude: 13.4050,
          radiusKm: searchRadius,
        );
      }
      return salonRepository.getSalonsWithinRadius(
        latitude: location.latitude,
        longitude: location.longitude,
        radiusKm: searchRadius,
      );
    },
    loading: () => [],
    error: (err, stack) => [],
  );
});

/// Provider for filtered salons within radius
final filteredSalonsProvider = FutureProvider<List<SalonData>>((ref) async {
  final locationAsync = ref.watch(userLocationProvider);
  final searchRadius = ref.watch(searchRadiusProvider);
  final filters = ref.watch(salonSearchFiltersProvider);
  final salonRepository = ref.watch(salonRepositoryProvider);

  return locationAsync.when(
    data: (location) {
      if (location == null) {
        return salonRepository.getSalonsWithinRadiusFiltered(
          latitude: 52.5200, // Berlin default
          longitude: 13.4050,
          radiusKm: searchRadius,
          minRating: filters.minRating,
          minPrice: filters.minPrice,
          maxPrice: filters.maxPrice,
          categories: filters.categories,
        );
      }
      return salonRepository.getSalonsWithinRadiusFiltered(
        latitude: location.latitude,
        longitude: location.longitude,
        radiusKm: searchRadius,
        minRating: filters.minRating,
        minPrice: filters.minPrice,
        maxPrice: filters.maxPrice,
        categories: filters.categories,
      );
    },
    loading: () => [],
    error: (err, stack) => [],
  );
});

/// Provider for all service categories (for filter UI)
final allServiceCategoriesProvider = FutureProvider<List<ServiceCategory>>((ref) async {
  final serviceRepository = ref.watch(serviceRepositoryProvider);
  try {
    return await serviceRepository.getAllCategories();
  } catch (e) {
    return [];
  }
});
