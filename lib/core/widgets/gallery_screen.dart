import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import 'design_system_widgets.dart';

/// Gallery System Main Screen
class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen>
    with SingleTickerProviderStateMixin {
  List<GalleryImage> images = [
    GalleryImage(
      id: '1',
      url: 'assets/gallery/img1.jpg',
      title: 'Styling Masterpiece',
      tags: ['styling', 'hair', 'color'],
      likes: 234,
      comments: 12,
    ),
    GalleryImage(
      id: '2',
      url: 'assets/gallery/img2.jpg',
      title: 'Summer Hair Color',
      tags: ['color', 'summer', 'highlights'],
      likes: 567,
      comments: 34,
    ),
    GalleryImage(
      id: '3',
      url: 'assets/gallery/img3.jpg',
      title: 'Wedding Updo',
      tags: ['wedding', 'updo', 'special'],
      likes: 890,
      comments: 56,
    ),
  ];

  List<String> selectedTags = [];
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<GalleryImage> get filteredImages {
    return images.where((image) {
      final matchesSearch = _searchQuery.isEmpty ||
          image.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesTags = selectedTags.isEmpty ||
          selectedTags.every((tag) => image.tags.contains(tag));
      return matchesSearch && matchesTags;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.gray900 : AppColors.gray50,
      appBar: AppBar(
        title: Text('gallery'.tr()),
        backgroundColor: isDark ? AppColors.gray900 : AppColors.gray50,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showUploadDialog(context),
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search photos...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          // Tab Navigation
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Gallery'),
              Tab(text: 'Favorites'),
              Tab(text: 'My Uploads'),
            ],
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGalleryView(),
                _buildFavoritesView(),
                _buildMyUploadsView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryView() {
    final isMobile = MediaQuery.of(context).size.width < 768;

    if (filteredImages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported,
                size: 64, color: AppColors.gray400),
            SizedBox(height: AppSpacing.lg),
            Text('no_images_found'.tr()),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(AppSpacing.lg),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 2 : 4,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemCount: filteredImages.length,
      itemBuilder: (context, index) {
        return _GalleryImageCard(
          image: filteredImages[index],
          onTap: () => _showImageDetail(context, filteredImages[index]),
        );
      },
    );
  }

  Widget _buildFavoritesView() {
    return Center(
      child: Text('Favorites coming soon'),
    );
  }

  Widget _buildMyUploadsView() {
    return Center(
      child: Text('My Uploads coming soon'),
    );
  }

  void _showUploadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _GalleryUploadDialog(
        onUpload: (title, tags, file) {
          setState(() {
            images.add(GalleryImage(
              id: DateTime.now().toString(),
              url: 'assets/gallery/new.jpg',
              title: title,
              tags: tags,
              likes: 0,
              comments: 0,
            ));
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _GalleryFilterSheet(
        selectedTags: selectedTags,
        onTagsSelected: (tags) {
          setState(() => selectedTags = tags);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showImageDetail(BuildContext context, GalleryImage image) {
    showDialog(
      context: context,
      builder: (context) => _GalleryImageDetailDialog(image: image),
    );
  }
}

/// Gallery Image Card
class _GalleryImageCard extends StatefulWidget {
  final GalleryImage image;
  final VoidCallback onTap;

  const _GalleryImageCard({
    Key? key,
    required this.image,
    required this.onTap,
  }) : super(key: key);

  @override
  State<_GalleryImageCard> createState() => _GalleryImageCardState();
}

class _GalleryImageCardState extends State<_GalleryImageCard> {
  bool _isHovered = false;
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Stack(
          children: [
            // Image
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.gray200,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  widget.image.url,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Center(
                        child: Icon(Icons.image, size: 48),
                      ),
                ),
              ),
            ),

            // Overlay on Hover
            if (_isHovered)
              ScaleUpAnimation(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black.withOpacity(0.6),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.info_outline,
                                color: Colors.white),
                            onPressed: widget.onTap,
                          ),
                          IconButton(
                            icon: Icon(
                              _isLiked
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: _isLiked
                                  ? AppColors.error
                                  : Colors.white,
                            ),
                            onPressed: () =>
                                setState(() => _isLiked = !_isLiked),
                          ),
                          IconButton(
                            icon: Icon(Icons.share_outlined,
                                color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            // Title Badge
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: FadeInAnimation(
                child: Container(
                  padding: EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.image.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.favorite_border,
                                  size: 14, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                widget.image.likes.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.comment_outlined,
                                  size: 14, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                widget.image.comments.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Gallery Image Detail Dialog
class _GalleryImageDetailDialog extends StatefulWidget {
  final GalleryImage image;

  const _GalleryImageDetailDialog({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  State<_GalleryImageDetailDialog> createState() =>
      _GalleryImageDetailDialogState();
}

class _GalleryImageDetailDialogState
    extends State<_GalleryImageDetailDialog> {
  bool _isLiked = false;
  List<String> _comments = [
    'Amazing work! 😍',
    'Love the color! 💯',
    'So stunning! ✨',
  ];
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      insetPadding: EdgeInsets.all(AppSpacing.lg),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Close Button
              Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'photo_details'.tr(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              Divider(),

              // Image Preview
              Container(
                width: double.infinity,
                height: 300,
                color: AppColors.gray200,
                child: Image.asset(
                  widget.image.url,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Center(
                        child: Icon(Icons.image, size: 80),
                      ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      widget.image.title,
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    SizedBox(height: AppSpacing.md),

                    // Tags
                    Wrap(
                      spacing: AppSpacing.sm,
                      children: widget.image.tags
                          .map((tag) => Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: AppSpacing.sm,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '#$tag',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppColors.primary,
                                      ),
                                ),
                              ))
                          .toList(),
                    ),
                    SizedBox(height: AppSpacing.lg),

                    // Stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              widget.image.likes.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text('Likes'),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              widget.image.comments.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text('Comments'),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.lg),

                    // Like Button
                    GestureDetector(
                      onTap: () =>
                          setState(() => _isLiked = !_isLiked),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                        ),
                        decoration: BoxDecoration(
                          color: _isLiked
                              ? AppColors.error
                              : AppColors.gray200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: _isLiked
                                    ? Colors.white
                                    : AppColors.gray600,
                              ),
                              SizedBox(width: AppSpacing.md),
                              Text(
                                _isLiked
                                    ? 'Unlike'
                                    : 'Like',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _isLiked
                                      ? Colors.white
                                      : AppColors.gray600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: AppSpacing.lg),
                    Divider(),

                    // Comments Section
                    Text(
                      'Comments (${_comments.length})',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: AppSpacing.md),

                    // Comments List
                    ..._comments.map((comment) => Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: AppSpacing.sm),
                          child: Container(
                            padding: EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.gray800
                                  : AppColors.gray100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: AppColors.primary,
                                ),
                                SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'User Name',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      Text(
                                        comment,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),

                    SizedBox(height: AppSpacing.lg),

                    // Add Comment
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            decoration: InputDecoration(
                              hintText: 'Add a comment...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: AppSpacing.md),
                        GestureDetector(
                          onTap: () {
                            if (_commentController.text.isNotEmpty) {
                              setState(() {
                                _comments.add(_commentController.text);
                                _commentController.clear();
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.send, color: Colors.white),
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
      ),
    );
  }
}

/// Gallery Upload Dialog
class _GalleryUploadDialog extends StatefulWidget {
  final Function(String title, List<String> tags, dynamic file) onUpload;

  const _GalleryUploadDialog({
    Key? key,
    required this.onUpload,
  }) : super(key: key);

  @override
  State<_GalleryUploadDialog> createState() => _GalleryUploadDialogState();
}

class _GalleryUploadDialogState extends State<_GalleryUploadDialog> {
  late TextEditingController _titleController;
  late TextEditingController _tagsController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _tagsController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('upload_photo'.tr()),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Upload Area
            Container(
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.primary,
                  width: 2,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_upload, size: 48),
                    SizedBox(height: AppSpacing.md),
                    Text('Click or drag to upload'),
                  ],
                ),
              ),
            ),
            SizedBox(height: AppSpacing.lg),

            // Title Input
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Photo Title',
                hintText: 'Enter photo title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: AppSpacing.md),

            // Tags Input
            TextField(
              controller: _tagsController,
              decoration: InputDecoration(
                labelText: 'Tags',
                hintText: 'Enter tags separated by commas',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final tags = _tagsController.text
                .split(',')
                .map((tag) => tag.trim())
                .where((tag) => tag.isNotEmpty)
                .toList();

            widget.onUpload(
              _titleController.text,
              tags,
              null,
            );
          },
          child: Text('Upload'),
        ),
      ],
    );
  }
}

/// Gallery Filter Sheet
class _GalleryFilterSheet extends StatefulWidget {
  final List<String> selectedTags;
  final Function(List<String>) onTagsSelected;

  const _GalleryFilterSheet({
    Key? key,
    required this.selectedTags,
    required this.onTagsSelected,
  }) : super(key: key);

  @override
  State<_GalleryFilterSheet> createState() => _GalleryFilterSheetState();
}

class _GalleryFilterSheetState extends State<_GalleryFilterSheet> {
  late List<String> _tags;

  final allTags = [
    'styling',
    'hair',
    'color',
    'cuts',
    'highlights',
    'wedding',
    'updo',
    'special',
    'summer',
    'winter',
  ];

  @override
  void initState() {
    super.initState();
    _tags = List.from(widget.selectedTags);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Filter by Tags',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: allTags
                .map((tag) => GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_tags.contains(tag)) {
                            _tags.remove(tag);
                          } else {
                            _tags.add(tag);
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.md,
                        ),
                        decoration: BoxDecoration(
                          color: _tags.contains(tag)
                              ? AppColors.primary
                              : AppColors.gray200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            color: _tags.contains(tag)
                                ? Colors.white
                                : AppColors.gray900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: GestureDetector(
                  onTap: () => widget.onTagsSelected(_tags),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'Apply',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Gallery Image Model
class GalleryImage {
  final String id;
  final String url;
  final String title;
  final List<String> tags;
  final int likes;
  final int comments;

  GalleryImage({
    required this.id,
    required this.url,
    required this.title,
    required this.tags,
    required this.likes,
    required this.comments,
  });
}
