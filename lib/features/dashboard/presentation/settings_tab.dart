import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salonmanager/providers/dashboard_providers.dart';
import 'package:salonmanager/core/constants/app_colors.dart';

class SettingsTab extends ConsumerStatefulWidget {
  final String salonId;

  const SettingsTab({required this.salonId, super.key});

  @override
  ConsumerState<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends ConsumerState<SettingsTab> {
  late final salonNameController = TextEditingController();
  late final salonPhoneController = TextEditingController();
  late final salonEmailController = TextEditingController();
  late final salonAddressController = TextEditingController();

  @override
  void dispose() {
    salonNameController.dispose();
    salonPhoneController.dispose();
    salonEmailController.dispose();
    salonAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final salonSettings = ref.watch(salonSettingsProvider(widget.salonId));
    final salonCode = ref.watch(salonCodeProvider(widget.salonId));

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Salon Settings Section
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '⚙️ Salon-Einstellungen',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 16),
                salonSettings.when(
                  loading: () => Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Text('Fehler: $error'),
                  data: (settings) {
                    if (settings == null) {
                      return Text('Keine Einstellungen gefunden');
                    }

                    // Initialize controllers
                    if (salonNameController.text.isEmpty) {
                      salonNameController.text = settings.salonName;
                      salonPhoneController.text = settings.phone ?? '';
                      salonEmailController.text = settings.email ?? '';
                      salonAddressController.text = settings.address ?? '';
                    }

                    return Column(
                      children: [
                        TextField(
                          controller: salonNameController,
                          decoration: InputDecoration(
                            labelText: 'Salonname',
                            prefixIcon: Icon(Icons.business),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        TextField(
                          controller: salonPhoneController,
                          decoration: InputDecoration(
                            labelText: 'Telefon',
                            prefixIcon: Icon(Icons.phone),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: 12),
                        TextField(
                          controller: salonEmailController,
                          decoration: InputDecoration(
                            labelText: 'E-Mail',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 12),
                        TextField(
                          controller: salonAddressController,
                          decoration: InputDecoration(
                            labelText: 'Adresse',
                            prefixIcon: Icon(Icons.location_on),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _saveSalonSettings(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            minimumSize: Size.fromHeight(44),
                          ),
                          child: Text('Speichern'),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          Divider(height: 32),
          // Salon Code Section
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🔐 Salon-Code',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 12),
                Text(
                  'Der Salon-Code wird verwendet, um Mitarbeiter beim Dashboard zu authentifizieren.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                ),
                SizedBox(height: 16),
                salonCode.when(
                  loading: () => Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Text('Fehler: $error'),
                  data: (code) => Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.5),
                      ),
                      color: AppColors.primary.withValues(alpha: 0.1),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Aktueller Code',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              SizedBox(height: 4),
                              Text(
                                code ?? '••••••••',
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      fontFamily: 'monospace',
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _copyCode(code),
                          icon: Icon(Icons.copy),
                          label: Text('Kopieren'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => _resetSalonCode(),
                  icon: Icon(Icons.refresh),
                  label: Text('Code zurücksetzen'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    minimumSize: Size.fromHeight(44),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 32),
          // Module Settings
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📦 Module',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 12),
                _ModuleControl(
                  name: 'Zeiterfassung',
                  icon: Icons.schedule,
                  enabled: true,
                  onToggle: (enabled) {
                    // Implementation
                  },
                ),
                SizedBox(height: 8),
                _ModuleControl(
                  name: 'Mitarbeiterverwaltung',
                  icon: Icons.people,
                  enabled: true,
                  onToggle: (enabled) {
                    // Implementation
                  },
                ),
                SizedBox(height: 8),
                _ModuleControl(
                  name: 'Galerie',
                  icon: Icons.image,
                  enabled: true,
                  onToggle: (enabled) {
                    // Implementation
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveSalonSettings() async {
    final service = ref.read(dashboardServiceProvider);
    final success = await service.updateSalonSettings(
      widget.salonId,
      {
        'salon_name': salonNameController.text,
        'phone': salonPhoneController.text,
        'email': salonEmailController.text,
        'address': salonAddressController.text,
      },
    );

    if (success) {
      ref.invalidate(salonSettingsProvider(widget.salonId));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Einstellungen gespeichert'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Fehler beim Speichern'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _resetSalonCode() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Salon-Code zurücksetzen'),
        content: Text(
            'Sind Sie sicher? Der alte Code wird ungültig und ein neuer wird generiert.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () async {
              final service = ref.read(dashboardServiceProvider);
              final newCode = await service.updateSalonCode(
                widget.salonId,
                '',
                regenerate: true,
              );
              ref.invalidate(salonCodeProvider(widget.salonId));
              if (!mounted) return;
              Navigator.pop(context);
              if (newCode != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('✅ Code zurückgesetzt')),
                );
              }
            },
            child: Text('Zurücksetzen', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _copyCode(String? code) {
    if (code != null) {
      // Copy to clipboard implementation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Code kopiert'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}

class _ModuleControl extends StatefulWidget {
  final String name;
  final IconData icon;
  final bool enabled;
  final Function(bool) onToggle;

  const _ModuleControl({
    required this.name,
    required this.icon,
    required this.enabled,
    required this.onToggle,
  });

  @override
  State<_ModuleControl> createState() => _ModuleControlState();
}

class _ModuleControlState extends State<_ModuleControl> {
  late bool _enabled = widget.enabled;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
        ),
        color: isDark ? Colors.grey[900] : Colors.grey[50],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(widget.icon, color: AppColors.primary),
              SizedBox(width: 12),
              Text(widget.name, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
          Switch(
            value: _enabled,
            onChanged: (value) {
              setState(() => _enabled = value);
              widget.onToggle(value);
            },
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
