import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

/// User's current location
class UserLocation {
  final double latitude;
  final double longitude;
  final DateTime fetchedAt;

  UserLocation({
    required this.latitude,
    required this.longitude,
    required this.fetchedAt,
  });

  bool get isExpired => DateTime.now().difference(fetchedAt).inMinutes > 10;
}

/// Provider for fetching user's current location
final userLocationProvider = FutureProvider<UserLocation?>((ref) async {
  try {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return UserLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      fetchedAt: DateTime.now(),
    );
  } catch (e) {
    // Default to Berlin if geolocation fails
    return UserLocation(
      latitude: 52.5200,
      longitude: 13.4050,
      fetchedAt: DateTime.now(),
    );
  }
});

/// Default salon search location (main map center)
/// This can be used if user location is not available
final defaultSearchLocationProvider = StateProvider<UserLocation>((ref) {
  return UserLocation(
    latitude: 52.5200, // Berlin
    longitude: 13.4050,
    fetchedAt: DateTime.now(),
  );
});

/// Selected search radius in km
final searchRadiusProvider = StateProvider<double>((ref) => 50.0);
