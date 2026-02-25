import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_model.freezed.dart';
part 'onboarding_model.g.dart';

@freezed
class OnboardingData with _$OnboardingData {
  const factory OnboardingData({
    required String userId,
    required String firstName,
    required String lastName,
    required String phone,
    required String street,
    String? houseNumber,
    required String postalCode,
    required String city,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _OnboardingData;

  factory OnboardingData.fromJson(Map<String, dynamic> json) =>
      _$OnboardingDataFromJson(json);
}
