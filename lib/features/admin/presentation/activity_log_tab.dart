import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/activity_log_model.dart';
import '../../../services/activity_log_service.dart';

class ActivityLogTab extends ConsumerStatefulWidget {
  final String salonId;

  const ActivityLogTab({
    super.key,
    required this.salonId,
  });

  @override
  ConsumerState<ActivityLogTab> createState() => _ActivityLogTabState();
}

class _ActivityLogTabState extends ConsumerState<ActivityLogTab> {
  late ActivityLogService _activityLogService;
  late TextEditingController _searchController;
  List<ActivityLog> _allLogs = [];
  List<ActivityLog> _activityLogs = [];
  bool _isLoading = false;
  int _selectedTypeFilter = -1; // -1 = all
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _activityLogService = ActivityLogService(Supabase.instance.client);
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
    _loadActivityLogs();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadActivityLogs() async {
    setState(() => _isLoading = true);
    try {
      final logs = await _activityLogService.getActivityLogs(
        salonId: widget.salonId,
        limit: 200,
        offset: 0,
      );
      _allLogs = logs;
      _applyFilter();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _applyFilter() {
    setState(() {
      _activityLogs = _filterLogsByType(_selectedTypeFilter);
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        _activityLogs = _activityLogs.where((log) {
          return log.userName.toLowerCase().contains(query) ||
              log.description.toLowerCase().contains(query) ||
              log.type.name.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  void _onSearchChanged() {
    _searchQuery = _searchController.text.trim();
    _applyFilter();
  }

  List<ActivityLog> _filterLogsByType(int filter) {
    if (filter == -1) return _allLogs;

    final types = <ActivityType>[];
    switch (filter) {
      case 1: // Login
        types.addAll([
          ActivityType.employeeLogin,
          ActivityType.adminLogin,
          ActivityType.customerLogin,
        ]);
        break;
      case 2: // Codes
        types.addAll([
          ActivityType.salonCodeGenerated,
          ActivityType.salonCodeReset,
          ActivityType.employeeCodeGenerated,
          ActivityType.employeeCodeReset,
        ]);
        break;
      case 3: // Modules
        types.addAll([
          ActivityType.moduleEnabled,
          ActivityType.moduleDisabled,
          ActivityType.permissionChanged,
        ]);
        break;
      case 4: // Employees
        types.addAll([
          ActivityType.employeeAdded,
          ActivityType.employeeRemoved,
        ]);
        break;
      default:
        return _allLogs;
    }

    return _allLogs.where((log) => types.contains(log.type)).toList();
  }

  String _getActivityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.salonCodeGenerated:
      case ActivityType.salonCodeReset:
        return '🔐';
      case ActivityType.employeeCodeGenerated:
      case ActivityType.employeeCodeReset:
        return '🔑';
      case ActivityType.moduleEnabled:
      case ActivityType.moduleDisabled:
        return '🧩';
      case ActivityType.permissionChanged:
        return '🛡️';
      case ActivityType.salonSettingsUpdated:
        return '⚙️';
      case ActivityType.employeeAdded:
      case ActivityType.employeeRemoved:
        return '👤';
      case ActivityType.employeeLogin:
      case ActivityType.adminLogin:
      case ActivityType.customerLogin:
        return '🔓';
      default:
        return '📝';
    }
  }

  Color _getActivityColor(ActivityType type) {
    switch (type) {
      case ActivityType.salonCodeGenerated:
      case ActivityType.employeeCodeGenerated:
      case ActivityType.moduleEnabled:
      case ActivityType.employeeAdded:
        return Colors.greenAccent;
      case ActivityType.salonCodeReset:
      case ActivityType.employeeCodeReset:
      case ActivityType.moduleDisabled:
      case ActivityType.employeeRemoved:
        return Colors.orangeAccent;
      case ActivityType.permissionChanged:
      case ActivityType.salonSettingsUpdated:
        return Colors.blueAccent;
      case ActivityType.adminLogin:
      case ActivityType.employeeLogin:
      case ActivityType.customerLogin:
        return Colors.purpleAccent;
      default:
        return Colors.white70;
    }
  }

  String _getActivityLabel(ActivityType type) {
    switch (type) {
      case ActivityType.salonCodeGenerated:
        return 'Saloncode generiert';
      case ActivityType.salonCodeReset:
        return 'Saloncode zurückgesetzt';
      case ActivityType.employeeCodeGenerated:
        return 'Mitarbeitercode generiert';
      case ActivityType.employeeCodeReset:
        return 'Mitarbeitercode zurückgesetzt';
      case ActivityType.moduleEnabled:
        return 'Modul aktiviert';
      case ActivityType.moduleDisabled:
        return 'Modul deaktiviert';
      case ActivityType.permissionChanged:
        return 'Berechtigungen geändert';
      case ActivityType.salonSettingsUpdated:
        return 'Salon-Einstellungen aktualisiert';
      case ActivityType.employeeAdded:
        return 'Mitarbeiter hinzugefügt';
      case ActivityType.employeeRemoved:
        return 'Mitarbeiter entfernt';
      case ActivityType.employeeLogin:
        return 'Mitarbeiter-Login';
      case ActivityType.adminLogin:
        return 'Admin-Login';
      case ActivityType.customerLogin:
        return 'Kunden-Login';
      default:
        return 'Aktivität';
    }
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

          // Filter Tabs
          _buildFilterTabs(),
          const SizedBox(height: 24),

          // Activity List
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _activityLogs.isEmpty
              ? _buildEmptyState()
              : _buildActivityList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '📋 Aktivitätsprotokoll',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            TextButton.icon(
              onPressed: _activityLogs.isEmpty ? null : _exportToClipboard,
              icon: const Icon(LucideIcons.download, size: 16),
              label: const Text('Export'),
              style: TextButton.styleFrom(foregroundColor: Colors.white70),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Audits und Protokoll aller Administrator- und Benutzeraktionen',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Suche nach Benutzer, Aktion oder Text',
            prefixIcon: const Icon(LucideIcons.search, size: 18),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.06),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
            ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  void _exportToClipboard() {
    final buffer = StringBuffer();
    buffer.writeln('timestamp,user,type,description');
    for (final log in _activityLogs) {
      buffer.writeln(
        '${_csvEscape(log.timestamp.toIso8601String())},'
        '${_csvEscape(log.userName)},'
        '${_csvEscape(log.type.name)},'
        '${_csvEscape(log.description)}',
      );
    }

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('CSV in Zwischenablage kopiert'),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _csvEscape(String value) {
    final escaped = value.replaceAll('"', '""');
    return '"$escaped"';
  }

  Widget _buildFilterTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip(
            label: 'Alle',
            isSelected: _selectedTypeFilter == -1,
            onTap: () {
              setState(() => _selectedTypeFilter = -1);
              _applyFilter();
            },
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Login',
            isSelected: _selectedTypeFilter == 1,
            onTap: () {
              setState(() => _selectedTypeFilter = 1);
              _applyFilter();
            },
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Codes',
            isSelected: _selectedTypeFilter == 2,
            onTap: () {
              setState(() => _selectedTypeFilter = 2);
              _applyFilter();
            },
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Module',
            isSelected: _selectedTypeFilter == 3,
            onTap: () {
              setState(() => _selectedTypeFilter = 3);
              _applyFilter();
            },
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Mitarbeiter',
            isSelected: _selectedTypeFilter == 4,
            onTap: () {
              setState(() => _selectedTypeFilter = 4);
              _applyFilter();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blueAccent.withValues(alpha: 0.3)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.blueAccent.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.1),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: isSelected ? Colors.blueAccent : Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(64),
        child: Column(
          children: [
            Icon(
              LucideIcons.zap,
              size: 48,
              color: Colors.white30,
            ),
            const SizedBox(height: 16),
            Text(
              'Keine Aktivitäten',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _activityLogs.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) =>
          _buildActivityCard(_activityLogs[index]),
    );
  }

  Widget _buildActivityCard(ActivityLog log) {
    final dateFormatter = DateFormat('dd.MM.yyyy HH:mm:ss', 'de_DE');
    final formattedDate = dateFormatter.format(log.timestamp);

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _getActivityIcon(log.type),
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getActivityLabel(log.type),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: _getActivityColor(log.type),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      log.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                log.userName,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                formattedDate,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
