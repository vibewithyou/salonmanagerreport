import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/workforce_service.dart';

class EmployeeLeaveRequestsLiveTab extends StatefulWidget {
  const EmployeeLeaveRequestsLiveTab({super.key});

  @override
  State<EmployeeLeaveRequestsLiveTab> createState() =>
      _EmployeeLeaveRequestsLiveTabState();
}

class _EmployeeLeaveRequestsLiveTabState extends State<EmployeeLeaveRequestsLiveTab> {
  late final WorkforceService _service;

  bool _isLoading = true;
  bool _isSubmitting = false;
  WorkforceEmployee? _employee;
  List<WorkforceLeaveRequest> _requests = [];
  int _approvedVacationDays = 0;
  int _pendingVacationDays = 0;
  int _sickDays = 0;
  int? _vacationAllowance;
  String _leaveType = 'vacation';
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _service = WorkforceService(Supabase.instance.client);
    _load();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      return;
    }

    final employee = await _service.getCurrentEmployeeForUser(userId: user.id);
    if (employee == null) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      return;
    }

    final requests = await _service.getLeaveRequests(
      salonId: employee.salonId,
      employeeId: employee.id,
    );
    final summary = await _service.getEmployeeLeaveSummary(
      employeeId: employee.id,
      year: DateTime.now().year,
    );
    final allowance = await _service.getEmployeeVacationAllowance(employee.id);

    if (!mounted) return;
    setState(() {
      _employee = employee;
      _requests = requests;
      _approvedVacationDays = summary['approvedVacationDays'] ?? 0;
      _pendingVacationDays = summary['pendingVacationDays'] ?? 0;
      _sickDays = summary['sickDays'] ?? 0;
      _vacationAllowance = allowance;
      _isLoading = false;
    });
  }

  Future<void> _submit() async {
    final employee = _employee;
    if (_isSubmitting || employee == null) {
      return;
    }

    final validationError = _validateSubmission();
    if (validationError != null) {
      _showError(validationError);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await _service.submitLeaveRequest(
        salonId: employee.salonId,
        employeeId: employee.id,
        leaveType: _leaveType,
        startDate: _startDate!,
        endDate: _endDate!,
        reason: _reasonController.text.trim().isEmpty
            ? null
            : _reasonController.text.trim(),
      );

      _reasonController.clear();
      setState(() {
        _startDate = null;
        _endDate = null;
        _leaveType = 'vacation';
      });

      await _load();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Antrag eingereicht')),
      );
    } on ArgumentError catch (error) {
      _showError(error.message?.toString() ?? 'Ungültige Eingabe');
    } catch (_) {
      _showError('Antrag konnte nicht eingereicht werden. Bitte erneut versuchen.');
    } finally {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
    }
  }

  String? _validateSubmission() {
    final employee = _employee;
    final startDate = _startDate;
    final endDate = _endDate;

    if (employee == null) {
      return 'Kein Mitarbeiterprofil gefunden.';
    }
    if (startDate == null || endDate == null) {
      return 'Bitte Start- und Enddatum auswählen.';
    }

    final normalizedStart = _toDateOnly(startDate);
    final normalizedEnd = _toDateOnly(endDate);
    if (normalizedEnd.isBefore(normalizedStart)) {
      return 'Das Enddatum darf nicht vor dem Startdatum liegen.';
    }

    final overlaps = _requests.where((request) {
      if (request.status != 'approved' && request.status != 'pending') {
        return false;
      }
      return _rangesOverlap(
        normalizedStart,
        normalizedEnd,
        _toDateOnly(request.startDate),
        _toDateOnly(request.endDate),
      );
    }).toList();

    if (overlaps.isNotEmpty) {
      final existing = overlaps.first;
      return 'Überschneidung mit vorhandenem ${_statusLabel(existing.status).toLowerCase()} Antrag (${_fmtDate(existing.startDate)} - ${_fmtDate(existing.endDate)}).';
    }

    if (_leaveType == 'vacation' && _vacationAllowance != null) {
      final requestedDays = normalizedEnd.difference(normalizedStart).inDays + 1;
      final projectedTotal = _approvedVacationDays + _pendingVacationDays + requestedDays;
      if (projectedTotal > _vacationAllowance!) {
        final remaining = (_vacationAllowance! - (_approvedVacationDays + _pendingVacationDays)).clamp(0, 999);
        return 'Nicht genügend Resturlaub. Verfügbar: $remaining Tage, beantragt: $requestedDays Tage.';
      }
    }

    return null;
  }

  DateTime _toDateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

  bool _rangesOverlap(
    DateTime aStart,
    DateTime aEnd,
    DateTime bStart,
    DateTime bEnd,
  ) {
    return !aEnd.isBefore(bStart) && !bEnd.isBefore(aStart);
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red[700],
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_employee == null) {
      return const Center(
        child: Text(
          'Kein Mitarbeiterprofil gefunden',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    final approved = _requests.where((request) => request.status == 'approved').length;
    final pending = _requests.where((request) => request.status == 'pending').length;
    final rejected = _requests.where((request) => request.status == 'rejected').length;
    final remainingVacation = _vacationAllowance == null
      ? null
      : (_vacationAllowance! - _approvedVacationDays).clamp(0, 999);

    return Container(
      color: Colors.black,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Meine Abwesenheiten',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _statCard('Offen', '$pending', Colors.orange)),
                const SizedBox(width: 10),
                Expanded(child: _statCard('Genehmigt', '$approved', Colors.green)),
                const SizedBox(width: 10),
                Expanded(child: _statCard('Abgelehnt', '$rejected', Colors.red)),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                SizedBox(
                  width: 160,
                  child: _statCard('Urlaub genommen', '$_approvedVacationDays Tage', Colors.lightGreen),
                ),
                SizedBox(
                  width: 160,
                  child: _statCard('Urlaub beantragt', '$_pendingVacationDays Tage', Colors.amber),
                ),
                SizedBox(
                  width: 160,
                  child: _statCard('Kranktage', '$_sickDays Tage', Colors.deepOrange),
                ),
                SizedBox(
                  width: 160,
                  child: _statCard(
                    'Resturlaub',
                    remainingVacation == null ? 'n/a' : '$remainingVacation Tage',
                    Colors.cyan,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildForm(),
            const SizedBox(height: 16),
            const Text(
              'Verlauf',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (_requests.isEmpty)
              const Text('Keine Anträge vorhanden', style: TextStyle(color: Colors.white54))
            else
              ..._requests.map(_requestTile),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Card(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Neuen Antrag einreichen',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _leaveType,
              dropdownColor: Colors.grey[850],
              style: const TextStyle(color: Colors.white),
              items: const [
                DropdownMenuItem(value: 'vacation', child: Text('Urlaub')),
                DropdownMenuItem(value: 'sick', child: Text('Krank')),
                DropdownMenuItem(value: 'personal', child: Text('Wunschfrei')),
                DropdownMenuItem(value: 'training', child: Text('Fortbildung')),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() => _leaveType = value);
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now().subtract(const Duration(days: 1)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setState(() => _startDate = picked);
                      }
                    },
                    icon: const Icon(LucideIcons.calendar, size: 16),
                    label: Text(_startDate == null ? 'Start' : _fmtDate(_startDate!)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _startDate ?? DateTime.now(),
                        firstDate: _startDate ?? DateTime.now().subtract(const Duration(days: 1)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setState(() => _endDate = picked);
                      }
                    },
                    icon: const Icon(LucideIcons.calendarCheck, size: 16),
                    label: Text(_endDate == null ? 'Ende' : _fmtDate(_endDate!)),
                  ),
                ),
              ],
            ),
            if (_startDate != null && _endDate != null) ...[
              const SizedBox(height: 8),
              Text(
                'Dauer: ${_toDateOnly(_endDate!).difference(_toDateOnly(_startDate!)).inDays + 1} Tag(e)',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
            const SizedBox(height: 10),
            TextField(
              controller: _reasonController,
              maxLines: 2,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Grund (optional)',
                hintStyle: TextStyle(color: Colors.white54),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isSubmitting ? null : _submit,
                icon: const Icon(LucideIcons.send, size: 16),
                label: Text(_isSubmitting ? 'Wird gesendet...' : 'Einreichen'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _requestTile(WorkforceLeaveRequest request) {
    final color = switch (request.status) {
      'approved' => Colors.green,
      'rejected' => Colors.red,
      _ => Colors.orange,
    };

    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(
          '${_typeLabel(request.leaveType)} • ${request.dayCount} Tage',
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          _requestDetails(request),
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _statusLabel(request.status),
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  String _requestDetails(WorkforceLeaveRequest request) {
    final dateRange = '${_fmtDate(request.startDate)} - ${_fmtDate(request.endDate)}';
    final reason = request.reason?.trim();
    final created = request.createdAt;
    final updated = request.updatedAt;

    final lines = <String>[dateRange];
    if (reason != null && reason.isNotEmpty) {
      lines.add('Grund: $reason');
    }
    if (created != null) {
      lines.add('Eingereicht: ${_fmtDate(created)}');
    }
    if (updated != null && created != null) {
      final createdDate = _toDateOnly(created);
      final updatedDate = _toDateOnly(updated);
      if (updatedDate.isAfter(createdDate) && request.status != 'pending') {
        lines.add('Entschieden: ${_fmtDate(updated)}');
      }
    }

    return lines.join('\n');
  }

  Widget _statCard(String label, String value, Color color) {
    return Card(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  String _fmtDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';

  String _typeLabel(String type) {
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

  String _statusLabel(String status) {
    switch (status) {
      case 'approved':
        return 'Genehmigt';
      case 'rejected':
        return 'Abgelehnt';
      default:
        return 'Offen';
    }
  }
}

class EmployeeScheduleLiveTab extends StatefulWidget {
  const EmployeeScheduleLiveTab({super.key});

  @override
  State<EmployeeScheduleLiveTab> createState() => _EmployeeScheduleLiveTabState();
}

class _EmployeeScheduleLiveTabState extends State<EmployeeScheduleLiveTab> {
  late final WorkforceService _service;
  bool _isLoading = true;
  WorkforceEmployee? _employee;
  List<WorkforceSchedule> _schedules = [];
  List<WorkforceLeaveRequest> _approvedAbsences = [];

  @override
  void initState() {
    super.initState();
    _service = WorkforceService(Supabase.instance.client);
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      return;
    }

    final employee = await _service.getCurrentEmployeeForUser(userId: user.id);
    if (employee == null) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      return;
    }

    final schedules = await _service.getEmployeeSchedules(employee.id);
    final leave = await _service.getLeaveRequests(
      salonId: employee.salonId,
      employeeId: employee.id,
      status: 'approved',
    );

    if (!mounted) return;
    setState(() {
      _employee = employee;
      _schedules = schedules;
      _approvedAbsences = leave;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_employee == null) {
      return const Center(
        child: Text(
          'Kein Dienstplan verfügbar',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    final recurring = _schedules.where((schedule) => schedule.isRecurring).toList();
    final specificAssignments = _schedules
      .where((schedule) => !schedule.isRecurring && schedule.specificDate != null)
      .toList()
      ..sort((a, b) =>
        (a.specificDate ?? DateTime(2100)).compareTo(b.specificDate ?? DateTime(2100)));
    final nextAbsence = _nextUpcomingAbsence();

    return Container(
      color: Colors.black,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mein Dienstplan',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              color: Colors.grey[900],
              child: ListTile(
                leading: const Icon(LucideIcons.calendarRange, color: Colors.orangeAccent),
                title: const Text(
                  'Nächste genehmigte Abwesenheit',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  nextAbsence == null
                      ? 'Keine zukünftige Abwesenheit geplant'
                      : '${_typeLabel(nextAbsence.leaveType)} • ${_fmtDate(nextAbsence.startDate)} - ${_fmtDate(nextAbsence.endDate)}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: Colors.grey[900],
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Wiederkehrende Schichten',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    if (recurring.isEmpty)
                      const Text('Noch keine Schichten geplant', style: TextStyle(color: Colors.white54))
                    else
                      ...recurring.map(
                        (schedule) => ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(LucideIcons.clock3, color: Colors.amber),
                          title: Text(
                            _dayName(schedule.dayOfWeek),
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            _scheduleSubtitle(schedule),
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Card(
              color: Colors.grey[900],
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tageseinsätze / Salonwechsel',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    if (specificAssignments.isEmpty)
                      const Text(
                        'Keine geplanten Tageseinsätze',
                        style: TextStyle(color: Colors.white54),
                      )
                    else
                      ...specificAssignments.map(
                        (schedule) => ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(LucideIcons.mapPin, color: Colors.lightBlueAccent),
                          title: Text(
                            schedule.specificDate == null
                                ? _dayName(schedule.dayOfWeek)
                                : _fmtDate(schedule.specificDate!),
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            _specificAssignmentSubtitle(schedule),
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Card(
              color: Colors.grey[900],
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Genehmigte Abwesenheiten (blockiert im Booking)',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    if (_approvedAbsences.isEmpty)
                      const Text('Keine genehmigten Abwesenheiten', style: TextStyle(color: Colors.white54))
                    else
                      ..._approvedAbsences.map(
                        (request) => ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(LucideIcons.ban, color: Colors.redAccent),
                          title: Text(
                            _typeLabel(request.leaveType),
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            '${_fmtDate(request.startDate)} - ${_fmtDate(request.endDate)}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
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

  String _fmtDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';

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

  String _typeLabel(String type) {
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

  WorkforceLeaveRequest? _nextUpcomingAbsence() {
    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);
    final upcoming = _approvedAbsences
        .where((request) {
          final end = DateTime(
            request.endDate.year,
            request.endDate.month,
            request.endDate.day,
          );
          return !end.isBefore(normalizedToday);
        })
        .toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    if (upcoming.isEmpty) {
      return null;
    }
    return upcoming.first;
  }

  String _scheduleSubtitle(WorkforceSchedule schedule) {
    final base = '${schedule.startTime.substring(0, 5)} - ${schedule.endTime.substring(0, 5)}';
    final withSalon = '$base • ${_salonLabel(schedule)}';
    if (_hasUpcomingAbsenceForDay(schedule.dayOfWeek)) {
      return '$withSalon\nAbwesenheit in den nächsten 30 Tagen';
    }
    return withSalon;
  }

  String _specificAssignmentSubtitle(WorkforceSchedule schedule) {
    final base = '${schedule.startTime.substring(0, 5)} - ${schedule.endTime.substring(0, 5)}';
    return '$base • ${_salonLabel(schedule)}';
  }

  String _salonLabel(WorkforceSchedule schedule) {
    final salonName = schedule.salonName?.trim();
    if (salonName != null && salonName.isNotEmpty) {
      return salonName;
    }

    final salonId = schedule.salonId?.trim();
    if (salonId != null && salonId.isNotEmpty) {
      return 'Salon-ID: $salonId';
    }

    final employeeSalon = _employee?.salonId;
    if (employeeSalon != null && employeeSalon.isNotEmpty) {
      return 'Stammsalon';
    }

    return 'Salon';
  }

  bool _hasUpcomingAbsenceForDay(int dayOfWeek) {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final lookAhead = start.add(const Duration(days: 30));

    for (final request in _approvedAbsences) {
      var cursor = DateTime(
        request.startDate.year,
        request.startDate.month,
        request.startDate.day,
      );
      final end = DateTime(
        request.endDate.year,
        request.endDate.month,
        request.endDate.day,
      );

      if (end.isBefore(start) || cursor.isAfter(lookAhead)) {
        continue;
      }

      if (cursor.isBefore(start)) {
        cursor = start;
      }

      final max = end.isBefore(lookAhead) ? end : lookAhead;
      while (!cursor.isAfter(max)) {
        if (cursor.weekday - 1 == dayOfWeek) {
          return true;
        }
        cursor = cursor.add(const Duration(days: 1));
      }
    }

    return false;
  }
}
