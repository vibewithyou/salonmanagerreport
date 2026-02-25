import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_profile.freezed.dart';
part 'customer_profile.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
@freezed
class CustomerProfile with _$CustomerProfile {
  const factory CustomerProfile({
    required String id,
    required String salonId,
    String? userId,
    required String firstName,
    required String lastName,
    DateTime? birthdate,
    String? phone,
    String? email,
    String? street,
    String? houseNumber,
    String? postalCode,
    String? city,
    @Deprecated('Use structured address fields') String? address,
    List<String>? imageUrls,
    String? notes,
    String? customerNumber,
    String? preferences,
    String? allergies,
    List<String>? tags,
    List<String>? beforeAfterImages,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
  }) = _CustomerProfile;

  factory CustomerProfile.fromJson(Map<String, dynamic> json) =>
      _$CustomerProfileFromJson(json);
}

extension CustomerProfileX on CustomerProfile {
  String get fullName => '$firstName $lastName';

  String get displayAddress {
    if (street != null && postalCode != null && city != null) {
      return '${street ?? ''} ${houseNumber ?? ''}, $postalCode $city'.trim();
    }
    return address ?? '';
  }

  bool get isDeleted => deletedAt != null;
}
