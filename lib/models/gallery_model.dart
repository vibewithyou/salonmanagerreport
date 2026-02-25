import 'package:freezed_annotation/freezed_annotation.dart';

part 'gallery_model.freezed.dart';
part 'gallery_model.g.dart';

@freezed
class GalleryImage with _$GalleryImage {
  const factory GalleryImage({
    required String id,
    required String salonId,
    required String imageUrl,
    required String title,
    String? description,
    List<String>? tags,
    int? likes,
    bool? isFeatured,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _GalleryImage;

  factory GalleryImage.fromJson(Map<String, dynamic> json) => _$GalleryImageFromJson(json);
}
