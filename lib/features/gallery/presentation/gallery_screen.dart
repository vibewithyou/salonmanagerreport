import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';

/// PHASE 5: GALERIE MIT KI-SUGGESTIONS
///
/// Features:
/// - Grid-Layout für Frisuren-Inspiration
/// - Like/Favorite System
/// - Filter (Haarlänge, Stil, Farbtyp)
/// - KI-Vorschläge
/// - Upload-Funktion (image_picker)
/// - Detail-Modal mit Stylist-Info

class GalleryScreen extends ConsumerStatefulWidget {
  const GalleryScreen({super.key});

  @override
  ConsumerState<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends ConsumerState<GalleryScreen> {
  String _selectedFilter = 'Alle';
  bool _showFavoritesOnly = false;
  final Set<int> _likedImages = {};
  final ImagePicker _picker = ImagePicker();

  final List<Map<String, dynamic>> _galleryItems = [];

  List<Map<String, dynamic>> get _filteredGallery {
    var filtered = _galleryItems.where((item) {
      if (_showFavoritesOnly && !_likedImages.contains(item['id'])) {
        return false;
      }
      if (_selectedFilter == 'Alle') return true;
      if (_selectedFilter == 'Kurz' && item['length'] == 'short') return true;
      if (_selectedFilter == 'Mittel' && item['length'] == 'medium')
        return true;
      if (_selectedFilter == 'Lang' && item['length'] == 'long') return true;
      if (_selectedFilter == 'Blond' && item['color'] == 'blonde') return true;
      if (_selectedFilter == 'Braun' && item['color'] == 'brown') return true;
      if (_selectedFilter == 'Schwarz' && item['color'] == 'black') return true;
      return false;
    }).toList();
    return filtered;
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
              'Galerie & Inspiration',
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
            onPressed: () {
              setState(() {
                _showFavoritesOnly = !_showFavoritesOnly;
              });
            },
            icon: Icon(
              _showFavoritesOnly ? LucideIcons.heart : LucideIcons.heart,
              color: _showFavoritesOnly ? Colors.red : Colors.white54,
            ),
          ),
          IconButton(
            onPressed: () {
              // Search functionality
            },
            icon: const Icon(LucideIcons.search, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Alle'),
                  _buildFilterChip('Kurz'),
                  _buildFilterChip('Mittel'),
                  _buildFilterChip('Lang'),
                  const SizedBox(width: 8),
                  Container(height: 30, width: 1, color: Colors.white24),
                  const SizedBox(width: 8),
                  _buildFilterChip('Blond'),
                  _buildFilterChip('Braun'),
                  _buildFilterChip('Schwarz'),
                ],
              ),
            ),
          ),

          // Gallery Grid
          Expanded(
            child: _filteredGallery.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.image,
                          size: 64,
                          color: Colors.white24,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Keine Bilder gefunden',
                          style: TextStyle(color: Colors.white54),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                    itemCount: _filteredGallery.length,
                    itemBuilder: (context, index) {
                      final item = _filteredGallery[index];
                      final isLiked = _likedImages.contains(item['id']);
                      return _buildGalleryCard(item, isLiked);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _uploadImage,
        backgroundColor: AppColors.gold,
        icon: const Icon(LucideIcons.upload, color: Colors.black),
        label: const Text(
          'Upload',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedFilter = label;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.gold : Colors.grey[900],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.gold : Colors.white24,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGalleryCard(Map<String, dynamic> item, bool isLiked) {
    return InkWell(
      onTap: () => _showImageDetail(item),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isLiked ? Colors.red : Colors.white24,
            width: isLiked ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            // Image Placeholder
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: item['color'] == 'blonde'
                    ? Colors.amber.shade100
                    : item['color'] == 'brown'
                    ? Colors.brown.shade300
                    : Colors.grey.shade800,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.user,
                      size: 48,
                      color: Colors.white.withOpacity(0.5),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['style'],
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Like Button
            Positioned(
              top: 8,
              right: 8,
              child: InkWell(
                onTap: () {
                  setState(() {
                    if (isLiked) {
                      _likedImages.remove(item['id']);
                    } else {
                      _likedImages.add(item['id']);
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isLiked ? LucideIcons.heart : LucideIcons.heart,
                    color: isLiked ? Colors.red : Colors.white,
                    size: 20,
                    fill: isLiked ? 1.0 : 0.0,
                  ),
                ),
              ),
            ),

            // Info Overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          LucideIcons.scissors,
                          size: 12,
                          color: AppColors.gold,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item['stylist'],
                            style: const TextStyle(
                              color: AppColors.gold,
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _buildTag(item['lengthLabel']),
                        const SizedBox(width: 4),
                        _buildTag(item['styleLabel']),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 9),
      ),
    );
  }

  void _showImageDetail(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final liked = _likedImages.contains(item['id']);

          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              border: Border(top: BorderSide(color: AppColors.gold, width: 2)),
            ),
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item['title'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (liked) {
                              _likedImages.remove(item['id']);
                            } else {
                              _likedImages.add(item['id']);
                            }
                          });
                          setModalState(() {});
                        },
                        icon: Icon(
                          LucideIcons.heart,
                          color: liked ? Colors.red : Colors.white54,
                          fill: liked ? 1.0 : 0.0,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(LucideIcons.x, color: Colors.white54),
                      ),
                    ],
                  ),
                ),

                // Image
                Container(
                  height: 250,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: item['color'] == 'blonde'
                        ? Colors.amber.shade100
                        : item['color'] == 'brown'
                        ? Colors.brown.shade300
                        : Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      LucideIcons.image,
                      size: 80,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Details
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stylist Info
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: AppColors.gold.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.gold,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  LucideIcons.user,
                                  color: AppColors.gold,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['stylist'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Row(
                                      children: [
                                        Icon(
                                          LucideIcons.star,
                                          size: 14,
                                          color: AppColors.gold,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          '4.9 (127 Bewertungen)',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Description
                        const Text(
                          'Über diesen Style',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['description'],
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Tags
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildDetailTag(
                              item['lengthLabel'],
                              LucideIcons.ruler,
                            ),
                            _buildDetailTag(
                              item['styleLabel'],
                              LucideIcons.sparkles,
                            ),
                            _buildDetailTag(
                              item['colorLabel'],
                              LucideIcons.paintbrush,
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // KI Suggestions
                        const Text(
                          '✨ Ähnliche Styles',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 120,
                          child: _galleryItems.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Keine Vorschläge vorhanden',
                                    style: TextStyle(color: Colors.white54),
                                  ),
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _galleryItems.length < 4
                                      ? _galleryItems.length
                                      : 4,
                                  itemBuilder: (context, index) {
                                    final suggestion =
                                        _galleryItems[(item['id'] + index + 1) %
                                            _galleryItems.length];
                                    return Container(
                                      width: 100,
                                      margin: const EdgeInsets.only(right: 12),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                          _showImageDetail(suggestion);
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 90,
                                              decoration: BoxDecoration(
                                                color:
                                                    suggestion['color'] ==
                                                        'blonde'
                                                    ? Colors.amber.shade100
                                                    : suggestion['color'] ==
                                                          'brown'
                                                    ? Colors.brown.shade300
                                                    : Colors.grey.shade800,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  LucideIcons.user,
                                                  color: Colors.white
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              suggestion['style'] as String,
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 11,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),

                        const SizedBox(height: 24),

                        // Action Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Termin-Anfrage für "${item['title']}" gesendet!',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            icon: const Icon(LucideIcons.calendar),
                            label: const Text('Termin buchen mit diesem Style'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.gold,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildDetailTag(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.gold),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Future<void> _uploadImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(LucideIcons.checkCircle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Bild "${image.name}" hochgeladen!'),
                ),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Upload: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
