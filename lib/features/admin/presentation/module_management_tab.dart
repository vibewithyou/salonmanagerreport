import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/activity_log_model.dart';
import '../../../models/module_settings_model.dart';
import '../../../services/activity_log_service.dart';
import '../../../services/module_settings_service.dart';

class ModuleManagementTab extends ConsumerStatefulWidget {
  final String salonId;

  const ModuleManagementTab({
    super.key,
    required this.salonId,
  });

  @override
  ConsumerState<ModuleManagementTab> createState() =>
      _ModuleManagementTabState();
}

class _ModuleManagementTabState extends ConsumerState<ModuleManagementTab> {
  late ModuleSettingsService _moduleSettingsService;
  late ActivityLogService _activityLogService;
  bool _isLoading = false;
  List<DashboardModule> _modules = [];

  @override
  void initState() {
    super.initState();
    final client = Supabase.instance.client;
    _moduleSettingsService = ModuleSettingsService(client);
    _activityLogService = ActivityLogService(client);
    _loadModules();
  }

  Future<void> _loadModules() async {
    setState(() => _isLoading = true);
    try {
      final settings = await _moduleSettingsService.getModuleSettings(
        widget.salonId,
      );
      final settingsByType = {
        for (final setting in settings) setting.moduleType: setting,
      };

      final modules = _defaultModules().map((module) {
        final setting = settingsByType[module.type];
        if (setting == null) return module;
        return module.copyWith(
          isEnabled: setting.isEnabled,
          permissions: setting.permissions,
        );
      }).toList();

      setState(() => _modules = modules);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _toggleModule(ModuleType moduleType, bool newValue) async {
    final module = _modules.firstWhere(
      (item) => item.type == moduleType,
      orElse: () => _defaultModules().firstWhere(
        (item) => item.type == moduleType,
      ),
    );

    if (module.isRequired == true && !newValue) {
      _showErrorSnackBar('Pflichtmodule koennen nicht deaktiviert werden');
      return;
    }

    if (newValue) {
      try {
        final success = await _moduleSettingsService.enableModule(
          widget.salonId,
          moduleType,
          permissions: module.permissions,
        );
        if (!success) {
          _showErrorSnackBar('Fehler beim Aktivieren des Moduls');
          return;
        }
        await _loadModules();
        await _logModuleActivity(moduleType, true);
        _showSuccessSnackBar('Modul aktiviert');
      } catch (e) {
        _showErrorSnackBar('Fehler beim Aktivieren des Moduls');
      }
    } else {
      // Show confirmation dialog before disabling
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Modul deaktivieren?'),
          content: const Text(
            'Sind Sie sicher, dass Sie dieses Modul deaktivieren möchten? '
            'Die Daten bleiben erhalten, sind aber nicht mehr zugänglich.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Deaktivieren',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );

      if (confirm ?? false) {
        try {
          final success = await _moduleSettingsService.disableModule(
            widget.salonId,
            moduleType,
          );
          if (!success) {
            _showErrorSnackBar('Fehler beim Deaktivieren des Moduls');
            return;
          }
          await _loadModules();
          await _logModuleActivity(moduleType, false);
          _showSuccessSnackBar('Modul deaktiviert');
        } catch (e) {
          _showErrorSnackBar('Fehler beim Deaktivieren des Moduls');
        }
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _editPermissions(DashboardModule module) async {
    final selected = <ModulePermission>{...module.permissions};

    final updated = await showDialog<List<ModulePermission>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Berechtigungen: ${module.label}'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: ModulePermission.values.map((permission) {
                    final isChecked = selected.contains(permission);
                    return CheckboxListTile(
                      value: isChecked,
                      onChanged: (checked) {
                        setDialogState(() {
                          if (checked == true) {
                            selected.add(permission);
                          } else {
                            selected.remove(permission);
                          }
                        });
                      },
                      title: Text(_permissionLabel(permission)),
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Abbrechen'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(
                    context,
                    selected.toList(),
                  ),
                  child: const Text('Speichern'),
                ),
              ],
            );
          },
        );
      },
    );

    if (updated == null) return;

    final success = await _moduleSettingsService.updateModuleSetting(
      salonId: widget.salonId,
      moduleType: module.type,
      isEnabled: module.isEnabled,
      permissions: updated,
    );

    if (!success) {
      _showErrorSnackBar('Berechtigungen konnten nicht gespeichert werden');
      return;
    }

    await _loadModules();
    _showSuccessSnackBar('Berechtigungen gespeichert');
  }

  String _permissionLabel(ModulePermission permission) {
    switch (permission) {
      case ModulePermission.view:
        return 'Anzeigen';
      case ModulePermission.create:
        return 'Erstellen';
      case ModulePermission.edit:
        return 'Bearbeiten';
      case ModulePermission.delete:
        return 'Loeschen';
      case ModulePermission.export:
        return 'Exportieren';
      case ModulePermission.manage:
        return 'Verwalten';
    }
  }

  Future<void> _logModuleActivity(ModuleType moduleType, bool enabled) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    await _activityLogService.logActivity(
      salonId: widget.salonId,
      userId: user.id,
      userName: user.email ?? 'Admin',
      type: enabled ? ActivityType.moduleEnabled : ActivityType.moduleDisabled,
      description: enabled ? 'Modul aktiviert' : 'Modul deaktiviert',
      metadata: {
        'module_type': moduleType.name,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(),
          const SizedBox(height: 32),

          // Module Grid
          _buildModuleGrid(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🧩 Modul-Verwaltung',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Aktivieren oder deaktivieren Sie Module für Ihren Salon',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildModuleGrid() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final modules = _modules.isEmpty ? _defaultModules() : _modules;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: modules.length,
      itemBuilder: (context, index) => _buildModuleCard(modules[index]),
    );
  }

  List<DashboardModule> _defaultModules() {
    return const [
      DashboardModule(
        type: ModuleType.timeTracking,
        label: 'Zeiterfassung',
        icon: '⏱️',
        description: 'Arbeitszeiterfassung fuer Mitarbeiter',
        isEnabled: true,
        permissions: [ModulePermission.view, ModulePermission.create],
        isPremium: false,
        isRequired: true,
      ),
      DashboardModule(
        type: ModuleType.appointments,
        label: 'Termine',
        icon: '📅',
        description: 'Terminverwaltung und Buchungen',
        isEnabled: true,
        permissions: [ModulePermission.view, ModulePermission.edit],
        isPremium: false,
        isRequired: true,
      ),
      DashboardModule(
        type: ModuleType.qrCheckin,
        label: 'QR Check-in',
        icon: '🔷',
        isEnabled: true,
        permissions: [ModulePermission.view],
        isPremium: false,
      ),
      DashboardModule(
        type: ModuleType.leaveRequests,
        label: 'Urlaubsantraege',
        icon: '🏖️',
        isEnabled: true,
        permissions: [ModulePermission.view],
        isPremium: false,
      ),
      DashboardModule(
        type: ModuleType.pos,
        label: 'POS-System',
        icon: '💳',
        isEnabled: false,
        permissions: [],
        isPremium: true,
      ),
      DashboardModule(
        type: ModuleType.inventory,
        label: 'Inventar',
        icon: '📦',
        isEnabled: false,
        permissions: [],
        isPremium: true,
      ),
    ];
  }

  Widget _buildModuleCard(DashboardModule module) {
    final isEnabled = module.isEnabled;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: isEnabled ? 0.1 : 0.05,
        ),
        border: Border.all(
          color: isEnabled
              ? Colors.greenAccent.withValues(alpha: 0.3)
              : Colors.white.withValues(alpha: 0.1),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                module.icon,
                style: const TextStyle(fontSize: 28),
              ),
              if (module.isPremium)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Premium',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else if (module.isRequired ?? false)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Erforderlich',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.lightBlueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            module.label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            module.description ?? '',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white70,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          if (isEnabled)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _editPermissions(module),
                icon: const Icon(LucideIcons.shield, size: 16),
                label: const Text('Berechtigungen'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
              ),
            ),
          if (isEnabled) const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (module.isRequired ?? false)
                const SizedBox.shrink()
              else
                Switch(
                  value: isEnabled,
                  onChanged: (module.isRequired ?? false)
                      ? null
                      : (val) => _toggleModule(module.type, val),
                  activeColor: Colors.greenAccent,
                ),
              if (isEnabled)
                Tooltip(
                  message: 'Aktiv',
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.check,
                      color: Colors.greenAccent,
                      size: 16,
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
