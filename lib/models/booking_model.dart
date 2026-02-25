import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_model.freezed.dart';
part 'booking_model.g.dart';

enum BookingStatus { pending, confirmed, completed, cancelled }

@freezed
class Appointment with _$Appointment {
  const factory Appointment({
    required String id,
    required String salonId,
    required String serviceId,
    required String stylistId,
    required String customerId,
    required DateTime appointmentDate,
    required int durationMinutes,
    required double price,
    required String? notes,
    required List<String>? images,
    required BookingStatus status,
    required bool? termsAccepted,
    required bool? privacyAccepted,
    required DateTime createdAt,
    required DateTime? updatedAt,
    required String? bookingReference,
  }) = _Appointment;

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);
}

@freezed
class BookingWizardState with _$BookingWizardState {
  const factory BookingWizardState({
    @Default(0) int currentStep,
    String? selectedSalonId,
    String? selectedServiceId,
    String? selectedStylistId,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    String? notes,
    List<String>? imageUrls,
    @Default(false) bool termsAccepted,
    @Default(false) bool privacyAccepted,
    @Default({}) Map<String, dynamic> validationErrors,
  }) = _BookingWizardState;
}
