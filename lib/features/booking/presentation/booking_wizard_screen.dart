import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/booking_provider.dart';
import '../../../models/salon_model.dart';

class BookingWizardScreen extends ConsumerStatefulWidget {
  const BookingWizardScreen({super.key});

  @override
  ConsumerState<BookingWizardScreen> createState() =>
      _BookingWizardScreenState();
}

class _BookingWizardScreenState extends ConsumerState<BookingWizardScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Step 1: Salon & Service
  String? _selectedSalonId;
  String? _selectedServiceId;
  SalonService? _selectedService;

  // Step 2: Stylist & Date
  String? _selectedStylistId;
  DateTime? _selectedDate;
  String? _selectedTimeSlot;

  // Step 3: Notes
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  bool _validateStep() {
    switch (_currentStep) {
      case 0:
        return _selectedSalonId != null && _selectedServiceId != null;
      case 1:
        return _selectedStylistId != null;
      case 2:
        return _selectedDate != null && _selectedTimeSlot != null;
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final salonsAsync = ref.watch(salonsProvider);
    final bookingState = ref.watch(bookingNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('booking.title'.tr()),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.gradientWarm),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Progress indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'booking.newBooking'.tr(),
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'PlayfairDisplay',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'booking.stepInfo'
                            .tr(args: [(_currentStep + 1).toString(), '4']),
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      LinearProgressIndicator(
                        value: (_currentStep + 1) / 4,
                        minHeight: 4,
                        backgroundColor: AppColors.borderLight,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.gold.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Form content
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(gradient: AppTheme.liquidGlass),
                  padding: const EdgeInsets.all(28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_currentStep == 0) ...[
                          _buildSalonServiceStep(salonsAsync),
                        ] else if (_currentStep == 1) ...[
                          _buildStylistStep(),
                        ] else if (_currentStep == 2) ...[
                          _buildDateTimeStep(),
                        ] else ...[
                          _buildReviewStep(),
                        ],
                        const SizedBox(height: 32),
                        // Navigation buttons
                        Row(
                          children: [
                            if (_currentStep > 0)
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: bookingState.isLoading
                                      ? null
                                      : () {
                                          setState(
                                              () => _currentStep--);
                                        },
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    side: const BorderSide(
                                        color: AppColors.gold),
                                  ),
                                  child: Text('common.back'.tr()),
                                ),
                              ),
                            if (_currentStep > 0) const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: bookingState.isLoading
                                    ? null
                                    : () async {
                                        if (_currentStep < 3) {
                                          if (_validateStep()) {
                                            setState(
                                                () => _currentStep++);
                                          }
                                        } else {
                                          await _completeBooking();
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                  backgroundColor: AppColors.gold,
                                ),
                                child: bookingState.isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : Text(
                                        _currentStep < 3
                                            ? 'common.next'.tr()
                                            : 'booking.confirmBooking'.tr(),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _completeBooking() async {
    if (_selectedSalonId == null ||
        _selectedServiceId == null ||
        _selectedStylistId == null ||
        _selectedDate == null ||
        _selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('booking.missingInfo'.tr()),
          backgroundColor: AppColors.rose,
        ),
      );
      return;
    }

    final timeSlotParts = _selectedTimeSlot!.split(':');
    final hour = int.parse(timeSlotParts[0]);
    final minute = int.parse(timeSlotParts[1]);
    final appointmentDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      hour,
      minute,
    );

    final bookingData = {
      'salon_id': _selectedSalonId,
      'service_id': _selectedServiceId,
      'stylist_id': _selectedStylistId,
      'appointment_date': appointmentDateTime.toIso8601String(),
      'duration_minutes': _selectedService?.durationMinutes ?? 60,
      'total_price': _selectedService?.price ?? 0.0,
      'notes': _notesController.text.trim(),
      'status': 'confirmed',
    };

    try {
      await ref
          .read(bookingNotifierProvider.notifier)
          .createBooking(bookingData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('booking.bookingConfirmed'.tr()),
            backgroundColor: AppColors.sage,
            duration: const Duration(seconds: 2),
          ),
        );
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.of(context).pop();
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.rose,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Widget _buildSalonServiceStep(AsyncValue<List<Salon>> salonsAsync) {
    return salonsAsync.when(
      data: (salons) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'booking.selectSalonService'.tr(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.gold,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'booking.selectSalon'.tr(),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _selectedSalonId,
            decoration: InputDecoration(
              prefixIcon:
                  const Icon(LucideIcons.building, color: AppColors.gold),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.borderLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.borderLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.gold, width: 2),
              ),
              filled: true,
              fillColor: AppColors.cardBg,
            ),
            items: salons
                .map((salon) => DropdownMenuItem(
                      value: salon.id,
                      child: Text(salon.name),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedSalonId = value;
                _selectedServiceId = null;
              });
            },
            validator: (value) =>
                value == null ? 'common.required'.tr() : null,
          ),
          const SizedBox(height: 24),
          if (_selectedSalonId != null) ...[
            Text(
              'booking.selectService'.tr(),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _buildServiceList(),
          ],
        ],
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }

  Widget _buildServiceList() {
    final servicesAsync =
        ref.watch(servicesBySalonProvider(_selectedSalonId!));

    return servicesAsync.when(
      data: (services) => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          final isSelected = _selectedServiceId == service.id;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedServiceId = service.id;
                _selectedService = service;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? AppColors.gold : AppColors.borderLight,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
                color: isSelected
                    ? AppColors.gold.withOpacity(0.1)
                    : AppColors.cardBg,
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        service.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '\$${service.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.gold,
                        ),
                      ),
                    ],
                  ),
                  if (service.description != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      service.description!,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(LucideIcons.clock,
                          size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        '${service.durationMinutes} min',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      loading: () => const Padding(
        padding: EdgeInsets.all(16.0),
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }

  Widget _buildStylistStep() {
    if (_selectedSalonId == null) {
      return Center(
        child: Text('booking.selectSalonFirst'.tr()),
      );
    }

    final stylistsAsync =
        ref.watch(stylistsBySalonProvider(_selectedSalonId!));

    return stylistsAsync.when(
      data: (stylists) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'booking.selectStylist'.tr(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.gold,
            ),
          ),
          const SizedBox(height: 24),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: stylists.length,
            itemBuilder: (context, index) {
              final stylist = stylists[index];
              final isSelected = _selectedStylistId == stylist.id;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedStylistId = stylist.id;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected
                          ? AppColors.gold
                          : AppColors.borderLight,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: isSelected
                        ? AppColors.gold.withOpacity(0.1)
                        : AppColors.cardBg,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      if (stylist.avatar != null) ...[
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(stylist.avatar!),
                          radius: 30,
                        ),
                        const SizedBox(width: 16),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${stylist.firstName} ${stylist.lastName}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            if (stylist.specializations.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Wrap(
                                spacing: 4,
                                children: stylist.specializations
                                    .take(2)
                                    .map((spec) => Chip(
                                          label: Text(spec,
                                              style: const TextStyle(
                                                  fontSize: 12)),
                                          backgroundColor: AppColors
                                              .gold
                                              .withOpacity(0.2),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(LucideIcons.check,
                            color: AppColors.gold),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }

  Widget _buildDateTimeStep() {
    if (_selectedStylistId == null) {
      return Center(
        child: Text('booking.selectStylistFirst'.tr()),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'booking.selectDateTime'.tr(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.gold,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'booking.selectDate'.tr(),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 90)),
            );
            if (date != null) {
              setState(() => _selectedDate = date);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderLight),
              borderRadius: BorderRadius.circular(12),
              color: AppColors.cardBg,
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(LucideIcons.calendar, color: AppColors.gold),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedDate != null
                        ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                        : 'booking.chooseDate'.tr(),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        if (_selectedDate != null) ...[
          Text(
            'booking.selectTime'.tr(),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _buildTimeSlots(),
        ],
      ],
    );
  }

  Widget _buildTimeSlots() {
    final slotsAsync = ref.watch(
      availableTimeSlotsProvider((_selectedStylistId!, _selectedDate!)),
    );

    return slotsAsync.when(
      data: (slots) => slots.isEmpty
          ? Center(
              child: Text('booking.noAvailableSlots'.tr()),
            )
          : GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: slots.length,
              itemBuilder: (context, index) {
                final slot = slots[index];
                final isSelected = _selectedTimeSlot == slot;

                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedTimeSlot = slot);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? AppColors.gold
                            : AppColors.borderLight,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: isSelected
                          ? AppColors.gold.withOpacity(0.2)
                          : AppColors.cardBg,
                    ),
                    child: Center(
                      child: Text(
                        slot,
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? AppColors.gold
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
      loading: () => const Padding(
        padding: EdgeInsets.all(16.0),
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }

  Widget _buildReviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'booking.review'.tr(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.gold,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderLight),
            borderRadius: BorderRadius.circular(12),
            color: AppColors.cardBg,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildReviewRow('booking.service'.tr(),
                  _selectedService?.name ?? 'N/A'),
              const Divider(height: 16),
              _buildReviewRow('booking.stylist'.tr(),
                  _selectedStylistId ?? 'N/A'),
              const Divider(height: 16),
              _buildReviewRow(
                  'booking.date'.tr(),
                  _selectedDate != null
                      ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                      : 'N/A'),
              const Divider(height: 16),
              _buildReviewRow(
                  'booking.time'.tr(),
                  _selectedTimeSlot ?? 'N/A'),
              const Divider(height: 16),
              _buildReviewRow(
                  'booking.duration'.tr(),
                  '${_selectedService?.durationMinutes ?? 0} min'),
              const Divider(height: 16),
              _buildReviewRow(
                  'booking.price'.tr(),
                  '\$${(_selectedService?.price ?? 0).toStringAsFixed(2)}'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'booking.addNotes'.tr(),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _notesController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'booking.notesHint'.tr(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.borderLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.gold, width: 2),
            ),
            filled: true,
            fillColor: AppColors.cardBg,
          ),
        ),
      ],
    );
  }

  Widget _buildReviewRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}
