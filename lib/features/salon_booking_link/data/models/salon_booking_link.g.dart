// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salon_booking_link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SalonBookingLinkImpl _$$SalonBookingLinkImplFromJson(
  Map<String, dynamic> json,
) => _$SalonBookingLinkImpl(
  salonId: json['salonId'] as String,
  bookingLink: json['bookingLink'] as String,
  bookingEnabled: json['bookingEnabled'] as bool? ?? true,
  salonName: json['salonName'] as String?,
);

Map<String, dynamic> _$$SalonBookingLinkImplToJson(
  _$SalonBookingLinkImpl instance,
) => <String, dynamic>{
  'salonId': instance.salonId,
  'bookingLink': instance.bookingLink,
  'bookingEnabled': instance.bookingEnabled,
  'salonName': instance.salonName,
};
