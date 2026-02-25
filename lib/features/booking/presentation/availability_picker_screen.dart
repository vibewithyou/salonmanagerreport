import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/booking_context_provider.dart';
import '../../salons/data/salon_repository.dart';
import '../../services/data/service_repository.dart';

/// Availability & Time Slot Selection Screen
/// Allows customer to select date and time for appointment
class AvailabilityPickerScreen extends ConsumerStatefulWidget {
  const AvailabilityPickerScreen({super.key});

  @override
  ConsumerState<AvailabilityPickerScreen> createState() =>
      _AvailabilityPickerScreenState();
}

class _AvailabilityPickerScreenState
    extends ConsumerState<AvailabilityPickerScreen> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now().add(const Duration(days: 1));
    ref.read(bookingContextProvider.notifier).state = ref
        .read(bookingContextProvider)
        .copyWith(selectedDate: _selectedDate, selectedTime: null);
  }

  @override
  Widget build(BuildContext context) {
    final context_ = ref.watch(bookingContextProvider);
    final theme = Theme.of(context);

    if (context_.selectedSalon == null || context_.selectedService == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Datum & Uhrzeit')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.alertCircle,
                  size: 64, color: AppColors.error),
              const SizedBox(height: 16),
              const Text('Salon und Service müssen ausgewählt sein'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Zurück'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Datum & Uhrzeit wählen'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Salon/Service Summary
            _buildBookingSummary(context, context_.selectedSalon!,
                context_.selectedService!, theme),
            const SizedBox(height: 32),

            // Date Selection Calendar
            Text(
              'Datum auswählen',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildCalendarPicker(),
            const SizedBox(height: 32),

            // Time Slots
            Text(
              'Verfügbare Uhrzeiten',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildTimeSlots(context, ref, _selectedDate),
            const SizedBox(height: 32),

            // Continue Button
            if (context_.selectedDate != null && context_.selectedTime != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Move to next step (employee selection or confirmation)
                    context.push('/booking/employee-selection');
                  },
                  icon: const Icon(LucideIcons.arrowRight),
                  label: const Text('Weiter'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Wählen Sie Datum & Uhrzeit'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingSummary(
    BuildContext context,
    SalonData salon,
    ServiceData service,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ihre Auswahl',
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(LucideIcons.mapPin, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  salon.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(LucideIcons.scissors, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  service.name,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              Text(
                '${service.durationMinutes} min',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(LucideIcons.euro, size: 16, color: AppColors.gold),
              const SizedBox(width: 8),
              Text(
                '${service.price.toStringAsFixed(2)} €',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.gold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarPicker() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 1.2,
      ),
      itemCount: 42, // 6 weeks * 7 days
      itemBuilder: (context, index) {
        final startDate = DateTime.now().add(const Duration(days: 1));
        final date = DateTime(startDate.year, startDate.month, startDate.day)
            .add(Duration(days: index - startDate.weekday + 1));

        final isSelected = _selectedDate.year == date.year &&
            _selectedDate.month == date.month &&
            _selectedDate.day == date.day;

        final isDisabled = date.isBefore(DateTime.now());
        final isToday = DateUtils.isSameDay(date, DateTime.now());

        if (index < startDate.weekday - 1 ||
            date.month != startDate.month) {
          return const SizedBox.shrink();
        }

        return GestureDetector(
          onTap: isDisabled
              ? null
              : () {
                  setState(() => _selectedDate = date);
                  ref
                      .read(bookingContextProvider.notifier)
                      .state = ref
                          .read(bookingContextProvider)
                          .copyWith(selectedDate: date, selectedTime: null);
                },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : isToday
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Colors.transparent,
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${date.day}',
                style: TextStyle(
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isDisabled
                      ? Colors.grey
                      : isSelected
                          ? Colors.white
                          : Colors.black,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimeSlots(
    BuildContext context,
    WidgetRef ref,
    DateTime selectedDate,
  ) {
    final slotsAsync = ref.watch(availableTimeSlotsProvider);
    final bookingCtx = ref.watch(bookingContextProvider);

    return slotsAsync.when(
      data: (slots) {
        if (slots.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(
                  LucideIcons.calendar,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Keine verfügbaren Uhrzeiten für diesen Tag',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        // Group slots by hour
        final morningSlots =
            slots.where((s) => s.hour < 12).toList();
        final afternoonSlots =
            slots.where((s) => s.hour >= 12 && s.hour < 18).toList();
        final eveningSlots = slots.where((s) => s.hour >= 18).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (morningSlots.isNotEmpty) ...[
              _buildTimeSlotsSection('Morgens', morningSlots, bookingCtx, ref),
              const SizedBox(height: 16),
            ],
            if (afternoonSlots.isNotEmpty) ...[
              _buildTimeSlotsSection(
                  'Nachmittags', afternoonSlots, bookingCtx, ref),
              const SizedBox(height: 16),
            ],
            if (eveningSlots.isNotEmpty) ...[
              _buildTimeSlotsSection(
                  'Abends', eveningSlots, bookingCtx, ref),
            ],
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(
        child: Text('Fehler beim Laden: $e'),
      ),
    );
  }

  Widget _buildTimeSlotsSection(
    String label,
    List<DateTime> slots,
    BookingContext bookingCtx,
    WidgetRef ref,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.5,
          ),
          itemCount: slots.length,
          itemBuilder: (context, index) {
            final slot = slots[index];
            final isSelected = bookingCtx.selectedTime?.hour == slot.hour &&
                bookingCtx.selectedTime?.minute == slot.minute;

            return GestureDetector(
              onTap: () {
                ref.read(bookingContextProvider.notifier).state =
                    bookingCtx.copyWith(selectedTime: slot);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : Colors.grey[100],
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    DateFormat('HH:mm').format(slot),
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
