import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../services/salon_code_service.dart';
import '../../../services/activity_log_service.dart';
import '../../../models/activity_log_model.dart';

class SalonCodeManagerTab extends ConsumerStatefulWidget {
  final String salonId;

  const SalonCodeManagerTab({
    super.key,
    required this.salonId,
  });

  @override
  ConsumerState<SalonCodeManagerTab> createState() =>
      _SalonCodeManagerTabState();
}

class _SalonCodeManagerTabState extends ConsumerState<SalonCodeManagerTab> {
  late SalonCodeService _salonCodeService;
  late ActivityLogService _activityLogService;
  String? _currentCode;
  String _newCode = '';
  String _confirmCode = '';
  bool _isLoading = false;
  bool _showResetConfirmation = false;
  String? _copiedText;

  @override
  void initState() {
    super.initState();
    _salonCodeService = SalonCodeService(Supabase.instance.client);
    _activityLogService = ActivityLogService(Supabase.instance.client);
    _loadCurrentCode();
  }

  Future<void> _loadCurrentCode() async {
    setState(() => _isLoading = true);
    try {
      final code = await _salonCodeService.getCurrentSalonCode(widget.salonId);
      setState(() => _currentCode = code?.code);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _generateNewCode() async {
    if (_newCode.isEmpty || _newCode.length < 4) {
      _showErrorSnackBar('Code muss mindestens 4 Zeichen lang sein');
      return;
    }

    if (_newCode != _confirmCode) {
      _showErrorSnackBar('Codes stimmen nicht überein');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final result = await _salonCodeService.resetSalonCode(
        salonId: widget.salonId,
        newCode: _newCode.toUpperCase(),
      );

      if (mounted) {
        if (result['success']) {
          setState(() {
            _currentCode = result['code'];
            _newCode = '';
            _confirmCode = '';
            _showResetConfirmation = false;
          });
          _showSuccessSnackBar('Saloncode erfolgreich aktualisiert!');
          await _logCodeResetActivity(result['code'] as String?);
        } else {
          _showErrorSnackBar(result['message'] ?? 'Fehler beim Aktualisieren');
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _copyCodeToClipboard() {
    if (_currentCode != null) {
      Clipboard.setData(ClipboardData(text: _currentCode!));
      setState(() => _copiedText = 'Code kopiert!');
      _showSuccessSnackBar('Code in Zwischenablage kopiert');
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _copiedText = null);
        }
      });
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

  Future<void> _logCodeResetActivity(String? newCode) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    await _activityLogService.logActivity(
      salonId: widget.salonId,
      userId: user.id,
      userName: user.email ?? 'Admin',
      type: ActivityType.salonCodeReset,
      description: 'Saloncode zurueckgesetzt',
      metadata: {
        'new_code': newCode,
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

          // Current Code Section
          _buildCurrentCodeSection(),
          const SizedBox(height: 32),

          // Reset Code Section
          _buildResetCodeSection(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🔐 Saloncode-Verwaltung',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Verwaltung des Codes für Admin-Zugang zur Salon-Verwaltung',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentCodeSection() {
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
            'Aktueller Code',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_currentCode == null)
            Text(
              'Kein Code generiert',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.greenAccent.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _currentCode ?? '',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 48,
                    width: 48,
                    child: IconButton(
                      icon: Icon(
                        _copiedText != null
                            ? LucideIcons.check
                            : LucideIcons.copy,
                        color: _copiedText != null
                            ? Colors.greenAccent
                            : Colors.white70,
                      ),
                      onPressed: _copyCodeToClipboard,
                      tooltip: 'In Zwischenablage kopieren',
                    ),
                  ),
                ],
              ),
            ),
          if (_copiedText != null) ...[
            const SizedBox(height: 8),
            Text(
              _copiedText!,
              style: const TextStyle(
                color: Colors.greenAccent,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResetCodeSection() {
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
            children: [
              Icon(
                LucideIcons.alertCircle,
                color: Colors.orange,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                'Code zurücksetzen',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Generieren Sie einen neuen Code, um den alten zu ersetzen. '
            'Der alte Code wird ungültig.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 20),
          if (!_showResetConfirmation)
            ElevatedButton.icon(
              onPressed: () => setState(() => _showResetConfirmation = true),
              icon: const Icon(LucideIcons.rotateCcw),
              label: const Text('Code neu generieren'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.black,
              ),
            )
          else
            Column(
              children: [
                _buildCodeInput(
                  label: 'Neuer Code',
                  value: _newCode,
                  onChanged: (val) => setState(() => _newCode = val),
                  hintText: 'Mindestens 4 Zeichen',
                ),
                const SizedBox(height: 16),
                _buildCodeInput(
                  label: 'Code bestätigen',
                  value: _confirmCode,
                  onChanged: (val) => setState(() => _confirmCode = val),
                  hintText: 'Code wiederholen',
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _generateNewCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                            AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                            : const Text('Code aktualisieren'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(
                          () {
                            _showResetConfirmation = false;
                            _newCode = '';
                            _confirmCode = '';
                          },
                        ),
                        child: const Text('Abbrechen'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildCodeInput({
    required String label,
    required String value,
    required Function(String) onChanged,
    required String hintText,
  }) {
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
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
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
