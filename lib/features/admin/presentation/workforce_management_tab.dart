import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/auth/identity_provider.dart';
import '../../../services/workforce_service.dart';

class _EmployeeLeaveKpi {
  final int approvedVacationDays;
  final int pendingVacationDays;
  final int sickDays;
  final int? vacationAllowance;

  const _EmployeeLeaveKpi({
    required this.approvedVacationDays,
    required this.pendingVacationDays,
    required this.sickDays,
    required this.vacationAllowance,
  });

  int? get remainingVacation {
    if (vacationAllowance == null) {
      return null;
    }

    final remaining = vacationAllowance! - approvedVacationDays;
    return remaining < 0 ? 0 : remaining;
  }
}

class WorkforceManagementTab extends StatefulWidget {
  final String salonId;
  final List<SalonInfo> availableSalons;

  const WorkforceManagementTab({
    super.key,
    required this.salonId,
    this.availableSalons = const [],
  });

  @override
  State<WorkforceManagementTab> createState() => _WorkforceManagementTabState();
}

class _WorkforceManagementTabState extends State<WorkforceManagementTab> {
  late final WorkforceService _service;

  bool _isLoading = true;
  String? _loadError;
  List<WorkforceEmployee> _employees = [];
  List<WorkforceLeaveRequest> _pendingRequests = [];
  List<WorkforceSchedule> _selectedEmployeeSchedules = [];
  WorkforceEmployee? _selectedEmployee;

  int _selectedDay = 0;
  final _startController = TextEditingController(text: '09:00');
  final _endController = TextEditingController(text: '18:00');
  DateTime _assignmentDate = DateTime.now();
  String? _selectedAssignmentSalonId;

  int _approvedVacationDays = 0;
  int _pendingVacationDays = 0;
  int _sickDays = 0;
  Map<String, _EmployeeLeaveKpi> _employeeLeaveKpis = {};
  Set<String> _requestActionLoading = <String>{};
  Map<String, SalonOpeningHour> _openingHours = {};
  List<SalonClosure> _closures = [];

  @override
  void initState() {
    super.initState();
    _service = WorkforceService(Supabase.instance.client);
    _selectedAssignmentSalonId = widget.salonId;
    _load();
  }

  @override
  void didUpdateWidget(covariant WorkforceManagementTab oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.salonId != widget.salonId) {
      _selectedAssignmentSalonId = widget.salonId;
      _load();
      return;
    }

    if (_selectedAssignmentSalonId == null ||
        !_effectiveSalons.any((salon) => salon.id == _selectedAssignmentSalonId)) {
      _selectedAssignmentSalonId = widget.salonId;
    }
  }

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);

    try {
      final employees = await _service.getSalonEmployees(widget.salonId);
      final pending = await _service.getLeaveRequests(
        salonId: widget.salonId,
        status: 'pending',
      );
      final openingHours = await _service.getSalonOpeningHours(widget.salonId);
      final closures = await _service.getSalonClosures(widget.salonId);

      int approvedVacationDays = 0;
      int pendingVacationDays = 0;
      int sickDays = 0;
      final employeeLeaveKpis = <String, _EmployeeLeaveKpi>{};

      final year = DateTime.now().year;
      for (final employee in employees) {
        final summary = await _service.getEmployeeLeaveSummary(
          employeeId: employee.id,
          year: year,
        );
        final vacationAllowance = await _service.getEmployeeVacationAllowance(employee.id);

        final approved = summary['approvedVacationDays'] ?? 0;
        final pendingVacation = summary['pendingVacationDays'] ?? 0;
        final sick = summary['sickDays'] ?? 0;

        employeeLeaveKpis[employee.id] = _EmployeeLeaveKpi(
          approvedVacationDays: approved,
          pendingVacationDays: pendingVacation,
          sickDays: sick,
          vacationAllowance: vacationAllowance,
        );

        approvedVacationDays += approved;
        pendingVacationDays += pendingVacation;
        sickDays += sick;
      }

      WorkforceEmployee? selectedEmployee = _selectedEmployee;
      if (selectedEmployee == null && employees.isNotEmpty) {
        selectedEmployee = employees.first;
      }

      List<WorkforceSchedule> schedules = [];
      if (selectedEmployee != null) {
        schedules = await _service.getEmployeeSchedules(selectedEmployee.id);
      }

      final assignmentSalonId = _selectedAssignmentSalonId;
      final isValidAssignmentSalon = assignmentSalonId != null &&
          _effectiveSalons.any((salon) => salon.id == assignmentSalonId);

      if (!mounted) return;
      setState(() {
        _employees = employees;
        _pendingRequests = pending;
        _selectedEmployee = selectedEmployee;
        _selectedEmployeeSchedules = schedules;
        _approvedVacationDays = approvedVacationDays;
        _pendingVacationDays = pendingVacationDays;
        _sickDays = sickDays;
        _employeeLeaveKpis = employeeLeaveKpis;
        _openingHours = openingHours;
        _closures = closures;
        _selectedAssignmentSalonId =
            isValidAssignmentSalon ? assignmentSalonId : widget.salonId;
        _loadError = null;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loadError = error.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _onSelectEmployee(WorkforceEmployee? employee) async {
    if (employee == null) return;
    try {
      final schedules = await _service.getEmployeeSchedules(employee.id);

      if (!mounted) return;
      setState(() {
        _selectedEmployee = employee;
        _selectedEmployeeSchedules = schedules;
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mitarbeiterdaten konnten nicht geladen werden: $error')),
      );
    }
  }

  Future<void> _saveRecurringSchedule() async {
    final employee = _selectedEmployee;
    if (employee == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte zuerst Mitarbeiter auswählen.')),
      );
      return;
    }

    try {
      final validation = await _service.validateRecurringScheduleAssignment(
        salonId: widget.salonId,
        employeeId: employee.id,
        dayOfWeek: _selectedDay,
        startTime: _startController.text,
        endTime: _endController.text,
      );

      if (!validation.canSave) {
        final message = validation.blockingIssues.join(' ');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message.isEmpty ? 'Schicht ungültig' : message)),
        );
        return;
      }

      if (validation.warnings.isNotEmpty) {
        final proceed = await _confirmWarnings(validation.warnings);
        if (proceed != true) {
          return;
        }
      }

      await _service.setRecurringSchedule(
        employeeId: employee.id,
        dayOfWeek: _selectedDay,
        startTime: _startController.text,
        endTime: _endController.text,
        salonId: widget.salonId,
      );

      final schedules = await _service.getEmployeeSchedules(employee.id);
      if (!mounted) return;

      setState(() {
        _selectedEmployeeSchedules = schedules;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dienstplan gespeichert')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Speichern fehlgeschlagen: $error')),
      );
    }
  }

  Future<void> _saveSpecificSalonAssignment() async {
    final employee = _selectedEmployee;
    if (employee == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte zuerst Mitarbeiter auswählen.')),
      );
      return;
    }

    final assignmentSalonId = _selectedAssignmentSalonId;
    if (assignmentSalonId == null || assignmentSalonId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte Einsatz-Salon auswählen.')),
      );
      return;
    }

    try {
      final validation = await _service.validateRecurringScheduleAssignment(
        salonId: assignmentSalonId,
        employeeId: employee.id,
        dayOfWeek: _assignmentDate.weekday - 1,
        startTime: _startController.text,
        endTime: _endController.text,
      );

      if (!validation.canSave) {
        final message = validation.blockingIssues.join(' ');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message.isEmpty ? 'Einsatz ungültig' : message)),
        );
        return;
      }

      if (validation.warnings.isNotEmpty) {
        final proceed = await _confirmWarnings(validation.warnings);
        if (proceed != true) {
          return;
        }
      }

      await _service.setSpecificScheduleAssignment(
        employeeId: employee.id,
        salonId: assignmentSalonId,
        date: _assignmentDate,
        startTime: _startController.text,
        endTime: _endController.text,
      );

      final schedules = await _service.getEmployeeSchedules(employee.id);
      if (!mounted) return;

      setState(() {
        _selectedEmployeeSchedules = schedules;
      });

      final salonName = _salonNameForId(assignmentSalonId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tageseinsatz gespeichert: ${_fmtDate(_assignmentDate)} • $salonName',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tageseinsatz konnte nicht gespeichert werden: $error')),
      );
    }
  }

  Future<void> _decideRequest(WorkforceLeaveRequest request, String status) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;

    if (_requestActionLoading.contains(request.id)) {
      return;
    }

    setState(() {
      _requestActionLoading = {..._requestActionLoading, request.id};
    });

    try {
      await _service.decideLeaveRequest(
        requestId: request.id,
        status: status,
        approvedBy: userId,
      );

      await _load();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            status == 'approved'
                ? 'Antrag genehmigt'
                : 'Antrag abgelehnt',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Antrag konnte nicht bearbeitet werden: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _requestActionLoading = {..._requestActionLoading}..remove(request.id);
        });
      }
    }
  }

  Future<bool?> _confirmWarnings(List<String> warnings) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konflikthinweise'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: warnings
                  .map((warning) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text('• $warning'),
                      ))
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Abbrechen'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Trotzdem speichern'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editOpeningHour(String dayKey) async {
    final current = _openingHours[dayKey];
    if (current == null) {
      return;
    }

    bool closed = current.closed;
    final openController = TextEditingController(text: current.open);
    final closeController = TextEditingController(text: current.close);

    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Öffnungszeiten ${_dayLabelFromKey(dayKey)}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Geschlossen'),
                    value: closed,
                    onChanged: (value) {
                      setDialogState(() => closed = value);
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: openController,
                    decoration: const InputDecoration(
                      labelText: 'Öffnet (HH:mm)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: closeController,
                    decoration: const InputDecoration(
                      labelText: 'Schließt (HH:mm)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Abbrechen'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Speichern'),
                ),
              ],
            );
          },
        );
      },
    );

    if (shouldSave != true) {
      return;
    }

    try {
      await _service.updateSalonOpeningHour(
        salonId: widget.salonId,
        dayKey: dayKey,
        closed: closed,
        open: openController.text,
        close: closeController.text,
      );

      await _load();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Öffnungszeiten konnten nicht gespeichert werden: $error')),
      );
    }
  }

  Future<void> _addClosure() async {
    final now = DateTime.now();
    final start = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );
    if (start == null) return;

    final end = await showDatePicker(
      context: context,
      initialDate: start,
      firstDate: start,
      lastDate: DateTime(now.year + 2),
    );
    if (end == null) return;

    final reason = await _showReasonDialog();
    if (reason == null) return;

    try {
      await _service.addSalonClosure(
        salonId: widget.salonId,
        startDate: start,
        endDate: end,
        reason: reason.trim().isEmpty ? null : reason.trim(),
      );

      await _load();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Schließzeit konnte nicht gespeichert werden: $error')),
      );
    }
  }

  Future<void> _addHoliday() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );

    if (date == null) return;

    final name = await _showReasonDialog();
    if (name == null) return;

    final reason = name.trim().isEmpty
        ? 'Feiertag: Schließtag'
        : 'Feiertag: ${name.trim()}';

    try {
      await _service.addSalonClosure(
        salonId: widget.salonId,
        startDate: date,
        endDate: date,
        reason: reason,
      );

      await _load();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Feiertag konnte nicht gespeichert werden: $error')),
      );
    }
  }

  Future<void> _deleteClosure(String closureId) async {
    try {
      await _service.deleteSalonClosure(closureId);
      await _load();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Schließzeit konnte nicht gelöscht werden: $error')),
      );
    }
  }

  Future<String?> _showReasonDialog() async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Grund / Anlass'),
          content: TextField(
            controller: controller,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: 'z. B. Feiertag, Betriebsurlaub, Team-Event',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Abbrechen'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: const Text('Übernehmen'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_loadError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LucideIcons.alertCircle, color: Colors.redAccent),
              const SizedBox(height: 8),
              Text(
                'Fehler beim Laden des Dienstplan-Moduls',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _loadError!,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _load,
                child: const Text('Erneut laden'),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dienstplan & Abwesenheiten',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Genehmige Urlaube/Krank/Wunschfrei und verwalte Schichten zentral.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _kpiCard('Offene Anträge', '${_pendingRequests.length}', LucideIcons.clock),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _kpiCard('Urlaub genehmigt', '$_approvedVacationDays Tage', LucideIcons.palmtree),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _kpiCard('Krankheit', '$_sickDays Tage', LucideIcons.thermometer),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Urlaub offen: $_pendingVacationDays Tage',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 20),
          _buildEmployeeKpiOverview(),
          const SizedBox(height: 20),
          _buildPendingRequests(),
          const SizedBox(height: 20),
          _buildScheduleEditor(),
          const SizedBox(height: 20),
          _buildOpeningHoursSection(),
          const SizedBox(height: 20),
          _buildClosuresSection(),
        ],
      ),
    );
  }

  Widget _kpiCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingRequests() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Offene Abwesenheitsanträge',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 10),
            if (_pendingRequests.isEmpty)
              const Text('Keine offenen Anträge')
            else
              ..._pendingRequests.map((request) {
                final isUpdating = _requestActionLoading.contains(request.id);
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('${request.employeeName} • ${_labelForType(request.leaveType)}'),
                  subtitle: Text(
                    _requestSubtitle(request),
                  ),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      OutlinedButton(
                        onPressed: isUpdating ? null : () => _decideRequest(request, 'rejected'),
                        child: const Text('Ablehnen'),
                      ),
                      FilledButton(
                        onPressed: isUpdating ? null : () => _decideRequest(request, 'approved'),
                        child: isUpdating
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Genehmigen'),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleEditor() {
    final recurringSchedules = _selectedEmployeeSchedules
        .where((schedule) => schedule.isRecurring)
        .toList();

    final specificSchedules = _selectedEmployeeSchedules
        .where((schedule) => !schedule.isRecurring && schedule.specificDate != null)
        .toList()
      ..sort((a, b) =>
          (a.specificDate ?? DateTime(2100)).compareTo(b.specificDate ?? DateTime(2100)));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dienstplan zuweisen',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<WorkforceEmployee>(
              value: _selectedEmployee,
              items: _employees
                  .map(
                    (employee) => DropdownMenuItem(
                      value: employee,
                      child: Text(employee.name),
                    ),
                  )
                  .toList(),
              onChanged: _onSelectEmployee,
              decoration: const InputDecoration(
                labelText: 'Mitarbeiter',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<int>(
              value: _selectedDay,
              items: List.generate(
                7,
                (index) => DropdownMenuItem(
                  value: index,
                  child: Text(_dayName(index)),
                ),
              ),
              onChanged: (value) {
                if (value == null) return;
                setState(() => _selectedDay = value);
              },
              decoration: const InputDecoration(
                labelText: 'Wochentag',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _startController,
                    decoration: const InputDecoration(
                      labelText: 'Start (HH:mm)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _endController,
                    decoration: const InputDecoration(
                      labelText: 'Ende (HH:mm)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _saveRecurringSchedule,
              icon: const Icon(LucideIcons.save, size: 16),
              label: const Text('Speichern'),
            ),
            const SizedBox(height: 18),
            const Divider(),
            const SizedBox(height: 8),
            const Text(
              'Tageseinsatz in anderem Salon',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedAssignmentSalonId,
              items: _effectiveSalons
                  .map(
                    (salon) => DropdownMenuItem(
                      value: salon.id,
                      child: Text(salon.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedAssignmentSalonId = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Einsatz-Salon',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () async {
                final now = DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _assignmentDate,
                  firstDate: DateTime(now.year - 1),
                  lastDate: DateTime(now.year + 2),
                );
                if (picked == null || !mounted) return;
                setState(() => _assignmentDate = picked);
              },
              icon: const Icon(LucideIcons.calendar, size: 16),
              label: Text('Datum: ${_fmtDate(_assignmentDate)}'),
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: _saveSpecificSalonAssignment,
              icon: const Icon(LucideIcons.repeat2, size: 16),
              label: const Text('Tageseinsatz speichern'),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            const Text(
              'Aktuelle Schichten',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            if (_selectedEmployeeSchedules.isEmpty)
              const Text('Noch keine Schichten hinterlegt')
            else ...[
              if (recurringSchedules.isNotEmpty)
                ...recurringSchedules.map(
                  (schedule) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(LucideIcons.calendarDays, size: 16),
                    title: Text(_dayName(schedule.dayOfWeek)),
                    subtitle: Text(
                      '${schedule.startTime.substring(0, 5)} - ${schedule.endTime.substring(0, 5)} • ${_salonLabel(schedule)}',
                    ),
                  ),
                )
              else
                const Text('Keine wiederkehrenden Schichten'),
              const SizedBox(height: 8),
              const Text(
                'Tageseinsätze',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              if (specificSchedules.isEmpty)
                const Text('Keine Tageseinsätze geplant')
              else
                ...specificSchedules.map(
                  (schedule) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(LucideIcons.mapPin, size: 16),
                    title: Text(
                      schedule.specificDate == null
                          ? _dayName(schedule.dayOfWeek)
                          : _fmtDate(schedule.specificDate!),
                    ),
                    subtitle: Text(
                      '${schedule.startTime.substring(0, 5)} - ${schedule.endTime.substring(0, 5)} • ${_salonLabel(schedule)}',
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeKpiOverview() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Teamübersicht je Mitarbeiter',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 10),
            if (_employees.isEmpty)
              const Text('Keine Mitarbeiter vorhanden')
            else
              ..._employees.map((employee) {
                final kpi = _employeeLeaveKpis[employee.id];
                final pendingRequestsForEmployee = _pendingRequests
                    .where((request) => request.employeeId == employee.id)
                    .length;

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(employee.name),
                  subtitle: Text(
                    'Offen: $pendingRequestsForEmployee • Genehmigt: ${kpi?.approvedVacationDays ?? 0} • Krank: ${kpi?.sickDays ?? 0} • Resturlaub: ${kpi?.remainingVacation?.toString() ?? 'n/a'}',
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildOpeningHoursSection() {
    const order = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Öffnungszeiten (zentral für Planung)',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 10),
            ...order.map((key) {
              final hour = _openingHours[key];
              if (hour == null) {
                return const SizedBox.shrink();
              }

              final subtitle = hour.closed
                  ? 'Geschlossen'
                  : '${hour.open} - ${hour.close}';

              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(_dayLabelFromKey(key)),
                subtitle: Text(subtitle),
                trailing: IconButton(
                  onPressed: () => _editOpeningHour(key),
                  icon: const Icon(LucideIcons.pencil, size: 16),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildClosuresSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text(
                  'Feiertage & Sonderschließzeiten',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                OutlinedButton.icon(
                  onPressed: _addHoliday,
                  icon: const Icon(LucideIcons.partyPopper, size: 14),
                  label: const Text('Feiertag'),
                ),
                OutlinedButton.icon(
                  onPressed: _addClosure,
                  icon: const Icon(LucideIcons.plus, size: 14),
                  label: const Text('Zeitraum'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (_closures.isEmpty)
              const Text('Keine Schließzeiten hinterlegt')
            else
              ..._closures.map((closure) {
                final isHoliday = (closure.reason ?? '').trim().toLowerCase().startsWith('feiertag:');
                final labelReason = closure.reason?.trim();
                final subtitle = (labelReason == null || labelReason.isEmpty)
                    ? (isHoliday ? 'Feiertag' : 'Schließzeit')
                    : labelReason;

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(LucideIcons.calendarX, size: 16),
                  title: Text(
                    '${_fmtDate(closure.startDate)} - ${_fmtDate(closure.endDate)}',
                  ),
                  subtitle: Text(subtitle),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isHoliday)
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Feiertag',
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      IconButton(
                        onPressed: () => _deleteClosure(closure.id),
                        icon: const Icon(LucideIcons.trash2, size: 16),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  String _fmtDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  String _dayName(int day) {
    const names = [
      'Montag',
      'Dienstag',
      'Mittwoch',
      'Donnerstag',
      'Freitag',
      'Samstag',
      'Sonntag',
    ];
    if (day < 0 || day >= names.length) return 'Tag $day';
    return names[day];
  }

  String _labelForType(String type) {
    switch (type) {
      case 'vacation':
        return 'Urlaub';
      case 'sick':
        return 'Krank';
      case 'personal':
        return 'Wunschfrei';
      case 'training':
        return 'Fortbildung';
      default:
        return type;
    }
  }

  String _requestSubtitle(WorkforceLeaveRequest request) {
    final lines = <String>[
      '${_fmtDate(request.startDate)} - ${_fmtDate(request.endDate)} • ${request.dayCount} Tage',
    ];

    final reason = request.reason?.trim();
    if (reason != null && reason.isNotEmpty) {
      lines.add('Grund: $reason');
    }

    final createdAt = request.createdAt;
    if (createdAt != null) {
      lines.add('Eingereicht: ${_fmtDate(createdAt)}');
    }

    return lines.join('\n');
  }

  String _dayLabelFromKey(String dayKey) {
    switch (dayKey) {
      case 'monday':
        return 'Montag';
      case 'tuesday':
        return 'Dienstag';
      case 'wednesday':
        return 'Mittwoch';
      case 'thursday':
        return 'Donnerstag';
      case 'friday':
        return 'Freitag';
      case 'saturday':
        return 'Samstag';
      case 'sunday':
        return 'Sonntag';
      default:
        return dayKey;
    }
  }

  List<SalonInfo> get _effectiveSalons {
    if (widget.availableSalons.isNotEmpty) {
      return widget.availableSalons;
    }
    return [
      SalonInfo(id: widget.salonId, name: 'Aktueller Salon'),
    ];
  }

  String _salonNameForId(String salonId) {
    for (final salon in _effectiveSalons) {
      if (salon.id == salonId) {
        return salon.name;
      }
    }
    return 'Salon';
  }

  String _salonLabel(WorkforceSchedule schedule) {
    final id = schedule.salonId;
    if (id != null && id.isNotEmpty) {
      return _salonNameForId(id);
    }
    if (schedule.salonName != null && schedule.salonName!.trim().isNotEmpty) {
      return schedule.salonName!.trim();
    }
    return _salonNameForId(widget.salonId);
  }
}
