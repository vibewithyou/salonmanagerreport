import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/leave_request_model.dart';
import '../../../providers/dashboard_providers.dart';
// TODO: Refactor to use EmployeeRepository instead of leave_request_service

class LeaveRequestWidget extends ConsumerStatefulWidget {
  const LeaveRequestWidget({super.key});

  @override
  ConsumerState<LeaveRequestWidget> createState() => _LeaveRequestWidgetState();
}

class _LeaveRequestWidgetState extends ConsumerState<LeaveRequestWidget> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  
  LeaveType _selectedType = LeaveType.vacation;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final leaveRequestsAsync = ref.watch(myLeaveRequestsProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Urlaubsanträge',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),

        // New Request Form
        _buildRequestForm(context),

        const SizedBox(height: 32),

        // My Requests List
        Text(
          'Meine Anträge',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        leaveRequestsAsync.when(
          data: (requests) => requests.isEmpty
              ? _buildEmptyState(context)
              : _buildRequestsList(context, requests),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Text('Fehler: $e'),
        ),
      ],
    );
  }

  Widget _buildRequestForm(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Neuer Antrag',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Leave Type Dropdown
              DropdownButtonFormField<LeaveType>(
                value: _selectedType,
                decoration: InputDecoration(
                  labelText: 'Art des Urlaubs',
                  prefixIcon: const Icon(LucideIcons.briefcase),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: LeaveType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(_getLeaveTypeText(type)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedType = value);
                  }
                },
              ),

              const SizedBox(height: 16),

              // Date Range Selection
              Row(
                children: [
                  Expanded(
                    child: _buildDateField(
                      context,
                      label: 'Von',
                      date: _startDate,
                      onTap: () => _selectDate(context, true),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDateField(
                      context,
                      label: 'Bis',
                      date: _endDate,
                      onTap: () => _selectDate(context, false),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Reason TextField
              TextFormField(
                controller: _reasonController,
                decoration: InputDecoration(
                  labelText: 'Begründung (optional)',
                  hintText: 'Grund für den Urlaubsantrag...',
                  prefixIcon: const Icon(LucideIcons.fileText),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
              ),

              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _startDate != null && _endDate != null
                      ? _submitRequest
                      : null,
                  icon: const Icon(LucideIcons.send),
                  label: const Text('Antrag einreichen'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(
    BuildContext context, {
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(LucideIcons.calendar),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          date != null
              ? DateFormat('d. MMM yyyy', 'de').format(date)
              : 'Datum wählen',
          style: TextStyle(
            color: date != null ? null : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestsList(BuildContext context, List<LeaveRequest> requests) {
    return Column(
      children: requests.map((request) {
        return _buildRequestCard(context, request);
      }).toList(),
    );
  }

  Widget _buildRequestCard(BuildContext context, LeaveRequest request) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(request.status);
    final statusText = _getStatusText(request.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getLeaveTypeText(request.type),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(LucideIcons.calendar,
                    size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  '${DateFormat('d. MMM', 'de').format(request.startDate)} - '
                  '${DateFormat('d. MMM yyyy', 'de').format(request.endDate)}',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            if (request.reason.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(LucideIcons.messageSquare,
                      size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      request.reason,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            if (request.status == LeaveStatus.pending) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      // TODO: Cancel request
                    },
                    icon: const Icon(LucideIcons.x, size: 16),
                    label: const Text('Zurückziehen'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.error,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              LucideIcons.palmtree,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Keine Urlaubsanträge vorhanden',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          // Reset end date if it's before new start date
          if (_endDate != null && _endDate!.isBefore(picked)) {
            _endDate = null;
          }
        } else {
          // Only allow end date if start date is set and end is after start
          if (_startDate != null && picked.isAfter(_startDate!)) {
            _endDate = picked;
          }
        }
      });
    }
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate() ||
        _startDate == null ||
        _endDate == null) {
      return;
    }

    try {
      final service = ref.read(leaveRequestServiceProvider);
      await service.submitLeaveRequest(
        type: _selectedType,
        startDate: _startDate!,
        endDate: _endDate!,
        reason: _reasonController.text.isNotEmpty
            ? _reasonController.text
            : null,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Urlaubsantrag erfolgreich eingereicht'),
            backgroundColor: AppColors.success,
          ),
        );

        // Reset form
        setState(() {
          _startDate = null;
          _endDate = null;
          _reasonController.clear();
          _selectedType = LeaveType.vacation;
        });

        // Refresh list
        ref.invalidate(myLeaveRequestsProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  String _getLeaveTypeText(LeaveType type) {
    switch (type) {
      case LeaveType.vacation:
        return 'Urlaub';
      case LeaveType.sick:
        return 'Krankmeldung';
      case LeaveType.personal:
        return 'Persönlicher Grund';
      case LeaveType.other:
        return 'Sonstiges';
    }
  }

  Color _getStatusColor(LeaveStatus status) {
    switch (status) {
      case LeaveStatus.pending:
        return AppColors.warning;
      case LeaveStatus.approved:
        return AppColors.success;
      case LeaveStatus.rejected:
        return AppColors.error;
    }
  }

  String _getStatusText(LeaveStatus status) {
    switch (status) {
      case LeaveStatus.pending:
        return 'Ausstehend';
      case LeaveStatus.approved:
        return 'Genehmigt';
      case LeaveStatus.rejected:
        return 'Abgelehnt';
    }
  }
}
