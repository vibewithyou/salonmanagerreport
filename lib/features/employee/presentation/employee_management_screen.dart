import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/activity_log_model.dart';
import '../../../models/module_settings_model.dart';
import '../../../models/employee_model.dart';
import '../../../providers/employee_provider.dart';
import '../../../services/activity_log_service.dart';
import '../../../services/employee_permissions_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'add_employee_dialog.dart';
import 'employee_detail_screen.dart';

class EmployeeManagementScreen extends ConsumerWidget {
  const EmployeeManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeesAsync = ref.watch(employeesProvider);
    final summaryAsync = ref.watch(employeeSummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('employee.management'.tr()),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(context: context, builder: (context) => const AddEmployeeDialog());
              },
              icon: const Icon(Icons.person_add),
              label: Text('employee.invite'.tr()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            summaryAsync.when(
              data: (summary) => Row(
                children: [
                  _buildStatCard('employee.total'.tr(), summary.totalEmployees.toString(), AppColors.primary),
                  const SizedBox(width: 12),
                  _buildStatCard('employee.stylists'.tr(), summary.stylists.toString(), const Color(0xFFE8A08F)),
                  const SizedBox(width: 12),
                  _buildStatCard('employee.active'.tr(), summary.activeEmployees.toString(), Colors.green),
                ],
              ),
              loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
              error: (err, stack) => SizedBox(height: 100, child: Center(child: Text('Error: $err'))),
            ),
            const SizedBox(height: 24),
            employeesAsync.when(
              data: (employees) {
                if (employees.isEmpty) {
                  return Container(
                    decoration: BoxDecoration(gradient: AppTheme.liquidGlass),
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(Icons.people_outline, size: 64, color: AppColors.primary.withValues(alpha: 0.5)),
                        const SizedBox(height: 16),
                        Text('employee.no_employees'.tr(), style: AppStyles.headlineSmall),
                        const SizedBox(height: 8),
                        Text('employee.add_first'.tr(), style: AppStyles.bodyMedium.copyWith(color: Colors.grey)),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: employees.length,
                  itemBuilder: (context, index) => _buildEmployeeCard(context, ref, employees[index]),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(value, style: AppStyles.headlineMedium.copyWith(color: color)),
            const SizedBox(height: 4),
            Text(label, style: AppStyles.labelSmall, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeCard(BuildContext context, WidgetRef ref, Employee employee) {
    final roleColor = _getRoleColor(employee.role);
    final isActive = employee.isActive ?? true;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: roleColor.withValues(alpha: 0.2),
          ),
          child: Center(
            child: Text('${employee.firstName[0]}${employee.lastName[0]}'.toUpperCase(), 
              style: AppStyles.headlineMedium.copyWith(color: roleColor)),
          ),
        ),
        title: Row(
          children: [
            Expanded(child: Text('${employee.firstName} ${employee.lastName}', style: AppStyles.titleMedium)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: roleColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
              child: Text(employee.role.toUpperCase(), 
                style: AppStyles.labelSmall.copyWith(color: roleColor, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isActive ? Colors.green.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isActive ? 'Aktiv' : 'Inaktiv',
                style: AppStyles.labelSmall.copyWith(
                  color: isActive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        subtitle: Text('${employee.phone} • ${employee.email}', style: AppStyles.labelSmall, maxLines: 1),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Row(children: [const Icon(Icons.badge), const SizedBox(width: 12), const Text('Rolle aendern')]),
              onTap: () => _showRoleDialog(context, ref, employee),
            ),
            PopupMenuItem(
              child: Row(children: [const Icon(Icons.shield), const SizedBox(width: 12), const Text('Berechtigungen')]),
              onTap: () => _showPermissionsDialog(context, employee),
            ),
            PopupMenuItem(
              child: Row(children: [const Icon(Icons.toggle_on), const SizedBox(width: 12), Text(isActive ? 'Deaktivieren' : 'Aktivieren')]),
              onTap: () => _showStatusDialog(context, ref, employee, isActive),
            ),
            PopupMenuItem(
              child: Row(children: [const Icon(Icons.person), const SizedBox(width: 12), Text('employee.view_details'.tr())]),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeDetailScreen(employeeId: employee.id))),
            ),
            PopupMenuItem(
              child: Row(children: [const Icon(Icons.delete, color: Colors.red), const SizedBox(width: 12), Text('common.delete'.tr())]),
              onTap: () => _showDeleteConfirmation(context, ref, employee),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'manager': return Colors.purple;
      case 'stylist': return const Color(0xFFE8A08F);
      case 'receptionist': return Colors.blue;
      default: return Colors.grey;
    }
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, Employee employee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('employee.delete_title'.tr()),
        content: Text('employee.delete_confirmation'.tr(args: ['${employee.firstName} ${employee.lastName}'])),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('common.cancel'.tr())),
          TextButton(
            onPressed: () {
              ref.read(employeeNotifierProvider.notifier).deleteEmployee(employee.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('common.delete'.tr()),
          ),
        ],
      ),
    );
  }

  void _showRoleDialog(BuildContext context, WidgetRef ref, Employee employee) {
    final roles = ['manager', 'stylist', 'receptionist', 'other'];
    String selectedRole = employee.role;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rolle aendern'),
        content: DropdownButtonFormField<String>(
          value: selectedRole,
          items: roles
              .map((role) => DropdownMenuItem(value: role, child: Text(role.toUpperCase())))
              .toList(),
          onChanged: (value) {
            if (value == null) return;
            selectedRole = value;
          },
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(employeeNotifierProvider.notifier).updateEmployee(
                employee.id,
                {'role': selectedRole},
              );
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: Text('common.save'.tr()),
          ),
        ],
      ),
    );
  }

  void _showStatusDialog(
    BuildContext context,
    WidgetRef ref,
    Employee employee,
    bool isActive,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isActive ? 'Mitarbeiter deaktivieren' : 'Mitarbeiter aktivieren'),
        content: Text(
          isActive
              ? 'Soll dieser Mitarbeiter deaktiviert werden?'
              : 'Soll dieser Mitarbeiter aktiviert werden?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(employeeNotifierProvider.notifier).toggleActiveStatus(
                employee.id,
                !isActive,
              );
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: Text(isActive ? 'Deaktivieren' : 'Aktivieren'),
          ),
        ],
      ),
    );
  }

  Future<void> _showPermissionsDialog(
    BuildContext context,
    Employee employee,
  ) async {
    final salonId = employee.salonId;
    if (salonId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kein Salon gefunden.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final service = EmployeePermissionsService(Supabase.instance.client);
    final existing = await service.getEmployeePermissions(employee.id);

    final permissionsByModule = <ModuleType, Set<ModulePermission>>{
      for (final module in ModuleType.values) module: <ModulePermission>{},
    };

    for (final item in existing) {
      permissionsByModule[item.moduleType] = item.permissions.toSet();
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Berechtigungen: ${employee.firstName} ${employee.lastName}'),
              content: SizedBox(
                width: 500,
                child: ListView(
                  shrinkWrap: true,
                  children: ModuleType.values.map((module) {
                    final selected = permissionsByModule[module] ?? <ModulePermission>{};
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _moduleLabel(module),
                            style: AppStyles.titleSmall.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: ModulePermission.values.map((permission) {
                              final isSelected = selected.contains(permission);
                              return FilterChip(
                                label: Text(_permissionLabel(permission)),
                                selected: isSelected,
                                onSelected: (value) {
                                  setDialogState(() {
                                    if (value) {
                                      selected.add(permission);
                                    } else {
                                      selected.remove(permission);
                                    }
                                    permissionsByModule[module] = selected;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('common.cancel'.tr()),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('common.save'.tr()),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != true) return;

    final cleaned = <ModuleType, List<ModulePermission>>{};
    permissionsByModule.forEach((module, perms) {
      if (perms.isNotEmpty) {
        cleaned[module] = perms.toList();
      }
    });

    final success = await service.setEmployeePermissions(
      salonId: salonId,
      employeeId: employee.id,
      permissionsByModule: cleaned,
    );

    if (!context.mounted) return;

    if (success) {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        await ActivityLogService(Supabase.instance.client).logActivity(
          salonId: salonId,
          userId: user.id,
          userName: user.email ?? 'Admin',
          type: ActivityType.permissionChanged,
          description: 'Berechtigungen geaendert',
          metadata: {
            'employee_id': employee.id,
          },
        );
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Berechtigungen gespeichert' : 'Fehler beim Speichern'),
        backgroundColor: success ? Colors.green : AppColors.error,
      ),
    );
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

  String _moduleLabel(ModuleType module) {
    switch (module) {
      case ModuleType.timeTracking:
        return 'Zeiterfassung';
      case ModuleType.appointments:
        return 'Termine';
      case ModuleType.qrCheckin:
        return 'QR Check-in';
      case ModuleType.leaveRequests:
        return 'Urlaubsantraege';
      case ModuleType.shifts:
        return 'Dienstplan';
      case ModuleType.pos:
        return 'POS';
      case ModuleType.inventory:
        return 'Inventar';
      case ModuleType.gallery:
        return 'Galerie';
      case ModuleType.chat:
        return 'Chat';
      case ModuleType.messaging:
        return 'Nachrichten';
      case ModuleType.reports:
        return 'Berichte';
      case ModuleType.coupons:
        return 'Coupons';
      case ModuleType.calendar:
        return 'Kalender';
      case ModuleType.loyaltyProgram:
        return 'Loyalty';
    }
  }
}
