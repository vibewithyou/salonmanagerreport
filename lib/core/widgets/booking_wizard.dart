import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

// Booking Data Model
class BookingData {
  String? salonId;
  String? serviceId;
  String? employeeId;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? customerName;
  String? customerEmail;
  String? customerPhone;
  String? notes;
  List<String>? photoUrls;

  BookingData({
    this.salonId,
    this.serviceId,
    this.employeeId,
    this.selectedDate,
    this.selectedTime,
    this.customerName,
    this.customerEmail,
    this.customerPhone,
    this.notes,
    this.photoUrls,
  });

  bool get isComplete =>
      salonId != null &&
      serviceId != null &&
      employeeId != null &&
      selectedDate != null &&
      selectedTime != null &&
      customerName != null &&
      customerEmail != null &&
      customerPhone != null;
}

/// Main Booking Wizard
class BookingWizardScreen extends StatefulWidget {
  final VoidCallback? onCompleted;
  final Function(BookingData)? onBookingCreated;

  const BookingWizardScreen({
    Key? key,
    this.onCompleted,
    this.onBookingCreated,
  }) : super(key: key);

  @override
  State<BookingWizardScreen> createState() => _BookingWizardScreenState();
}

class _BookingWizardScreenState extends State<BookingWizardScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentStep = 0;
  final BookingData _bookingData = BookingData();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 6) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeBooking() {
    if (_bookingData.isComplete) {
      widget.onBookingCreated?.call(_bookingData);
      widget.onCompleted?.call();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking completed successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      backgroundColor: isDark ? AppColors.gray900 : AppColors.gray50,
      appBar: AppBar(
        title: Text('booking_wizard'.tr()),
        centerTitle: true,
        backgroundColor: isDark ? AppColors.gray900 : AppColors.gray50,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isMobile
          ? _buildMobileLayout()
          : _buildDesktopLayout(),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Progress Sidebar
        Container(
          width: 300,
          padding: EdgeInsets.all(AppSpacing.xl),
          child: _buildProgressSidebar(),
        ),
        // Main Content
        Expanded(
          child: _buildPageView(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildMobileProgress(),
        Expanded(
          child: _buildPageView(),
        ),
      ],
    );
  }

  Widget _buildProgressSidebar() {
    return Column(
      children: [
        for (int i = 0; i < 7; i++)
          _BookingStep(
            stepNumber: i + 1,
            stepTitle: _getStepTitle(i),
            isActive: _currentStep == i,
            isCompleted: _currentStep > i,
            onTap: _currentStep >= i
                ? () => _pageController.jumpToPage(i)
                : null,
          ),
      ],
    );
  }

  Widget _buildMobileProgress() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          LinearProgressIndicator(
            value: (_currentStep + 1) / 7,
            backgroundColor: AppColors.gray200,
            valueColor: AlwaysStoppedAnimation(AppColors.primary),
            minHeight: 4,
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            'Step ${_currentStep + 1} of 7: ${_getStepTitle(_currentStep)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageView() {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: (index) {
        setState(() => _currentStep = index);
      },
      children: [
        // Step 1: Salon Selection
        _BookingStep1SalonSelection(
          bookingData: _bookingData,
          onNext: _nextStep,
        ),
        // Step 2: Service Selection
        _BookingStep2ServiceSelection(
          bookingData: _bookingData,
          onNext: _nextStep,
          onPrevious: _previousStep,
        ),
        // Step 3: Employee Selection
        _BookingStep3EmployeeSelection(
          bookingData: _bookingData,
          onNext: _nextStep,
          onPrevious: _previousStep,
        ),
        // Step 4: Time Selection
        _BookingStep4TimeSelection(
          bookingData: _bookingData,
          onNext: _nextStep,
          onPrevious: _previousStep,
        ),
        // Step 5: Guest Info
        _BookingStep5GuestInfo(
          bookingData: _bookingData,
          onNext: _nextStep,
          onPrevious: _previousStep,
        ),
        // Step 6: Notes & Photos
        _BookingStep6NotesPhotos(
          bookingData: _bookingData,
          onNext: _nextStep,
          onPrevious: _previousStep,
        ),
        // Step 7: Summary
        _BookingStep7Summary(
          bookingData: _bookingData,
          onPrevious: _previousStep,
          onConfirm: _completeBooking,
        ),
      ],
    );
  }

  String _getStepTitle(int index) {
    const steps = [
      'Salon',
      'Service',
      'Stylist',
      'Time',
      'Info',
      'Notes',
      'Review',
    ];
    return steps[index];
  }
}

/// Progress Step Indicator
class _BookingStep extends StatefulWidget {
  final int stepNumber;
  final String stepTitle;
  final bool isActive;
  final bool isCompleted;
  final VoidCallback? onTap;

  const _BookingStep({
    Key? key,
    required this.stepNumber,
    required this.stepTitle,
    required this.isActive,
    required this.isCompleted,
    this.onTap,
  }) : super(key: key);

  @override
  State<_BookingStep> createState() => _BookingStepState();
}

class _BookingStepState extends State<_BookingStep> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: AppSpacing.sm),
          padding: EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: widget.isActive
                ? AppColors.primary.withOpacity(0.1)
                : (_isHovered
                    ? (isDark
                        ? AppColors.gray800
                        : AppColors.gray100)
                    : Colors.transparent),
            borderRadius: BorderRadius.circular(8),
            border: widget.isActive
                ? Border.all(color: AppColors.primary, width: 2)
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: widget.isCompleted
                      ? AppColors.primary
                      : (widget.isActive
                          ? AppColors.primary
                          : (isDark
                              ? AppColors.gray800
                              : AppColors.gray200)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: widget.isCompleted
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 20,
                        )
                      : Text(
                          '${widget.stepNumber}',
                          style: TextStyle(
                            color: widget.isActive
                                ? Colors.white
                                : (isDark
                                    ? AppColors.gray400
                                    : AppColors.gray600),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Step ${widget.stepNumber}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? AppColors.gray400
                                : AppColors.gray600,
                          ),
                    ),
                    Text(
                      widget.stepTitle,
                      style:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: widget.isActive
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Step 1: Salon Selection
class _BookingStep1SalonSelection extends StatefulWidget {
  final BookingData bookingData;
  final VoidCallback onNext;

  const _BookingStep1SalonSelection({
    Key? key,
    required this.bookingData,
    required this.onNext,
  }) : super(key: key);

  @override
  State<_BookingStep1SalonSelection> createState() =>
      _BookingStep1SalonSelectionState();
}

class _BookingStep1SalonSelectionState
    extends State<_BookingStep1SalonSelection> {
  final salons = [
    {'id': '1', 'name': 'Downtown Salon', 'address': '123 Main St'},
    {'id': '2', 'name': 'Uptown Salon', 'address': '456 Oak Ave'},
    {'id': '3', 'name': 'Westside Salon', 'address': '789 Pine Rd'},
  ];

  @override
  Widget build(BuildContext context) {
    return _WizardStep(
      title: 'select_salon'.tr(),
      subtitle: 'choose_preferred_location'.tr(),
      onNext: () {
        if (widget.bookingData.salonId != null) {
          widget.onNext();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('please_select_salon'.tr())),
          );
        }
      },
      showPrevious: false,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.lg,
          mainAxisSpacing: AppSpacing.lg,
        ),
        itemCount: salons.length,
        itemBuilder: (context, index) {
          final salon = salons[index];
          final isSelected = widget.bookingData.salonId == salon['id'];

          return GestureDetector(
            onTap: () {
              setState(() {
                widget.bookingData.salonId = salon['id'];
              });
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.gray200,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
                color: isSelected
                    ? AppColors.primary.withOpacity(0.1)
                    : Colors.transparent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.store,
                    size: 40,
                    color: isSelected ? AppColors.primary : AppColors.gray400,
                  ),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    salon['name'] ?? '',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    salon['address'] ?? '',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.gray600,
                        ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Step 2: Service Selection
class _BookingStep2ServiceSelection extends StatefulWidget {
  final BookingData bookingData;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const _BookingStep2ServiceSelection({
    Key? key,
    required this.bookingData,
    required this.onNext,
    required this.onPrevious,
  }) : super(key: key);

  @override
  State<_BookingStep2ServiceSelection> createState() =>
      _BookingStep2ServiceSelectionState();
}

class _BookingStep2ServiceSelectionState
    extends State<_BookingStep2ServiceSelection> {
  final services = [
    {
      'id': '1',
      'name': 'Haircut',
      'price': 25.00,
      'duration': 30,
      'icon': '✂️'
    },
    {
      'id': '2',
      'name': 'Color & Highlights',
      'price': 60.00,
      'duration': 120,
      'icon': '🎨'
    },
    {
      'id': '3',
      'name': 'Styling',
      'price': 45.00,
      'duration': 60,
      'icon': '💇'
    },
    {
      'id': '4',
      'name': 'Manicure',
      'price': 20.00,
      'duration': 45,
      'icon': '💅'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return _WizardStep(
      title: 'select_service'.tr(),
      subtitle: 'choose_desired_service'.tr(),
      onNext: () {
        if (widget.bookingData.serviceId != null) {
          widget.onNext();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('please_select_service'.tr())),
          );
        }
      },
      onPrevious: widget.onPrevious,
      child: ListView.separated(
        itemCount: services.length,
        separatorBuilder: (_, __) => SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) {
          final service = services[index];
          final isSelected = widget.bookingData.serviceId == service['id'];

          return GestureDetector(
            onTap: () {
              setState(() {
                widget.bookingData.serviceId = service['id'] as String?;
              });
            },
            child: Container(
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.gray200,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
                color: isSelected
                    ? AppColors.primary.withOpacity(0.1)
                    : Colors.transparent,
              ),
              child: Row(
                children: [
                  Text(
                    service['icon'] as String,
                    style: const TextStyle(fontSize: 32),
                  ),
                  SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service['name'] as String,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        Text(
                          '${service['duration']} min',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.gray600,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$${(service['price'] as num).toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Step 3: Employee Selection
class _BookingStep3EmployeeSelection extends StatefulWidget {
  final BookingData bookingData;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const _BookingStep3EmployeeSelection({
    Key? key,
    required this.bookingData,
    required this.onNext,
    required this.onPrevious,
  }) : super(key: key);

  @override
  State<_BookingStep3EmployeeSelection> createState() =>
      _BookingStep3EmployeeSelectionState();
}

class _BookingStep3EmployeeSelectionState
    extends State<_BookingStep3EmployeeSelection> {
  final employees = [
    {'id': '1', 'name': 'Sarah', 'specialty': 'Cuts & Color', 'rating': 4.9},
    {'id': '2', 'name': 'Emma', 'specialty': 'Styling', 'rating': 4.8},
    {'id': '3', 'name': 'Lisa', 'specialty': 'Nails', 'rating': 5.0},
  ];

  @override
  Widget build(BuildContext context) {
    return _WizardStep(
      title: 'select_stylist'.tr(),
      subtitle: 'choose_preferred_stylist'.tr(),
      onNext: () {
        if (widget.bookingData.employeeId != null) {
          widget.onNext();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('please_select_stylist'.tr())),
          );
        }
      },
      onPrevious: widget.onPrevious,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.lg,
          mainAxisSpacing: AppSpacing.lg,
        ),
        itemCount: employees.length,
        itemBuilder: (context, index) {
          final employee = employees[index];
          final isSelected = widget.bookingData.employeeId == employee['id'];

          return GestureDetector(
            onTap: () {
              setState(() {
                widget.bookingData.employeeId = employee['id'] as String?;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.gray200,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
                color: isSelected
                    ? AppColors.primary.withOpacity(0.1)
                    : Colors.transparent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      (employee['name'] as String)[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    employee['name'] as String,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    employee['specialty'] as String,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.gray600,
                        ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star,
                          size: 16, color: AppColors.gold),
                      SizedBox(width: 4),
                      Text(
                        '${employee['rating']}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Step 4: Time Selection
class _BookingStep4TimeSelection extends StatefulWidget {
  final BookingData bookingData;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const _BookingStep4TimeSelection({
    Key? key,
    required this.bookingData,
    required this.onNext,
    required this.onPrevious,
  }) : super(key: key);

  @override
  State<_BookingStep4TimeSelection> createState() =>
      _BookingStep4TimeSelectionState();
}

class _BookingStep4TimeSelectionState
    extends State<_BookingStep4TimeSelection> {
  @override
  Widget build(BuildContext context) {
    return _WizardStep(
      title: 'select_time'.tr(),
      subtitle: 'choose_appointment_time'.tr(),
      onNext: () {
        if (widget.bookingData.selectedDate != null &&
            widget.bookingData.selectedTime != null) {
          widget.onNext();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('please_select_date_time'.tr())),
          );
        }
      },
      onPrevious: widget.onPrevious,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Date',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: AppSpacing.md),
          GestureDetector(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 60)),
              );
              if (date != null) {
                setState(() {
                  widget.bookingData.selectedDate = date;
                });
              }
            },
            child: Container(
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.gray200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: AppColors.primary),
                  SizedBox(width: AppSpacing.md),
                  Text(
                    widget.bookingData.selectedDate != null
                        ? DateFormat('MMM dd, yyyy')
                            .format(widget.bookingData.selectedDate!)
                        : 'Pick a date',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppSpacing.xl),
          Text(
            'Time',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: AppSpacing.md),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              final hour = 8 + (index ~/ 3);
              final minute = (index % 3) * 20;
              final time = TimeOfDay(hour: hour, minute: minute);
              final isSelected = widget.bookingData.selectedTime == time;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    widget.bookingData.selectedTime = time;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.gray100,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.gray200,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isSelected
                                ? Colors.white
                                : AppColors.gray900,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Step 5: Guest Info
class _BookingStep5GuestInfo extends StatefulWidget {
  final BookingData bookingData;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const _BookingStep5GuestInfo({
    Key? key,
    required this.bookingData,
    required this.onNext,
    required this.onPrevious,
  }) : super(key: key);

  @override
  State<_BookingStep5GuestInfo> createState() =>
      _BookingStep5GuestInfoState();
}

class _BookingStep5GuestInfoState extends State<_BookingStep5GuestInfo> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.bookingData.customerName ?? '');
    _emailController =
        TextEditingController(text: widget.bookingData.customerEmail ?? '');
    _phoneController =
        TextEditingController(text: widget.bookingData.customerPhone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _WizardStep(
      title: 'your_information'.tr(),
      subtitle: 'provide_contact_details'.tr(),
      onNext: () {
        if (_nameController.text.isNotEmpty &&
            _emailController.text.isNotEmpty &&
            _phoneController.text.isNotEmpty) {
          widget.bookingData.customerName = _nameController.text;
          widget.bookingData.customerEmail = _emailController.text;
          widget.bookingData.customerPhone = _phoneController.text;
          widget.onNext();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('please_fill_all_fields'.tr())),
          );
        }
      },
      onPrevious: widget.onPrevious,
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              hintText: 'Enter your full name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: 'Phone',
              hintText: 'Enter your phone number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Step 6: Notes & Photos
class _BookingStep6NotesPhotos extends StatefulWidget {
  final BookingData bookingData;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const _BookingStep6NotesPhotos({
    Key? key,
    required this.bookingData,
    required this.onNext,
    required this.onPrevious,
  }) : super(key: key);

  @override
  State<_BookingStep6NotesPhotos> createState() =>
      _BookingStep6NotesPhotosState();
}

class _BookingStep6NotesPhotosState extends State<_BookingStep6NotesPhotos> {
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _notesController =
        TextEditingController(text: widget.bookingData.notes ?? '');
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _WizardStep(
      title: 'additional_notes'.tr(),
      subtitle: 'add_preferences_or_photos'.tr(),
      onNext: () {
        widget.bookingData.notes = _notesController.text;
        widget.onNext();
      },
      onPrevious: widget.onPrevious,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _notesController,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: 'Notes',
              hintText: 'Add any special requests or preferences',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.xl),
          Text(
            'Add Photos (Optional)',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: AppSpacing.md),
          Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.gray200, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_outlined,
                      size: 48, color: AppColors.gray400),
                  SizedBox(height: AppSpacing.md),
                  Text('Upload inspiration photos'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Step 7: Summary & Confirmation
class _BookingStep7Summary extends StatelessWidget {
  final BookingData bookingData;
  final VoidCallback onPrevious;
  final VoidCallback onConfirm;

  const _BookingStep7Summary({
    Key? key,
    required this.bookingData,
    required this.onPrevious,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _WizardStep(
      title: 'review_booking'.tr(),
      subtitle: 'confirm_appointment_details'.tr(),
      onNext: onConfirm,
      onPrevious: onPrevious,
      nextButtonLabel: 'Confirm Booking',
      isLastStep: true,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _SummaryCard(
              title: 'Salon',
              value: bookingData.salonId ?? 'Not selected',
            ),
            _SummaryCard(
              title: 'Service',
              value: bookingData.serviceId ?? 'Not selected',
            ),
            _SummaryCard(
              title: 'Stylist',
              value: bookingData.employeeId ?? 'Not selected',
            ),
            _SummaryCard(
              title: 'Date',
              value: bookingData.selectedDate != null
                  ? DateFormat('MMM dd, yyyy').format(bookingData.selectedDate!)
                  : 'Not selected',
            ),
            _SummaryCard(
              title: 'Time',
              value: bookingData.selectedTime != null
                  ? '${bookingData.selectedTime!.hour}:${bookingData.selectedTime!.minute.toString().padLeft(2, '0')}'
                  : 'Not selected',
            ),
            _SummaryCard(
              title: 'Name',
              value: bookingData.customerName ?? 'Not provided',
            ),
            _SummaryCard(
              title: 'Email',
              value: bookingData.customerEmail ?? 'Not provided',
            ),
            _SummaryCard(
              title: 'Phone',
              value: bookingData.customerPhone ?? 'Not provided',
            ),
            if (bookingData.notes != null && bookingData.notes!.isNotEmpty)
              _SummaryCard(
                title: 'Notes',
                value: bookingData.notes!,
              ),
          ],
        ),
      ),
    );
  }
}

/// Reusable Wizard Step Container
class _WizardStep extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final VoidCallback onNext;
  final VoidCallback? onPrevious;
  final String nextButtonLabel;
  final bool showPrevious;
  final bool isLastStep;

  const _WizardStep({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.child,
    required this.onNext,
    this.onPrevious,
    this.nextButtonLabel = 'Next',
    this.showPrevious = true,
    this.isLastStep = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.gray600,
                ),
          ),
          SizedBox(height: AppSpacing.xl),
          Expanded(
            child: child,
          ),
          SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              if (showPrevious && onPrevious != null) ...[
                Expanded(
                  child: GestureDetector(
                    onTap: onPrevious,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.gray300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Back',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.lg),
              ],
              Expanded(
                child: GestureDetector(
                  onTap: onNext,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        nextButtonLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Summary Card Widget
class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;

  const _SummaryCard({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.gray800 : AppColors.gray100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.gray400 : AppColors.gray600,
                  ),
            ),
          ),
          SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
