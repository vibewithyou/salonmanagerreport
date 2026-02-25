import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../services/salon_settings_service.dart';
import '../../../models/salon_settings_model.dart';
// DISABLED: import '../../salon_booking_link/ui/salon_booking_link_settings.dart';

class SalonSettingsTab extends ConsumerStatefulWidget {
  final String salonId;

  const SalonSettingsTab({super.key, required this.salonId});

  @override
  ConsumerState<SalonSettingsTab> createState() => _SalonSettingsTabState();
}

class _SalonSettingsTabState extends ConsumerState<SalonSettingsTab> {
  late SalonSettingsService _service;
  List<BusinessHours> _businessHours = [];
  List<Holiday> _holidays = [];
  List<PaymentMethod> _paymentMethods = [];
  bool _isLoading = true;

  // Form controllers
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _postalCodeController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _websiteController;
  late TextEditingController _taxIdController;
  late TextEditingController _bankAccountController;

  @override
  void initState() {
    super.initState();
    _service = SalonSettingsService(Supabase.instance.client);
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _postalCodeController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _websiteController = TextEditingController();
    _taxIdController = TextEditingController();
    _bankAccountController = TextEditingController();
    _loadSettings();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _taxIdController.dispose();
    _bankAccountController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);
    try {
      final settings = await _service.getSalonSettings(widget.salonId);
      final hours = await _service.getBusinessHours(widget.salonId);
      final holidays = await _service.getHolidays(widget.salonId);
      final methods = await _service.getPaymentMethods(widget.salonId);

      if (mounted) {
        setState(() {
          _businessHours = hours;
          _holidays = holidays;
          _paymentMethods = methods;

          if (settings != null) {
            _nameController.text = settings.salonName;
            _descriptionController.text = settings.salonDescription ?? '';
            _addressController.text = settings.address ?? '';
            _cityController.text = settings.city ?? '';
            _postalCodeController.text = settings.postalCode ?? '';
            _phoneController.text = settings.phone ?? '';
            _emailController.text = settings.email ?? '';
            _websiteController.text = settings.website ?? '';
            _taxIdController.text = settings.taxId ?? '';
            _bankAccountController.text = settings.bankAccount ?? '';
          }

          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading settings: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _formatHolidayDate(Holiday holiday) {
    final date = holiday.date;
    return '${date.day}.${date.month}.${date.year}';
  }

  Future<void> _saveSalonInfo() async {
    final success = await _service.updateSalonInfo(
      salonId: widget.salonId,
      name: _nameController.text,
      description: _descriptionController.text.isEmpty
          ? null
          : _descriptionController.text,
      address: _addressController.text.isEmpty ? null : _addressController.text,
      city: _cityController.text.isEmpty ? null : _cityController.text,
      postalCode: _postalCodeController.text.isEmpty
          ? null
          : _postalCodeController.text,
      phone: _phoneController.text.isEmpty ? null : _phoneController.text,
      email: _emailController.text.isEmpty ? null : _emailController.text,
      website: _websiteController.text.isEmpty ? null : _websiteController.text,
      taxId: _taxIdController.text.isEmpty ? null : _taxIdController.text,
      bankAccount: _bankAccountController.text.isEmpty
          ? null
          : _bankAccountController.text,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Saloninformationen gespeichert!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fehler beim Speichern!'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _addHoliday() async {
    final datePicked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (datePicked == null) return;

    if (!mounted) return;

    final name = await _showHolidayNameDialog();
    if (name == null) return;

    final success = await _service.addHoliday(widget.salonId, datePicked, name);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Feiertag hinzugefügt!'),
            backgroundColor: Colors.green,
          ),
        );
        _loadSettings();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fehler beim Hinzufügen!'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _addPaymentMethod() async {
    final result = await _showPaymentMethodDialog();
    if (result == null) return;

    final success = await _service.addPaymentMethod(
      widget.salonId,
      result['name'] as String,
      result['type'] as String,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Zahlungsmethode hinzugefuegt!'),
            backgroundColor: Colors.green,
          ),
        );
        _loadSettings();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fehler beim Hinzufuegen!'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<Map<String, String>?> _showPaymentMethodDialog() async {
    final nameController = TextEditingController();
    String selectedType = 'card';

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Zahlungsmethode hinzufuegen'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'z.B. Visa, Bar, PayPal',
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    items: const [
                      DropdownMenuItem(value: 'card', child: Text('Karte')),
                      DropdownMenuItem(value: 'cash', child: Text('Bargeld')),
                      DropdownMenuItem(
                        value: 'transfer',
                        child: Text('Ueberweisung'),
                      ),
                      DropdownMenuItem(value: 'paypal', child: Text('PayPal')),
                      DropdownMenuItem(
                        value: 'apple_pay',
                        child: Text('Apple Pay'),
                      ),
                      DropdownMenuItem(
                        value: 'google_pay',
                        child: Text('Google Pay'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setDialogState(() => selectedType = value);
                    },
                    decoration: const InputDecoration(labelText: 'Typ'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Abbrechen'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    if (name.isEmpty) return;
                    Navigator.pop(context, {
                      'name': name,
                      'type': selectedType,
                    });
                  },
                  child: const Text('Hinzufuegen'),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    return result;
  }

  Future<String?> _showHolidayNameDialog() {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Feiertag hinzufügen'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'z.B. Weihnachten',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Hinzufügen'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 32),
          _buildBasicInfoSection(),
          const SizedBox(height: 32),
          _buildBookingSettingsSection(context),
          const SizedBox(height: 32),
          _buildBusinessHoursSection(),
          const SizedBox(height: 32),
          _buildHolidaysSection(),
          const SizedBox(height: 32),
          _buildPaymentMethodsSection(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '⚙️ Saloneinstellungen',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Verwalten Sie Ihre Saloninformationen, Öffnungszeiten und Zahlungsmethoden',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Grundinformationen',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildTextField('Salonname', _nameController, Icons.storefront),
          const SizedBox(height: 16),
          _buildTextField(
            'Beschreibung',
            _descriptionController,
            Icons.description,
          ),
          const SizedBox(height: 16),
          _buildTextField('Adresse', _addressController, Icons.location_on),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  'Stadt',
                  _cityController,
                  Icons.location_city,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  'PLZ',
                  _postalCodeController,
                  Icons.mail,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField('Telefon', _phoneController, Icons.phone),
          const SizedBox(height: 16),
          _buildTextField('E-Mail', _emailController, Icons.email),
          const SizedBox(height: 16),
          _buildTextField('Website', _websiteController, Icons.public),
          const SizedBox(height: 16),
          _buildTextField(
            'Steuernummer',
            _taxIdController,
            Icons.confirmation_number,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            'Bankverbindung',
            _bankAccountController,
            Icons.account_balance,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _saveSalonInfo,
              icon: const Icon(LucideIcons.save),
              label: const Text('Speichern'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessHoursSection() {
    final dayNames = [
      'Montag',
      'Dienstag',
      'Mittwoch',
      'Donnerstag',
      'Freitag',
      'Samstag',
      'Sonntag',
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.05),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.2), width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Öffnungszeiten',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ..._businessHours.asMap().entries.map((entry) {
            final index = entry.key;
            final hours = entry.value;
            return Column(
              children: [
                _buildBusinessHourRow(dayNames[index], hours),
                const SizedBox(height: 12),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildBusinessHourRow(String day, BusinessHours hours) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(day, style: const TextStyle(color: Colors.white)),
          ),
          Expanded(
            child: Center(
              child: hours.isOpen
                  ? Text(
                      '${hours.openTime} - ${hours.closeTime}',
                      style: const TextStyle(color: Colors.greenAccent),
                    )
                  : const Text(
                      'Geschlossen',
                      style: TextStyle(color: Colors.redAccent),
                    ),
            ),
          ),
          IconButton(
            icon: const Icon(LucideIcons.edit2),
            color: Colors.blue,
            onPressed: () => _editBusinessHours(day, hours),
            tooltip: 'Bearbeiten',
          ),
        ],
      ),
    );
  }

  Future<void> _editBusinessHours(String day, BusinessHours hours) async {
    bool isOpen = hours.isOpen;
    TimeOfDay openTime = _parseTime(hours.openTime ?? '09:00');
    TimeOfDay closeTime = _parseTime(hours.closeTime ?? '18:00');

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Oeffnungszeiten: $day'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    value: isOpen,
                    onChanged: (value) {
                      setDialogState(() => isOpen = value);
                    },
                    title: const Text('Geoeffnet'),
                  ),
                  if (isOpen) ...[
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Oeffnet um'),
                      subtitle: Text(_formatTime(openTime)),
                      trailing: const Icon(LucideIcons.clock),
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: openTime,
                        );
                        if (picked != null) {
                          setDialogState(() => openTime = picked);
                        }
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Schliesst um'),
                      subtitle: Text(_formatTime(closeTime)),
                      trailing: const Icon(LucideIcons.clock),
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: closeTime,
                        );
                        if (picked != null) {
                          setDialogState(() => closeTime = picked);
                        }
                      },
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Abbrechen'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, {
                    'isOpen': isOpen,
                    'openTime': _formatTime(openTime),
                    'closeTime': _formatTime(closeTime),
                  }),
                  child: const Text('Speichern'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == null) return;

    final success = await _service.updateBusinessHours(
      widget.salonId,
      hours.dayOfWeek,
      result['isOpen'] as bool,
      result['isOpen'] as bool ? result['openTime'] as String : null,
      result['isOpen'] as bool ? result['closeTime'] as String : null,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Oeffnungszeiten gespeichert!'),
            backgroundColor: Colors.green,
          ),
        );
        _loadSettings();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fehler beim Speichern der Oeffnungszeiten'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  TimeOfDay _parseTime(String value) {
    final parts = value.split(':');
    final hour = int.tryParse(parts.first) ?? 9;
    final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    return TimeOfDay(hour: hour, minute: minute);
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Widget _buildHolidaysSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.05),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Feiertage & Schließtage',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _addHoliday,
                icon: const Icon(LucideIcons.plus),
                label: const Text('Hinzufügen'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_holidays.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Keine Feiertage eingetragen',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white54),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _holidays.length,
              itemBuilder: (context, index) {
                final holiday = _holidays[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              holiday.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _formatHolidayDate(holiday),
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                            if (holiday.description != null && holiday.description!.trim().isNotEmpty)
                              Text(
                                holiday.description!,
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 11,
                                ),
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.trash2),
                        color: Colors.red,
                        onPressed: () {
                          _service.deleteHoliday(holiday.id).then((_) {
                            _loadSettings();
                          });
                        },
                        tooltip: 'Löschen',
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsSection() {
    final paymentTypeLabels = {
      'card': '💳 Karte',
      'cash': '💵 Bargeld',
      'transfer': '🏦 Überweisung',
      'paypal': '📱 PayPal',
      'apple_pay': '🍎 Apple Pay',
      'google_pay': '🔵 Google Pay',
    };

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.05),
        border: Border.all(
          color: Colors.green.withValues(alpha: 0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Zahlungsmethoden',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _addPaymentMethod,
                icon: const Icon(LucideIcons.plus),
                label: const Text('Hinzufügen'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_paymentMethods.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Keine Zahlungsmethoden eingetragen',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white54),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _paymentMethods.length,
              itemBuilder: (context, index) {
                final method = _paymentMethods[index];
                final methodType = method.type;
                final methodName = method.name;
                final label = paymentTypeLabels[methodType] ?? methodName;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              label,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (method.configuration != null)
                              Text(
                                'Konfiguriert',
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Switch(
                        value: method.isActive,
                        onChanged: (value) {
                          _service.togglePaymentMethod(method.id, value).then((
                            _,
                          ) {
                            _loadSettings();
                          });
                        },
                        activeColor: Colors.green,
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildBookingSettingsSection(BuildContext context) {
    // Diese Methode wird von build() aufgerufen, daher können wir hier nicht auf WidgetRef zugreifen.
    // Stattdessen erstellen wir eine Consumer-Wrapper Widget
    return Consumer(
      builder: (context, ref, child) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.05),
            border: Border.all(
              color: Colors.green.withValues(alpha: 0.2),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Buchungseinstellungen',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // DISABLED: Nutze das neue SalonBookingEnabledToggle Widget
              // DISABLED: SalonBookingEnabledToggle(
              //   salonId: widget.salonId,
              //   onChanged: () {
              //     // Optional: bei Änderung neu laden
              //     if (mounted) {
              //       setState(() {});
              //     }
              //   },
              // ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primary),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
