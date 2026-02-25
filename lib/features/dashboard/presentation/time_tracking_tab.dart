import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salonmanager/core/constants/app_colors.dart';
import 'package:salonmanager/core/auth/user_role_helpers.dart';
import 'package:salonmanager/core/auth/identity_provider.dart';
import 'package:salonmanager/providers/dashboard_providers.dart';

class TimeTrackingTab extends ConsumerStatefulWidget {
  final String salonId;

  const TimeTrackingTab({required this.salonId, super.key});

  @override
  ConsumerState<TimeTrackingTab> createState() => _TimeTrackingTabState();
}

class _TimeTrackingTabState extends ConsumerState<TimeTrackingTab> {
  late final timeCodeController = TextEditingController();
  String selectedEntryType = 'clock_in';
  bool _isSubmitting = false;
  String? _errorMessage;
  String? _successMessage;
  bool _isLoadingActiveEmployees = true;
  String? _activeEmployeesError;
  List<Map<String, dynamic>> _activeEmployees = const [];
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _loadActiveEmployees();
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _loadActiveEmployees();
    });
  }

  @override
  void didUpdateWidget(covariant TimeTrackingTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.salonId != widget.salonId) {
      _loadActiveEmployees(forceLoading: true);
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    timeCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time Entry Input Section
          Padding(
            padding: EdgeInsets.all(16),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: isDark ? Colors.grey[900] : Colors.blue[50],
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '⏱️ Zeiterfassung',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: timeCodeController,
                      decoration: InputDecoration(
                        labelText: 'Mitarbeiter-Code eingeben',
                        prefixIcon: Icon(Icons.qr_code_2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onSubmitted: (_) => _submitTimeEntry(),
                    ),
                    SizedBox(height: 12),
                    if (_errorMessage != null) ...[
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red.shade800),
                        ),
                      ),
                    ],
                    if (_successMessage != null) ...[
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Text(
                          _successMessage!,
                          style: TextStyle(color: Colors.green.shade800),
                        ),
                      ),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: DropdownButton<String>(
                            value: selectedEntryType,
                            isExpanded: true,
                            items:
                                [
                                      ('clock_in', '🔵 Einstempeln'),
                                      ('clock_out', '🔴 Ausstempeln'),
                                      ('break_start', '☕ Pause Start'),
                                      ('break_end', '✅ Pause Ende'),
                                    ]
                                    .map(
                                      (item) => DropdownMenuItem(
                                        value: item.$1,
                                        child: Text(item.$2),
                                      ),
                                    )
                                    .toList(),
                            onChanged: _isSubmitting
                                ? null
                                : (value) {
                                    if (value != null) {
                                      setState(() => selectedEntryType = value);
                                    }
                                  },
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _submitTimeEntry,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                            ),
                            child: _isSubmitting
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text('Erfassen'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          // Active Employees Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '👥 Aktive Mitarbeiter heute',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 12),
          _buildActiveEmployees(),
        ],
      ),
    );
  }

  Widget _buildActiveEmployees() {
    if (_isLoadingActiveEmployees) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_activeEmployeesError != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fehler beim Laden aktiver Mitarbeiter',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(_activeEmployeesError!),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => _loadActiveEmployees(forceLoading: true),
                  child: const Text('Erneut laden'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_activeEmployees.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Keine aktiven Mitarbeiter im Dienst.'),
        ),
      );
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _activeEmployees.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final employee = _activeEmployees[index];
        final name = employee['employee_name'] as String? ?? 'Unbekannt';
        final lastEntryType =
            employee['last_entry_type'] as String? ?? 'unknown';
        final lastEntryTimeRaw = employee['last_entry_time'];
        final totalMinutes =
            (employee['total_minutes_worked'] as num?)?.toInt() ?? 0;

        DateTime? lastEntryTime;
        if (lastEntryTimeRaw is String && lastEntryTimeRaw.isNotEmpty) {
          lastEntryTime = DateTime.tryParse(lastEntryTimeRaw);
        }

        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _statusColor(
                lastEntryType,
              ).withValues(alpha: 0.15),
              child: Icon(Icons.person, color: _statusColor(lastEntryType)),
            ),
            title: Text(name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('Status: ${_statusLabel(lastEntryType)}'),
                Text('Letzte Aktion: ${_formatActionTime(lastEntryTime)}'),
                Text('Tagesdauer: ${_formatMinutes(totalMinutes)}'),
                if (lastEntryType != 'clock_out') ...[
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _isSubmitting
                        ? null
                        : () => _submitTimeEntry(
                            overrideEmployeeId:
                                employee['employee_id'] as String?,
                            overrideEmployeeName: name,
                            forceEntryType: 'clock_out',
                          ),
                    icon: const Icon(
                      Icons.admin_panel_settings_outlined,
                      size: 16,
                    ),
                    label: const Text('Admin: Ausstempeln'),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitTimeEntry({
    String? overrideEmployeeId,
    String? overrideEmployeeName,
    String? forceEntryType,
  }) async {
    final rawCode = timeCodeController.text.trim();
    final isOverride = overrideEmployeeId != null;
    final effectiveEntryType = forceEntryType ?? selectedEntryType;
    final identity = ref.read(identityProvider);

    if (rawCode.isEmpty) {
      setState(() {
        _errorMessage = isOverride
            ? 'Für den Admin-Override muss ein gültiger Mitarbeiter-Code eingegeben werden.'
            : 'Bitte Mitarbeiter-Code eingeben.';
        _successMessage = null;
      });
      return;
    }

    if (!RegExp(r'^\d{6}$').hasMatch(rawCode)) {
      setState(() {
        _errorMessage = 'Der Mitarbeiter-Code muss genau 6 Ziffern haben.';
        _successMessage = null;
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
      _successMessage = null;
    });

    final dashboardService = ref.read(dashboardServiceProvider);

    final verification = await dashboardService.verifyEmployeeTimeCode(rawCode);

    final verifiedEmployeeId = verification?['employee_id'] as String?;
    final verifiedEmployeeName = verification?['employee_name'] as String?;
    final verifiedSalonId = verification?['salon_id'] as String?;

    if (verification == null ||
        verifiedEmployeeId == null ||
        verifiedEmployeeId.isEmpty) {
      setState(() {
        _isSubmitting = false;
        _errorMessage = 'Ungültiger Mitarbeiter-Code. Bitte prüfe die Eingabe.';
      });
      return;
    }

    if (verifiedSalonId != null && verifiedSalonId != widget.salonId) {
      setState(() {
        _isSubmitting = false;
        _errorMessage = 'Der Code gehört nicht zu diesem Salon.';
      });
      return;
    }

    if (isOverride) {
      if (!isAdminRole(identity.roleKey)) {
        setState(() {
          _isSubmitting = false;
          _errorMessage =
              'Override nicht erlaubt: aktueller Benutzer hat keine Admin-Berechtigung.';
        });
        return;
      }

      final dashboardService = ref.read(dashboardServiceProvider);
      final isVerifierAdmin = await dashboardService.isAdminEmployee(
        verifiedEmployeeId,
      );
      if (!isVerifierAdmin) {
        setState(() {
          _isSubmitting = false;
          _errorMessage =
              'Override abgelehnt: Der eingegebene Code gehört nicht zu einem Admin/Manager.';
        });
        return;
      }
    }

    final createdEntry = await dashboardService.createTimeEntry(
      widget.salonId,
      overrideEmployeeId ?? verifiedEmployeeId,
      effectiveEntryType,
      isOverride
          ? 'Admin-Override: $overrideEmployeeName durch ${verifiedEmployeeName ?? 'Unbekannt'}'
          : null,
    );

    if (createdEntry == null) {
      setState(() {
        _isSubmitting = false;
        _errorMessage = 'Zeitbuchung fehlgeschlagen. Bitte erneut versuchen.';
      });
      return;
    }

    final actionLabel = switch (effectiveEntryType) {
      'clock_in' => 'Einstempeln',
      'clock_out' => 'Ausstempeln',
      'break_start' => 'Pause Start',
      'break_end' => 'Pause Ende',
      _ => effectiveEntryType,
    };

    if (isOverride) {
      await dashboardService.logDashboardActivity(
        salonId: widget.salonId,
        userId: identity.userId,
        action: 'admin_override_clock_out',
        details: {
          'verified_by_employee_id': verifiedEmployeeId,
          'verified_by_employee_name': verifiedEmployeeName,
          'target_employee_id': overrideEmployeeId,
          'target_employee_name': overrideEmployeeName,
          'entry_type': effectiveEntryType,
        },
      );
    }

    setState(() {
      _isSubmitting = false;
      _errorMessage = null;
      _successMessage = isOverride
          ? 'Override erfolgreich: ${overrideEmployeeName ?? 'Mitarbeiter'} wurde ausgestempelt.'
          : '${verifiedEmployeeName ?? 'Mitarbeiter'}: $actionLabel erfolgreich erfasst.';
      timeCodeController.clear();
    });

    _loadActiveEmployees();
  }

  Future<void> _loadActiveEmployees({bool forceLoading = false}) async {
    if (!mounted) return;

    if (forceLoading) {
      setState(() {
        _isLoadingActiveEmployees = true;
        _activeEmployeesError = null;
      });
    }

    final dashboardService = ref.read(dashboardServiceProvider);
    final result = await dashboardService.getActiveEmployeesToday(
      widget.salonId,
    );

    if (!mounted) return;

    setState(() {
      _isLoadingActiveEmployees = false;

      if (result == null) {
        _activeEmployeesError =
            'Die aktiven Mitarbeiter konnten nicht geladen werden.';
        _activeEmployees = const [];
        return;
      }

      _activeEmployeesError = null;
      _activeEmployees = result
          .where((entry) {
            final lastType = entry['last_entry_type'] as String?;
            return lastType == 'clock_in' ||
                lastType == 'break_start' ||
                lastType == 'break_end';
          })
          .toList(growable: false);
    });
  }

  String _statusLabel(String entryType) {
    switch (entryType) {
      case 'clock_in':
        return 'Arbeitet';
      case 'break_start':
        return 'In Pause';
      case 'break_end':
        return 'Arbeitet';
      case 'clock_out':
        return 'Nicht im Dienst';
      default:
        return 'Unbekannt';
    }
  }

  Color _statusColor(String entryType) {
    switch (entryType) {
      case 'clock_in':
        return Colors.green;
      case 'break_start':
        return Colors.orange;
      case 'break_end':
        return Colors.blue;
      case 'clock_out':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _formatActionTime(DateTime? timestamp) {
    if (timestamp == null) return '—';
    final local = timestamp.toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatMinutes(int totalMinutes) {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    return '${hours}h ${minutes}m';
  }
}
