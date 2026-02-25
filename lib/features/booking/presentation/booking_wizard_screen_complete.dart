import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/booking_context_provider.dart';
import '../../../features/bookings/data/booking_repository.dart';
import '../../../features/salons/data/salon_repository.dart';
import '../../../providers/auth_provider.dart';

/// Complete Booking Wizard according to Pflichtenheft
/// 6 Steps: Salon → Service → Stylist → Date/Time → Extras → Confirmation
class BookingWizardScreenNew extends ConsumerStatefulWidget {
  const BookingWizardScreenNew({super.key});

  @override
  ConsumerState<BookingWizardScreenNew> createState() =>
      _BookingWizardScreenNewState();
}

class _BookingWizardScreenNewState
    extends ConsumerState<BookingWizardScreenNew> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();

  // Step 1: Salon Selection
  String? _selectedSalonId;
  String? _selectedSalonName;

  // Step 2: Service Selection
  String? _selectedServiceId;
  String? _selectedServiceName;
  double? _selectedServicePrice;
  int? _selectedServiceDuration;

  // Step 3: Stylist Selection (Optional)
  String? _selectedStylistId;
  String? _selectedStylistName;

  // Step 4: Date & Time
  DateTime? _selectedDate;
  DateTime? _selectedTimeSlot;

  // Step 5: Extras
  final TextEditingController _notesController = TextEditingController();
  final List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  bool _termsAccepted = false;
  bool _privacyAccepted = false;
  bool _isSubmitting = false;

  // Step 6: Customer Info (for guest bookings)
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      if (_currentStep < 5) {
        setState(() => _currentStep++);
        _pageController.animateToPage(
          _currentStep,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _submitBooking();
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  UserData? _getCurrentUser() {
    return ref
        .read(currentUserProvider)
        .maybeWhen(data: (user) => user, orElse: () => null);
  }

  bool _validateCurrentStep() {
    final isGuest = _getCurrentUser() == null;
    switch (_currentStep) {
      case 0:
        return _selectedSalonId != null;
      case 1:
        return _selectedServiceId != null;
      case 2:
        return true; // Stylist is optional
      case 3:
        return _selectedDate != null && _selectedTimeSlot != null;
      case 4:
        return true; // Notes and images are optional
      case 5:
        final formValid = isGuest
            ? (_formKey.currentState?.validate() ?? false)
            : true;
        return formValid && _termsAccepted && _privacyAccepted;
      default:
        return true;
    }
  }

  Future<void> _pickImages() async {
    if (_selectedImages.length >= 5) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Maximal 5 Bilder erlaubt')));
      return;
    }

    final images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images.take(5 - _selectedImages.length));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _submitBooking() async {
    if (_isSubmitting) return;

    if (_selectedSalonId == null ||
        _selectedServiceId == null ||
        _selectedDate == null ||
        _selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte alle Schritte abschließen.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final bookingRepo = ref.read(bookingRepositoryProvider);
    final user = _getCurrentUser();
    final isGuest = user == null;

    final startTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTimeSlot!.hour,
      _selectedTimeSlot!.minute,
    );

    final durationMinutes = _selectedServiceDuration ?? 60;
    final endTime = startTime.add(Duration(minutes: durationMinutes));

    final selectedEmployeeId =
        (_selectedStylistId == null || _selectedStylistId == 'any')
        ? null
        : _selectedStylistId;

    try {
      final salonRepo = ref.read(salonRepositoryProvider);
      final blockReasons = await salonRepo.getBlockingReasons(
        salonId: _selectedSalonId!,
        serviceId: _selectedServiceId!,
        startTime: startTime,
        endTime: endTime,
        employeeId: selectedEmployeeId,
      );

      if (blockReasons.isNotEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red[700],
            content: Text('Buchung blockiert: ${blockReasons.join(' • ')}'),
          ),
        );
        return;
      }

      AppointmentData appointment;

      if (isGuest) {
        appointment = await bookingRepo.createGuestBooking(
          salonId: _selectedSalonId!,
          serviceId: _selectedServiceId!,
          employeeId: selectedEmployeeId,
          guestName: _nameController.text.trim(),
          guestEmail: _emailController.text.trim(),
          guestPhone: _phoneController.text.trim(),
          startTime: startTime,
          endTime: endTime,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          termsAccepted: _termsAccepted,
          privacyAccepted: _privacyAccepted,
        );
      } else {
        appointment = await bookingRepo.createCustomerBooking(
          salonId: _selectedSalonId!,
          customerId: user.id,
          serviceId: _selectedServiceId!,
          employeeId: selectedEmployeeId,
          startTime: startTime,
          endTime: endTime,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          termsAccepted: _termsAccepted,
          privacyAccepted: _privacyAccepted,
        );
      }

      if (_selectedImages.isNotEmpty) {
        final uploadedUrls = <String>[];

        for (var i = 0; i < _selectedImages.length; i++) {
          final image = _selectedImages[i];
          final bytes = await image.readAsBytes();
          final fileName = '${DateTime.now().millisecondsSinceEpoch}_$i.jpg';

          final url = await bookingRepo.uploadBookingImage(
            salonId: _selectedSalonId!,
            appointmentId: appointment.id,
            imageBytes: bytes,
            fileName: fileName,
          );

          uploadedUrls.add(url);
        }

        await bookingRepo.updateAppointment(
          appointmentId: appointment.id,
          images: uploadedUrls,
        );
      }

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Buchung erfolgreich'),
          content: const Text(
            'Ihre Buchung wurde erfolgreich übermittelt.\n'
            'Sie erhalten eine Bestätigungs-E-Mail.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.go('/customer');
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fehler bei der Buchung: $e')));
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header with progress
            _buildHeader(theme),

            // Step content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStep1SalonSelection(),
                  _buildStep2ServiceSelection(),
                  _buildStep3StylistSelection(),
                  _buildStep4DateTime(),
                  _buildStep5Extras(),
                  _buildStep6Confirmation(),
                ],
              ),
            ),

            // Navigation buttons
            _buildNavigationButtons(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.gold, AppColors.gold.withValues(alpha: 0.8)],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(LucideIcons.x, color: Colors.white),
              ),
              const Spacer(),
              Text(
                'Schritt ${_currentStep + 1} von 6',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: (_currentStep + 1) / 6,
            backgroundColor: Colors.white.withValues(alpha: 0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 4,
          ),
          const SizedBox(height: 16),
          Text(
            _getStepTitle(),
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Salon auswählen';
      case 1:
        return 'Leistung wählen';
      case 2:
        return 'Stylist wählen (Optional)';
      case 3:
        return 'Datum & Uhrzeit';
      case 4:
        return 'Zusatzinformationen';
      case 5:
        return 'Bestätigung';
      default:
        return '';
    }
  }

  // STEP 1: Salon Selection
  Widget _buildStep1SalonSelection() {
    final salonsAsync = ref.watch(availableSalonsProvider);

    return salonsAsync.when(
      data: (salons) {
        if (salons.isEmpty) {
          return Center(
            child: Text(
              'Keine Salons verfügbar',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: salons.length,
          itemBuilder: (context, index) {
            final salon = salons[index];
            final isSelected = _selectedSalonId == salon.id;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              color: isSelected ? AppColors.gold.withValues(alpha: 0.1) : null,
              child: ListTile(
                leading: Icon(
                  LucideIcons.store,
                  color: isSelected ? AppColors.gold : AppColors.textSecondary,
                ),
                title: Text(
                  salon.name,
                  style: TextStyle(
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                subtitle: Text(salon.address ?? 'Adresse nicht verfügbar'),
                trailing: isSelected
                    ? Icon(LucideIcons.check, color: AppColors.gold)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedSalonId = salon.id;
                    _selectedSalonName = salon.name;
                    _selectedServiceId = null;
                    _selectedServiceName = null;
                    _selectedServicePrice = null;
                    _selectedServiceDuration = null;
                    _selectedStylistId = null;
                    _selectedStylistName = null;
                    _selectedDate = null;
                    _selectedTimeSlot = null;
                  });

                  ref.read(bookingContextProvider.notifier).state = ref
                      .read(bookingContextProvider)
                      .copyWith(
                        selectedSalon: salon,
                        selectedService: null,
                        selectedEmployee: null,
                        selectedDate: null,
                        selectedTime: null,
                      );
                },
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Fehler: $e')),
    );
  }

  // STEP 2: Service Selection
  Widget _buildStep2ServiceSelection() {
    if (_selectedSalonId == null) {
      return Center(
        child: Text(
          'Bitte zuerst einen Salon auswählen',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    final servicesAsync = ref.watch(salonServicesProvider);

    return servicesAsync.when(
      data: (services) {
        if (services.isEmpty) {
          return Center(
            child: Text(
              'Keine Services verfügbar',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];
            final isSelected = _selectedServiceId == service.id;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              color: isSelected ? AppColors.gold.withValues(alpha: 0.1) : null,
              child: ListTile(
                leading: Icon(
                  LucideIcons.scissors,
                  color: isSelected ? AppColors.gold : AppColors.textSecondary,
                ),
                title: Text(
                  service.name,
                  style: TextStyle(
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                subtitle: Text('${service.durationMinutes} Min.'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '€${service.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? AppColors.gold : null,
                      ),
                    ),
                    if (isSelected)
                      Icon(LucideIcons.check, color: AppColors.gold, size: 16),
                  ],
                ),
                onTap: () {
                  setState(() {
                    _selectedServiceId = service.id;
                    _selectedServiceName = service.name;
                    _selectedServicePrice = service.price;
                    _selectedServiceDuration = service.durationMinutes;
                    _selectedStylistId = null;
                    _selectedStylistName = null;
                    _selectedDate = null;
                    _selectedTimeSlot = null;
                  });

                  ref.read(bookingContextProvider.notifier).state = ref
                      .read(bookingContextProvider)
                      .copyWith(
                        selectedService: service,
                        selectedEmployee: null,
                        selectedDate: null,
                        selectedTime: null,
                      );
                },
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Fehler: $e')),
    );
  }

  // STEP 3: Stylist Selection (Optional)
  Widget _buildStep3StylistSelection() {
    if (_selectedServiceId == null) {
      return Center(
        child: Text(
          'Bitte zuerst eine Leistung auswählen',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    final employeesAsync = ref.watch(serviceEmployeesProvider);

    return employeesAsync.when(
      data: (employees) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              color: _selectedStylistId == 'any'
                  ? AppColors.gold.withValues(alpha: 0.1)
                  : null,
              child: ListTile(
                leading: Icon(
                  LucideIcons.users,
                  color: _selectedStylistId == 'any'
                      ? AppColors.gold
                      : AppColors.textSecondary,
                ),
                title: const Text('Kein Stylist (nächster verfügbarer)'),
                trailing: _selectedStylistId == 'any'
                    ? Icon(LucideIcons.check, color: AppColors.gold)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedStylistId = 'any';
                    _selectedStylistName =
                        'Kein Stylist (nächster verfügbarer)';
                  });

                  ref.read(bookingContextProvider.notifier).state = ref
                      .read(bookingContextProvider)
                      .copyWith(selectedEmployee: null);
                },
              ),
            ),
            if (employees.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Keine passenden Stylisten gefunden',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              )
            else
              ...employees.map((employee) {
                final isSelected = _selectedStylistId == employee.id;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: isSelected
                      ? AppColors.gold.withValues(alpha: 0.1)
                      : null,
                  child: ListTile(
                    leading: Icon(
                      LucideIcons.user,
                      color: isSelected
                          ? AppColors.gold
                          : AppColors.textSecondary,
                    ),
                    title: Text(
                      employee.fullName.isEmpty
                          ? 'Stylist ohne Namen'
                          : employee.fullName,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(LucideIcons.check, color: AppColors.gold)
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedStylistId = employee.id;
                        _selectedStylistName = employee.fullName;
                      });

                      ref.read(bookingContextProvider.notifier).state = ref
                          .read(bookingContextProvider)
                          .copyWith(selectedEmployee: employee);
                    },
                  ),
                );
              }),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Fehler: $e')),
    );
  }

  // STEP 4: Date & Time
  Widget _buildStep4DateTime() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Picker
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(LucideIcons.calendar, color: AppColors.gold),
                      const SizedBox(width: 12),
                      const Text(
                        'Datum wählen',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 90),
                          ),
                        );
                        if (date != null) {
                          setState(() {
                            _selectedDate = date;
                            _selectedTimeSlot = null;
                          });

                          ref.read(bookingContextProvider.notifier).state = ref
                              .read(bookingContextProvider)
                              .copyWith(selectedDate: date, selectedTime: null);
                        }
                      },
                      icon: const Icon(LucideIcons.calendar),
                      label: Text(
                        _selectedDate != null
                            ? DateFormat(
                                'EEE, d. MMMM yyyy',
                                'de',
                              ).format(_selectedDate!)
                            : 'Datum auswählen',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Time Slots
          if (_selectedDate != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(LucideIcons.clock, color: AppColors.gold),
                        const SizedBox(width: 12),
                        const Text(
                          'Uhrzeit wählen',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ref
                        .watch(availableTimeSlotsProvider)
                        .when(
                          data: (slots) {
                            if (slots.isEmpty) {
                              return Text(
                                'Keine verfügbaren Zeiten',
                                style: Theme.of(context).textTheme.bodyMedium,
                              );
                            }

                            return Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: slots.map((slot) {
                                final isSelected =
                                    _selectedTimeSlot != null &&
                                    _selectedTimeSlot!.hour == slot.hour &&
                                    _selectedTimeSlot!.minute == slot.minute;

                                return ChoiceChip(
                                  label: Text(DateFormat('HH:mm').format(slot)),
                                  selected: isSelected,
                                  selectedColor: AppColors.gold,
                                  onSelected: (selected) {
                                    setState(() => _selectedTimeSlot = slot);
                                    ref
                                        .read(bookingContextProvider.notifier)
                                        .state = ref
                                        .read(bookingContextProvider)
                                        .copyWith(selectedTime: slot);
                                  },
                                );
                              }).toList(),
                            );
                          },
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (e, st) => Text('Fehler: $e'),
                        ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // STEP 5: Extras (Notes + Images)
  Widget _buildStep5Extras() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Notes
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(LucideIcons.fileText, color: AppColors.gold),
                      const SizedBox(width: 12),
                      const Text(
                        'Notizen (Optional)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _notesController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Wünsche, Anmerkungen...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Image Upload
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(LucideIcons.image, color: AppColors.gold),
                      const SizedBox(width: 12),
                      const Text(
                        'Bilder hochladen (max. 5)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_selectedImages.isEmpty)
                    Center(
                      child: OutlinedButton.icon(
                        onPressed: _pickImages,
                        icon: const Icon(LucideIcons.upload),
                        label: const Text('Bilder auswählen'),
                      ),
                    )
                  else
                    Column(
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _selectedImages.asMap().entries.map((
                            entry,
                          ) {
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(entry.value.path),
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: IconButton(
                                    onPressed: () => _removeImage(entry.key),
                                    icon: const Icon(LucideIcons.x),
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.black54,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.all(4),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                        if (_selectedImages.length < 5) ...[
                          const SizedBox(height: 12),
                          Center(
                            child: OutlinedButton.icon(
                              onPressed: _pickImages,
                              icon: const Icon(LucideIcons.plus),
                              label: const Text('Weitere hinzufügen'),
                            ),
                          ),
                        ],
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // STEP 6: Confirmation
  Widget _buildStep6Confirmation() {
    final user = ref
        .watch(currentUserProvider)
        .maybeWhen(data: (value) => value, orElse: () => null);
    final isGuest = user == null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking Summary
            Card(
              color: AppColors.gold.withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Zusammenfassung',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSummaryRow(
                      'Salon',
                      _selectedSalonName ?? '',
                      LucideIcons.store,
                    ),
                    _buildSummaryRow(
                      'Leistung',
                      _selectedServiceName ?? '',
                      LucideIcons.scissors,
                    ),
                    if (_selectedStylistId != null &&
                        _selectedStylistId != 'any')
                      _buildSummaryRow(
                        'Stylist',
                        _selectedStylistName ?? '',
                        LucideIcons.user,
                      ),
                    _buildSummaryRow(
                      'Datum',
                      _selectedDate != null
                          ? DateFormat(
                              'EEE, d. MMM yyyy',
                              'de',
                            ).format(_selectedDate!)
                          : '',
                      LucideIcons.calendar,
                    ),
                    _buildSummaryRow(
                      'Uhrzeit',
                      _selectedTimeSlot != null
                          ? DateFormat('HH:mm').format(_selectedTimeSlot!)
                          : '',
                      LucideIcons.clock,
                    ),
                    const Divider(),
                    _buildSummaryRow(
                      'Preis',
                      '€${_selectedServicePrice?.toStringAsFixed(2) ?? '0.00'}',
                      LucideIcons.euro,
                      isHighlight: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Customer Info
            if (isGuest)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ihre Kontaktdaten',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name *',
                          prefixIcon: Icon(LucideIcons.user),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (!isGuest) return null;
                          if (value == null || value.isEmpty) {
                            return 'Bitte Name eingeben';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'E-Mail *',
                          prefixIcon: Icon(LucideIcons.mail),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (!isGuest) return null;
                          if (value == null || value.isEmpty) {
                            return 'Bitte E-Mail eingeben';
                          }
                          if (!value.contains('@')) {
                            return 'Ungültige E-Mail';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Telefon *',
                          prefixIcon: Icon(LucideIcons.phone),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (!isGuest) return null;
                          if (value == null || value.isEmpty) {
                            return 'Bitte Telefonnummer eingeben';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              )
            else
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.user, color: AppColors.gold),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Eingeloggt als ${user.fullName.isEmpty ? user.email : user.fullName}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheckboxListTile(
                      value: _termsAccepted,
                      onChanged: (value) {
                        setState(() => _termsAccepted = value ?? false);
                      },
                      title: const Text('AGB akzeptieren *'),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    CheckboxListTile(
                      value: _privacyAccepted,
                      onChanged: (value) {
                        setState(() => _privacyAccepted = value ?? false);
                      },
                      title: const Text('Datenschutz akzeptieren *'),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    IconData icon, {
    bool isHighlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isHighlight ? AppColors.gold : AppColors.textSecondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isHighlight ? 18 : 14,
              color: isHighlight ? AppColors.gold : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _previousStep,
                icon: const Icon(LucideIcons.chevronLeft),
                label: const Text('Zurück'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      _currentStep == 5 ? 'Buchen' : 'Weiter',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
