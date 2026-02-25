import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/activity_log_model.dart';
import '../../../models/employee_model.dart';
import '../../../services/activity_log_service.dart';
import '../../../services/dashboard_service.dart';
import '../../../services/salon_code_service.dart';

class EmployeeCodeGeneratorTab extends ConsumerStatefulWidget {
  final String salonId;

  const EmployeeCodeGeneratorTab({
    super.key,
    required this.salonId,
  });

  @override
  ConsumerState<EmployeeCodeGeneratorTab> createState() =>
      _EmployeeCodeGeneratorTabState();
}

class _EmployeeCodeGeneratorTabState
    extends ConsumerState<EmployeeCodeGeneratorTab> {
  late DashboardService _dashboardService;
  late SalonCodeService _salonCodeService;
  late ActivityLogService _activityLogService;
  List<Employee> _employees = [];
  Map<String, String> _employeeCodes = {};
  Map<String, bool> _generatingCodes = {};
  bool _isLoading = false;
  String? _copiedEmployeeId;

  @override
  void initState() {
    super.initState();
    final client = Supabase.instance.client;
    _dashboardService = DashboardService(client);
    _salonCodeService = SalonCodeService(client);
    _activityLogService = ActivityLogService(client);
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    setState(() => _isLoading = true);
    try {
      final employees = await _dashboardService.getEmployees(widget.salonId);
      final codes = await _salonCodeService.getEmployeeTimeCodes(widget.salonId);
      final codeMap = {
        for (final item in codes) item.employeeId: item.code,
      };

      if (mounted) {
        setState(() {
          _employees = employees;
          _employeeCodes = codeMap;
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _generateCode(String employeeId, String employeeName) async {
    setState(() => _generatingCodes[employeeId] = true);
    try {
      final result = await _salonCodeService.generateEmployeeTimeCode(employeeId);
      if (result['success'] == true && result['code'] != null) {
        setState(() => _employeeCodes[employeeId] = result['code'] as String);
        _showSuccessSnackBar('Code fuer $employeeName generiert');
        await _logEmployeeCodeActivity(employeeId, employeeName);
      } else {
        _showErrorSnackBar(result['message'] ?? 'Code konnte nicht generiert werden');
      }
    } finally {
      setState(() => _generatingCodes[employeeId] = false);
    }
  }

  void _copyCodeToClipboard(String code, String employeeId) {
    Clipboard.setData(ClipboardData(text: code));
    setState(() => _copiedEmployeeId = employeeId);
    _showSuccessSnackBar('Code kopiert');
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _copiedEmployeeId = null);
      }
    });
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

  Future<void> _logEmployeeCodeActivity(
    String employeeId,
    String employeeName,
  ) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    await _activityLogService.logActivity(
      salonId: widget.salonId,
      userId: user.id,
      userName: user.email ?? 'Admin',
      type: ActivityType.employeeCodeGenerated,
      description: 'Mitarbeitercode generiert',
      metadata: {
        'employee_id': employeeId,
        'employee_name': employeeName,
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

          // Employees List
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _employees.isEmpty
              ? _buildEmptyState()
              : _buildEmployeesList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🔑 Mitarbeiter-Codes',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Generieren Sie eindeutige Codes für Ihre Mitarbeiter zur Zeiterfassung',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              LucideIcons.users,
              size: 48,
              color: Colors.white30,
            ),
            const SizedBox(height: 16),
            Text(
              'Keine Mitarbeiter gefunden',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeesList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _employees.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) =>
          _buildEmployeeCard(_employees[index]),
    );
  }

  Widget _buildEmployeeCard(Employee employee) {
    final hasCode = _employeeCodes.containsKey(employee.id);
    final code = _employeeCodes[employee.id];
    final isGenerating = _generatingCodes[employee.id] ?? false;
    final isCopied = _copiedEmployeeId == employee.id;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    employee.firstName.isNotEmpty
                        ? employee.firstName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: AppColors.gold,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${employee.firstName} ${employee.lastName}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      employee.email,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasCode)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '✓ Code aktiv',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          if (hasCode) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.greenAccent.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      code ?? '',
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () =>
                        _copyCodeToClipboard(code ?? '', employee.id),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        isCopied
                            ? LucideIcons.check
                            : LucideIcons.copy,
                        color: isCopied
                            ? Colors.greenAccent
                            : Colors.white70,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isGenerating
                  ? null
                  : () => _generateCode(
                    employee.id,
                    '${employee.firstName} ${employee.lastName}',
                  ),
              icon: isGenerating
                  ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                      AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                  : const Icon(LucideIcons.rotateCcw),
              label: Text(
                hasCode ? 'Code neu generieren' : 'Code generieren',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
