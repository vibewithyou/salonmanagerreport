import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

enum UserRole { customer, employee, stylist, manager, admin, owner }

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String? firstName,
    required String? lastName,
    required String? phone,
    required String? avatar,
    required UserRole role,
    required bool emailVerified,
    required DateTime createdAt,
    required DateTime? updatedAt,
    required DateTime? lastLogin,
    required bool twoFactorEnabled,
    required String? salonId,
    String? currentSalonId,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String userId,
    required String? bio,
    required String? avatar,
    required String? phone,
    required String? address,
    required String? city,
    required String? postalCode,
    required String? country,
    required DateTime? dateOfBirth,
    required String? notificationPreferences,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
