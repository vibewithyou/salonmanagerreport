import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';

/// PHASE 6: INTERAKTIVE KARTE MIT SALON-STANDORTEN
/// 
/// Features:
/// - Google Maps Integration
/// - User Location Detection (geolocator)
/// - Custom Gold Markers für Salons
/// - Filter (Distanz, Preis, Rating, Verfügbarkeit)
/// - Marker Tap → Salon Details BottomSheet
/// - "Route anzeigen" + "Termin buchen" Buttons
/// - Distanz-Berechnung zu allen Salons

class SalonMapScreen extends ConsumerStatefulWidget {
  const SalonMapScreen({super.key});

  @override
  ConsumerState<SalonMapScreen> createState() => _SalonMapScreenState();
}

class _SalonMapScreenState extends ConsumerState<SalonMapScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  bool _isLoadingLocation = false;
  
  // Filter States
  double _maxDistance = 50.0; // km
  String _priceRange = 'Alle';
  double _minRating = 0.0;
  String _availability = 'Alle';

  // Initial camera position (Germany - Berlin)
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(52.5200, 13.4050),
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    
    try {
      // Check permissions
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location services are disabled.'),
            backgroundColor: Colors.orange,
          ),
        );
        setState(() => _isLoadingLocation = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permissions are denied.'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() => _isLoadingLocation = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permissions are permanently denied.'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isLoadingLocation = false);
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _isLoadingLocation = false;
      });

      // Move camera to user location
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(position.latitude, position.longitude),
            14,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoadingLocation = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error getting location: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  double _calculateDistance(double lat, double lng) {
    if (_currentPosition == null) return 0;
    return Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      lat,
      lng,
    ) / 1000; // Convert to km
  }

  List<Map<String, dynamic>> get _filteredSalons {
    var filtered = _mockSalons.where((salon) {
      // Distance filter
      if (_currentPosition != null) {
        final distance = _calculateDistance(salon['lat'] as double, salon['lng'] as double);
        if (distance > _maxDistance) return false;
      }

      // Price range filter
      if (_priceRange != 'Alle' && salon['priceRange'] != _priceRange) {
        return false;
      }

      // Rating filter
      if ((salon['rating'] as num) < _minRating) return false;

      // Availability filter (simplified mock logic)
      if (_availability == 'Heute' && !(salon['availableToday'] as bool)) return false;
      if (_availability == 'Diese Woche' && !(salon['availableThisWeek'] as bool)) {
        return false;
      }

      return true;
    }).toList();

    return filtered;
  }

  Set<Marker> _buildMarkers() {
    final markers = <Marker>{};

    // Add user location marker
    if (_currentPosition != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: 'Mein Standort'),
        ),
      );
    }

    // Add salon markers
    for (var salon in _filteredSalons) {
      markers.add(
        Marker(
          markerId: MarkerId(salon['id']),
          position: LatLng(salon['lat'], salon['lng']),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
          infoWindow: InfoWindow(
            title: salon['name'],
            snippet: '${salon['rating']}★ • ${salon['priceRange']}',
          ),
          onTap: () => _showSalonDetails(salon),
        ),
      );
    }

    return markers;
  }

  void _showSalonDetails(Map<String, dynamic> salon) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildSalonDetailsSheet(salon),
    );
  }

  Widget _buildSalonDetailsSheet(Map<String, dynamic> salon) {
    final distance = _currentPosition != null
        ? _calculateDistance(salon['lat'], salon['lng'])
        : null;

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(top: BorderSide(color: AppColors.gold, width: 2)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.gold.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.gold, width: 2),
                  ),
                  child: const Icon(
                    LucideIcons.scissors,
                    color: AppColors.gold,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        salon['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(LucideIcons.star,
                              size: 16, color: AppColors.gold),
                          const SizedBox(width: 4),
                          Text(
                            '${salon['rating']} (${salon['reviewsCount']} Bewertungen)',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(LucideIcons.x, color: Colors.white54),
                ),
              ],
            ),
          ),

          const Divider(color: Colors.white12),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Distance & Price Range
                  Row(
                    children: [
                      if (distance != null) ...[
                        _buildInfoChip(
                          LucideIcons.navigation,
                          '${distance.toStringAsFixed(1)} km',
                        ),
                        const SizedBox(width: 8),
                      ],
                      _buildInfoChip(
                        LucideIcons.euro,
                        salon['priceRange'],
                      ),
                      const SizedBox(width: 8),
                      _buildInfoChip(
                        LucideIcons.clock,
                        salon['availableToday'] ? 'Verfügbar' : 'Ausgebucht',
                        color: salon['availableToday'] ? Colors.green : Colors.red,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Address
                  const Text(
                    'Adresse',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.mapPin,
                            size: 20, color: AppColors.gold),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                salon['address'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '${salon['postalCode']} ${salon['city']}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Opening Hours
                  const Text(
                    'Öffnungszeiten',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        _buildOpeningHoursRow('Mo-Fr', salon['openingHours']),
                        const SizedBox(height: 4),
                        _buildOpeningHoursRow('Sa', '09:00 - 14:00'),
                        const SizedBox(height: 4),
                        _buildOpeningHoursRow('So', 'Geschlossen'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Contact
                  const Text(
                    'Kontakt',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(LucideIcons.phone,
                                size: 18, color: AppColors.gold),
                            const SizedBox(width: 12),
                            Text(
                              salon['phone'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(LucideIcons.mail,
                                size: 18, color: AppColors.gold),
                            const SizedBox(width: 12),
                            Text(
                              salon['email'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _openRoute(salon),
                          icon: const Icon(LucideIcons.navigation),
                          label: const Text('Route anzeigen'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.gold,
                            side: const BorderSide(color: AppColors.gold),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Termin buchen bei "${salon['name']}"'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          icon: const Icon(LucideIcons.calendar),
                          label: const Text('Termin buchen'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gold,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: (color ?? AppColors.gold).withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color ?? AppColors.gold),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color ?? AppColors.gold),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color ?? AppColors.gold,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpeningHoursRow(String day, String hours) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          day,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),
        Text(
          hours,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Future<void> _openRoute(Map<String, dynamic> salon) async {
    final lat = salon['lat'];
    final lng = salon['lng'];
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Konnte Route nicht öffnen'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              border: Border(top: BorderSide(color: AppColors.gold, width: 2)),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Text(
                        'Filter',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            _maxDistance = 50.0;
                            _priceRange = 'Alle';
                            _minRating = 0.0;
                            _availability = 'Alle';
                          });
                          setState(() {});
                        },
                        child: const Text(
                          'Zurücksetzen',
                          style: TextStyle(color: AppColors.gold),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(LucideIcons.x, color: Colors.white54),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white12),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Maximale Entfernung',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Slider(
                                value: _maxDistance,
                                min: 1,
                                max: 100,
                                divisions: 99,
                                activeColor: AppColors.gold,
                                inactiveColor: Colors.grey[800],
                                label: '${_maxDistance.toInt()} km',
                                onChanged: (value) {
                                  setModalState(() => _maxDistance = value);
                                },
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${_maxDistance.toInt()} km',
                                style: const TextStyle(
                                  color: AppColors.gold,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        const Text(
                          'Preisniveau',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: ['Alle', '€', '€€', '€€€'].map((price) {
                            final isSelected = _priceRange == price;
                            return InkWell(
                              onTap: () {
                                setModalState(() => _priceRange = price);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.gold
                                      : Colors.grey[900],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.gold
                                        : Colors.white24,
                                  ),
                                ),
                                child: Text(
                                  price,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.black
                                        : Colors.white,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 24),

                        const Text(
                          'Mindestbewertung',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [0.0, 3.0, 4.0, 4.5].map((rating) {
                            final isSelected = _minRating == rating;
                            return InkWell(
                              onTap: () {
                                setModalState(() => _minRating = rating);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.gold
                                      : Colors.grey[900],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.gold
                                        : Colors.white24,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      LucideIcons.star,
                                      size: 16,
                                      color: isSelected
                                          ? Colors.black
                                          : AppColors.gold,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      rating == 0 ? 'Alle' : '$rating+',
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.black
                                            : Colors.white,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 24),

                        const Text(
                          'Verfügbarkeit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                              ['Alle', 'Heute', 'Diese Woche'].map((avail) {
                            final isSelected = _availability == avail;
                            return InkWell(
                              onTap: () {
                                setModalState(() => _availability = avail);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.gold
                                      : Colors.grey[900],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.gold
                                        : Colors.white24,
                                  ),
                                ),
                                child: Text(
                                  avail,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.black
                                        : Colors.white,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {});
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gold,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Anwenden (${_filteredSalons.length} Salons)',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.gold, Colors.amber.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Salon-Karte',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showFilters,
            icon: const Icon(LucideIcons.sliders, color: Colors.white),
          ),
          IconButton(
            onPressed: _getCurrentLocation,
            icon: _isLoadingLocation
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(AppColors.gold),
                    ),
                  )
                : const Icon(LucideIcons.navigation, color: AppColors.gold),
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialPosition,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            markers: _buildMarkers(),
            onMapCreated: (controller) {
              _mapController = controller;
              if (_currentPosition != null) {
                controller.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    LatLng(
                      _currentPosition!.latitude,
                      _currentPosition!.longitude,
                    ),
                    14,
                  ),
                );
              }
            },
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.gold),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.map, color: AppColors.gold, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${_filteredSalons.length} Salons gefunden',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (_priceRange != 'Alle' ||
                      _minRating > 0 ||
                      _availability != 'Alle' ||
                      _maxDistance < 50) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Filter aktiv',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final _mockSalons = [
  {
    'id': 'b916b1e4-7c0d-4624-b32f-ee17ace0a484',
    'name': "BARBER's",
    'address': 'Motitzstraße 6',
    'postalCode': '09599',
    'city': 'Freiberg',
    'lat': 52.5208,
    'lng': 13.4095,
    'rating': 4.8,
    'reviewsCount': 127,
    'priceRange': '€€',
    'phone': '01745152501',
    'email': 'josephinelehmann29@yahoo.com',
    'openingHours': '08:00 - 20:00',
    'availableToday': true,
    'availableThisWeek': true,
  },
  {
    'id': '0dcdb535-0294-49ff-96c6-45a4fedd552c',
    'name': 'test',
    'address': 'Schulweg 52c',
    'postalCode': '09599',
    'city': 'freiberg',
    'lat': 50.928421,
    'lng': 13.3263715,
    'rating': 4.5,
    'reviewsCount': 89,
    'priceRange': '€',
    'phone': '+491637506395',
    'email': 'tobiasbecker2005@gmail.com',
    'openingHours': '09:00 - 18:00',
    'availableToday': true,
    'availableThisWeek': true,
  },
  {
    'id': 'b9fbbe58-3b16-43d3-88af-0570ecd3d653',
    'name': 'tests',
    'address': 'fischerstraße 32',
    'postalCode': '09599',
    'city': 'Freiberg',
    'lat': 53.5511,
    'lng': 9.9937,
    'rating': 4.9,
    'reviewsCount': 234,
    'priceRange': '€€€',
    'phone': '',
    'email': '',
    'openingHours': '09:00 - 18:00',
    'availableToday': false,
    'availableThisWeek': true,
  },
  {
    'id': 'beea33aa-0269-4035-b031-04cd0205c28f',
    'name': 'testabc',
    'address': 'moritzstraße 7',
    'postalCode': '09599',
    'city': 'freiberg',
    'lat': 50.9195395,
    'lng': 13.3426528,
    'rating': 4.7,
    'reviewsCount': 156,
    'priceRange': '€€',
    'phone': '+491637506395',
    'email': 'tobiasbecker2005@gmail.com',
    'openingHours': '09:00 - 18:00',
    'availableToday': true,
    'availableThisWeek': true,
  },
  {
    'id': 'a5ef344f-067f-40aa-bf40-50025bff93c2',
    'name': 'hairbecker',
    'address': 'Stollberger Straße 85',
    'postalCode': '09119',
    'city': 'Chemnitz',
    'lat': 50.8176359,
    'lng': 12.9029928,
    'rating': 4.6,
    'reviewsCount': 98,
    'priceRange': '€',
    'phone': '+491637506395',
    'email': 'tobiasbecker2005@gmail.com',
    'openingHours': '09:00 - 18:00',
    'availableToday': true,
    'availableThisWeek': true,
  },
  {
    'id': '57dda459-88ce-4b5b-8a72-73b672bc572e',
    'name': 'haaairbecker',
    'address': 'Stollberger Straße 85',
    'postalCode': '09119',
    'city': 'Chemnitz',
    'lat': 50.8176359,
    'lng': 12.9029928,
    'rating': 4.4,
    'reviewsCount': 67,
    'priceRange': '€€',
    'phone': '+491637506395',
    'email': 'tobiasbecker2005@gmail.com',
    'openingHours': '09:00 - 18:00',
    'availableToday': false,
    'availableThisWeek': true,
  },
  {
    'id': 'c0efc8a5-e808-433d-be94-1841af145d8e',
    'name': 'hairbeckerr',
    'address': 'Stollberger Straße 85',
    'postalCode': '09119',
    'city': 'Chemnitz',
    'lat': 50.8176359,
    'lng': 12.9029928,
    'rating': 4.3,
    'reviewsCount': 45,
    'priceRange': '€',
    'phone': '+491637506395',
    'email': 'tobiasbecker2005@gmail.com',
    'openingHours': '09:00 - 18:00',
    'availableToday': true,
    'availableThisWeek': true,
  },
  {
    'id': 'dc2fb202-aa62-47a4-9408-2d81616c40ec',
    'name': 'hairrbecker',
    'address': 'Stollberger Straße 86',
    'postalCode': '09',
    'city': 'Chemnitz',
    'lat': 50.814054,
    'lng': 12.897851,
    'rating': 4.2,
    'reviewsCount': 34,
    'priceRange': '€€€',
    'phone': '+491637506395',
    'email': 'tobiasbecker2005@gmail.com',
    'openingHours': '09:00 - 18:00',
    'availableToday': true,
    'availableThisWeek': true,
  },
  {
    'id': 'dd387360-748e-4756-9c83-cfb98589d28b',
    'name': 'test',
    'address': 'Peterstraße 27',
    'postalCode': '09130',
    'city': 'Chemnitz',
    'lat': 50.8394942,
    'lng': 12.9355024,
    'rating': 4.0,
    'reviewsCount': 23,
    'priceRange': '€',
    'phone': '',
    'email': '',
    'openingHours': '09:00 - 18:00',
    'availableToday': false,
    'availableThisWeek': false,
  },
];
