import 'package:freezed_annotation/freezed_annotation.dart';

part 'public_salon_model.freezed.dart';
part 'public_salon_model.g.dart';

@freezed
class PublicSalonData with _$PublicSalonData {
  const factory PublicSalonData({
    required String id,
    required String name,
    required String description,
    String? address,
    String? phone,
    String? email,
    String? website,
    String? logoUrl,
    List<String>? gallery,
    @Default([]) List<PublicService> services,
    @Default([]) List<String> openingHours,
  }) = _PublicSalonData;

  factory PublicSalonData.fromJson(Map<String, dynamic> json) => _$PublicSalonDataFromJson(json);
}

@freezed
class PublicService with _$PublicService {
  const factory PublicService({
    required String id,
    required String name,
    required double price,
    required int duration,
    String? description,
  }) = _PublicService;

  factory PublicService.fromJson(Map<String, dynamic> json) => _$PublicServiceFromJson(json);
}
