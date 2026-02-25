import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/bookings/data/booking_repository.dart';
import '../features/salons/data/salon_repository.dart';
import '../features/services/data/service_repository.dart';

/// Booking Context - Holds state throughout the booking wizard flow
class BookingContext {
  final SalonData? selectedSalon;
  final ServiceData? selectedService;
  final EmployeeData? selectedEmployee;
  final DateTime? selectedDate;
  final DateTime? selectedTime;
  final String? notes;
  final List<String> imageUrls; // Uploaded image URLs

  const BookingContext({
    this.selectedSalon,
    this.selectedService,
    this.selectedEmployee,
    this.selectedDate,
    this.selectedTime,
    this.notes,
    this.imageUrls = const [],
  });

  /// Check if booking is ready for submission
  bool get isComplete =>
      selectedSalon != null &&
      selectedService != null &&
      selectedDate != null &&
      selectedTime != null;

  /// Get full datetime from date + time selection
  DateTime? get fullDateTime {
    if (selectedDate == null || selectedTime == null) return null;
    return DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );
  }

  /// Copy with new values
  BookingContext copyWith({
    SalonData? selectedSalon,
    ServiceData? selectedService,
    EmployeeData? selectedEmployee,
    DateTime? selectedDate,
    DateTime? selectedTime,
    String? notes,
    List<String>? imageUrls,
  }) {
    return BookingContext(
      selectedSalon: selectedSalon ?? this.selectedSalon,
      selectedService: selectedService ?? this.selectedService,
      selectedEmployee: selectedEmployee ?? this.selectedEmployee,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      notes: notes ?? this.notes,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }

  /// Reset context to start new booking
  BookingContext reset() {
    return const BookingContext();
  }
}

/// Provider for managing booking context throughout wizard
final bookingContextProvider =
    StateProvider<BookingContext>((ref) => const BookingContext());

/// All salons for booking flow
final availableSalonsProvider = FutureProvider<List<SalonData>>((ref) async {
  final salonRepo = ref.watch(salonRepositoryProvider);
  try {
    return await salonRepo.getAllSalons();
  } catch (e) {
    print('Error fetching salons: $e');
    return [];
  }
});

/// Services for the selected salon
final salonServicesProvider = FutureProvider<List<ServiceData>>((ref) async {
  final context = ref.watch(bookingContextProvider);
  final serviceRepo = ref.watch(serviceRepositoryProvider);

  if (context.selectedSalon == null) return [];

  try {
    return await serviceRepo.getSalonServices(context.selectedSalon!.id);
  } catch (e) {
    print('Error fetching services: $e');
    return [];
  }
});

/// Employees who can provide the selected service
final serviceEmployeesProvider = FutureProvider<List<EmployeeData>>((ref) async {
  final context = ref.watch(bookingContextProvider);
  final salonRepo = ref.watch(salonRepositoryProvider);
  final serviceRepo = ref.watch(serviceRepositoryProvider);

  if (context.selectedSalon == null || context.selectedService == null) {
    return [];
  }

  try {
    final employees =
        await salonRepo.getSalonEmployees(context.selectedSalon!.id);
    final serviceEmployeeIds =
        await serviceRepo.getEmployeesForService(context.selectedService!.id);

    return employees
        .where((employee) => serviceEmployeeIds.contains(employee.id))
        .toList();
  } catch (e) {
    print('Error fetching service employees: $e');
    return [];
  }
});

/// Check availability for selected slot
final availabilityCheckProvider =
    FutureProvider.family<bool, DateTime>((ref, dateTime) async {
  final context = ref.watch(bookingContextProvider);
  final salonRepo = ref.watch(salonRepositoryProvider);

  if (context.selectedSalon == null || context.selectedService == null) {
    return false;
  }

  try {
    return await salonRepo.hasFreeSlot(
      salonId: context.selectedSalon!.id,
      serviceId: context.selectedService!.id,
      startTime: dateTime,
      endTime: dateTime.add(
        Duration(minutes: context.selectedService!.durationMinutes),
      ),
      employeeId: context.selectedEmployee?.id,
    );
  } catch (e) {
    print('Error checking availability: $e');
    return false;
  }
});

/// Available time slots for selected date
final availableTimeSlotsProvider =
    FutureProvider<List<DateTime>>((ref) async {
  final context = ref.watch(bookingContextProvider);
  final bookingRepo = ref.watch(bookingRepositoryProvider);

  if (context.selectedSalon == null ||
      context.selectedService == null ||
      context.selectedDate == null) {
    return [];
  }

  try {
    final slots = await bookingRepo.getAvailableSlots(
      salonId: context.selectedSalon!.id,
      serviceId: context.selectedService!.id,
      date: context.selectedDate!,
      employeeId: context.selectedEmployee?.id,
    );
    return slots.map((slot) => slot.startTime).toList();
  } catch (e) {
    print('Error fetching available slots: $e');
    return [];
  }
});

/// Get available employees for selected service/time
final availableEmployeesProvider = FutureProvider<List<EmployeeData>>((ref) async {
  final context = ref.watch(bookingContextProvider);
  final salonRepo = ref.watch(salonRepositoryProvider);
  final serviceRepo = ref.watch(serviceRepositoryProvider);

  if (context.selectedSalon == null ||
      context.selectedService == null ||
      context.selectedDate == null ||
      context.selectedTime == null) {
    return [];
  }

  try {
    final dateTime = context.fullDateTime;
    if (dateTime == null) return [];

    final endTime = dateTime.add(
      Duration(minutes: context.selectedService!.durationMinutes),
    );

    // Get all employees from selected salon who can provide this service
    // and have free slot at selected time
    final allEmployees =
      await salonRepo.getSalonEmployees(context.selectedSalon!.id);
    final employeeIds = await serviceRepo
      .getEmployeesForService(context.selectedService!.id);

    final eligibleEmployees = allEmployees
      .where((employee) => employeeIds.contains(employee.id))
      .toList();

    final available = <EmployeeData>[];
    for (final employee in eligibleEmployees) {
      final isFree = await salonRepo.hasFreeSlot(
        salonId: context.selectedSalon!.id,
        serviceId: context.selectedService!.id,
        startTime: dateTime,
        endTime: endTime,
        employeeId: employee.id,
      );

      if (isFree) {
        available.add(employee);
      }
    }

    return available;
  } catch (e) {
    print('Error fetching available employees: $e');
    return [];
  }
});
