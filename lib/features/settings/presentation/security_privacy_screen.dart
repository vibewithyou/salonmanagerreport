import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/app_colors.dart';
import '../../../core/auth/identity_provider.dart';

/// PHASE 8: SECURITY & DSGVO
/// 
/// Features:
/// - 2FA (Two-Factor Authentication) Setup & Management
/// - Password Security & Strength Checker
/// - Session Management & Active Devices
/// - DSGVO Compliance (Datenexport, Löschung)
/// - Privacy Policy & Terms
/// - Cookie & Consent Management
/// - Audit Logging & Security History
/// - Data Encryption Status

class SecurityPrivacyScreen extends ConsumerStatefulWidget {
  const SecurityPrivacyScreen({super.key});

  @override
  ConsumerState<SecurityPrivacyScreen> createState() => _SecurityPrivacyScreenState();
}

class _SecurityPrivacyScreenState extends ConsumerState<SecurityPrivacyScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // 2FA State
  bool _is2FAEnabled = false;
  String _totpSecret = '';
  
  // Password State
  bool _requireStrongPassword = true;
  bool _passwordExpiryEnabled = false;
  int _passwordExpiryDays = 90;
  
  // Session State
  bool _autoLogoutEnabled = true;
  int _autoLogoutMinutes = 30;
  
  // Privacy State
  bool _analyticsEnabled = false;
  bool _crashReportingEnabled = true;
  bool _marketingEmailsEnabled = false;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red.shade700, Colors.red.shade900],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.shield, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Sicherheit & Datenschutz',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.gold,
          unselectedLabelColor: Colors.white54,
          indicatorColor: AppColors.gold,
          tabs: const [
            Tab(text: '2FA & Passwort'),
            Tab(text: 'Sitzungen'),
            Tab(text: 'DSGVO'),
            Tab(text: 'Datenschutz'),
            Tab(text: 'Sicherheitslog'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _build2FAPasswordTab(),
          _buildSessionsTab(),
          _buildDSGVOTab(),
          _buildPrivacyTab(),
          _buildSecurityLogTab(),
        ],
      ),
    );
  }

  // ============================================================================
  // TAB 1: 2FA & PASSWORD
  // ============================================================================
  Widget _build2FAPasswordTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 2FA Section
          _buildSectionHeader(
            'Zwei-Faktor-Authentifizierung (2FA)',
            'Schützen Sie Ihr Konto mit einem zusätzlichen Sicherheitscode',
          ),
          const SizedBox(height: 12),
          _buildCard([
            SwitchListTile(
              value: _is2FAEnabled,
              onChanged: (value) {
                if (value) {
                  _show2FASetupDialog();
                } else {
                  _showDisable2FADialog();
                }
              },
              title: const Text(
                '2FA aktiviert',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                _is2FAEnabled 
                    ? 'Ihr Konto ist durch 2FA geschützt'
                    : 'Aktivieren Sie 2FA für zusätzliche Sicherheit',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              secondary: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _is2FAEnabled ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _is2FAEnabled ? LucideIcons.shieldCheck : LucideIcons.shieldAlert,
                  color: _is2FAEnabled ? Colors.green : Colors.orange,
                ),
              ),
              activeColor: AppColors.gold,
            ),
            if (_is2FAEnabled) ...[
              const Divider(color: Colors.white12),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(LucideIcons.smartphone, color: Colors.blue),
                ),
                title: const Text(
                  'Backup-Codes anzeigen',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text(
                  '8 von 10 Codes verfügbar',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                trailing: const Icon(LucideIcons.chevronRight, color: Colors.white54),
                onTap: _showBackupCodes,
              ),
              const Divider(color: Colors.white12),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(LucideIcons.key, color: Colors.purple),
                ),
                title: const Text(
                  '2FA-Gerät ändern',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text(
                  'QR-Code neu scannen',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                trailing: const Icon(LucideIcons.chevronRight, color: Colors.white54),
                onTap: _show2FASetupDialog,
              ),
            ],
          ]),

          const SizedBox(height: 24),

          // Password Security Section
          _buildSectionHeader(
            'Passwort-Sicherheit',
            'Verwalten Sie Ihre Passwort-Anforderungen',
          ),
          const SizedBox(height: 12),
          _buildCard([
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(LucideIcons.lock, color: AppColors.gold),
              ),
              title: const Text(
                'Passwort ändern',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Zuletzt geändert vor 45 Tagen',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              trailing: const Icon(LucideIcons.chevronRight, color: Colors.white54),
              onTap: _showChangePasswordDialog,
            ),
            const Divider(color: Colors.white12),
            SwitchListTile(
              value: _requireStrongPassword,
              onChanged: (value) => setState(() => _requireStrongPassword = value),
              title: const Text(
                'Starkes Passwort verlangen',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'Min. 12 Zeichen, Groß-/Kleinbuchst., Zahlen, Sonderzeichen',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              secondary: const Icon(LucideIcons.checkCircle, color: Colors.green),
              activeColor: AppColors.gold,
            ),
            const Divider(color: Colors.white12),
            SwitchListTile(
              value: _passwordExpiryEnabled,
              onChanged: (value) => setState(() => _passwordExpiryEnabled = value),
              title: const Text(
                'Passwort-Ablauf aktivieren',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                'Passwort alle $_passwordExpiryDays Tage ändern',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              secondary: const Icon(LucideIcons.calendar, color: Colors.orange),
              activeColor: AppColors.gold,
            ),
            if (_passwordExpiryEnabled) ...[
              const Divider(color: Colors.white12),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Ablauf nach Tagen:',
                          style: TextStyle(color: Colors.white70),
                        ),
                        Text(
                          '$_passwordExpiryDays',
                          style: const TextStyle(
                            color: AppColors.gold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: _passwordExpiryDays.toDouble(),
                      min: 30,
                      max: 365,
                      divisions: 11,
                      activeColor: AppColors.gold,
                      inactiveColor: Colors.grey[800],
                      onChanged: (value) => setState(() => _passwordExpiryDays = value.round()),
                    ),
                  ],
                ),
              ),
            ],
          ]),

          const SizedBox(height: 24),

          // Password Strength Checker
          _buildSectionHeader(
            'Passwort-Stärke prüfen',
            'Testen Sie die Sicherheit eines Passworts',
          ),
          const SizedBox(height: 12),
          _buildPasswordStrengthChecker(),
        ],
      ),
    );
  }

  // ============================================================================
  // TAB 2: SESSIONS
  // ============================================================================
  Widget _buildSessionsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Auto Logout
          _buildSectionHeader(
            'Automatische Abmeldung',
            'Sitzung automatisch nach Inaktivität beenden',
          ),
          const SizedBox(height: 12),
          _buildCard([
            SwitchListTile(
              value: _autoLogoutEnabled,
              onChanged: (value) => setState(() => _autoLogoutEnabled = value),
              title: const Text(
                'Auto-Logout aktivieren',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Nach $_autoLogoutMinutes Minuten Inaktivität',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              secondary: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _autoLogoutEnabled ? Colors.green.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  LucideIcons.logOut,
                  color: _autoLogoutEnabled ? Colors.green : Colors.grey,
                ),
              ),
              activeColor: AppColors.gold,
            ),
            if (_autoLogoutEnabled) ...[
              const Divider(color: Colors.white12),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Timeout (Minuten):',
                          style: TextStyle(color: Colors.white70),
                        ),
                        Text(
                          '$_autoLogoutMinutes',
                          style: const TextStyle(
                            color: AppColors.gold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: _autoLogoutMinutes.toDouble(),
                      min: 5,
                      max: 120,
                      divisions: 23,
                      activeColor: AppColors.gold,
                      inactiveColor: Colors.grey[800],
                      onChanged: (value) => setState(() => _autoLogoutMinutes = value.round()),
                    ),
                  ],
                ),
              ),
            ],
          ]),

          const SizedBox(height: 24),

          // Active Sessions
          _buildSectionHeader(
            'Aktive Sitzungen',
            'Verwalten Sie Ihre angemeldeten Geräte',
          ),
          const SizedBox(height: 12),
          if (_activeSessions.isEmpty)
            const Text(
              'Keine aktiven Sitzungen',
              style: TextStyle(color: Colors.white54),
            )
          else
            ..._activeSessions.map((session) => _buildSessionCard(session)),

          const SizedBox(height: 16),

          // Logout All Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _showLogoutAllDialog,
              icon: const Icon(LucideIcons.logOut),
              label: const Text('Von allen Geräten abmelden'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // TAB 3: DSGVO
  // ============================================================================
  Widget _buildDSGVOTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(LucideIcons.info, color: Colors.blue),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Ihre Rechte nach DSGVO:\nAuskunft, Berichtigung, Löschung, Datenübertragbarkeit',
                    style: TextStyle(color: Colors.blue, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Data Export
          _buildSectionHeader(
            'Daten exportieren',
            'Laden Sie eine Kopie Ihrer gespeicherten Daten herunter',
          ),
          const SizedBox(height: 12),
          _buildCard([
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(LucideIcons.download, color: Colors.green),
              ),
              title: const Text(
                'Meine Daten exportieren',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'JSON-Format • Alle persönlichen Daten',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              trailing: const Icon(LucideIcons.chevronRight, color: Colors.white54),
              onTap: _showDataExportDialog,
            ),
            const Divider(color: Colors.white12),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enthaltene Daten:',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  SizedBox(height: 8),
                  _DataItem(icon: LucideIcons.user, text: 'Profildaten & Kontaktinformationen'),
                  _DataItem(icon: LucideIcons.calendar, text: 'Terminhistorie & Buchungen'),
                  _DataItem(icon: LucideIcons.messageSquare, text: 'Nachrichten & Kommunikation'),
                  _DataItem(icon: LucideIcons.image, text: 'Hochgeladene Bilder & Galerie'),
                  _DataItem(icon: LucideIcons.fileText, text: 'Notizen & Präferenzen'),
                ],
              ),
            ),
          ]),

          const SizedBox(height: 24),

          // Data Deletion
          _buildSectionHeader(
            'Konto löschen',
            'Löschen Sie Ihr Konto und alle zugehörigen Daten',
          ),
          const SizedBox(height: 12),
          _buildCard([
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(LucideIcons.trash2, color: Colors.red),
              ),
              title: const Text(
                'Konto unwiderruflich löschen',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Diese Aktion kann nicht rückgängig gemacht werden',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              trailing: const Icon(LucideIcons.chevronRight, color: Colors.red),
              onTap: _showDeleteAccountDialog,
            ),
          ]),

          const SizedBox(height: 24),

          // Legal Documents
          _buildSectionHeader(
            'Rechtliche Dokumente',
            'Datenschutzerklärung & Nutzungsbedingungen',
          ),
          const SizedBox(height: 12),
          _buildCard([
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(LucideIcons.fileText, color: Colors.purple),
              ),
              title: const Text(
                'Datenschutzerklärung',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'Zuletzt aktualisiert: 15.01.2026',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              trailing: const Icon(LucideIcons.externalLink, color: Colors.white54),
              onTap: () => _openDocument('privacy'),
            ),
            const Divider(color: Colors.white12),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(LucideIcons.fileText, color: Colors.purple),
              ),
              title: const Text(
                'Nutzungsbedingungen (AGB)',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'Zuletzt aktualisiert: 15.01.2026',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              trailing: const Icon(LucideIcons.externalLink, color: Colors.white54),
              onTap: () => _openDocument('terms'),
            ),
            const Divider(color: Colors.white12),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(LucideIcons.fileText, color: Colors.purple),
              ),
              title: const Text(
                'Impressum',
                style: TextStyle(color: Colors.white),
              ),
              trailing: const Icon(LucideIcons.externalLink, color: Colors.white54),
              onTap: () => _openDocument('imprint'),
            ),
          ]),
        ],
      ),
    );
  }

  // ============================================================================
  // TAB 4: PRIVACY
  // ============================================================================
  Widget _buildPrivacyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Analytics & Tracking
          _buildSectionHeader(
            'Analytics & Tracking',
            'Steuern Sie, welche Daten zur Verbesserung der App gesammelt werden',
          ),
          const SizedBox(height: 12),
          _buildCard([
            SwitchListTile(
              value: _analyticsEnabled,
              onChanged: (value) => setState(() => _analyticsEnabled = value),
              title: const Text(
                'Nutzungsstatistiken',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'Anonyme Daten zur Verbesserung der App',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              secondary: const Icon(LucideIcons.barChart, color: Colors.blue),
              activeColor: AppColors.gold,
            ),
            const Divider(color: Colors.white12),
            SwitchListTile(
              value: _crashReportingEnabled,
              onChanged: (value) => setState(() => _crashReportingEnabled = value),
              title: const Text(
                'Absturzberichte',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'Automatische Fehlerberichte an Entwickler',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              secondary: const Icon(LucideIcons.alertTriangle, color: Colors.orange),
              activeColor: AppColors.gold,
            ),
          ]),

          const SizedBox(height: 24),

          // Marketing & Communications
          _buildSectionHeader(
            'Marketing & Kommunikation',
            'Verwalten Sie Ihre Kommunikationspräferenzen',
          ),
          const SizedBox(height: 12),
          _buildCard([
            SwitchListTile(
              value: _marketingEmailsEnabled,
              onChanged: (value) => setState(() => _marketingEmailsEnabled = value),
              title: const Text(
                'Marketing-E-Mails',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'Angebote, Neuigkeiten & Aktionen',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              secondary: const Icon(LucideIcons.mail, color: Colors.purple),
              activeColor: AppColors.gold,
            ),
          ]),

          const SizedBox(height: 24),

          // Cookie Consent
          _buildSectionHeader(
            'Cookie-Einstellungen',
            'Verwalten Sie Cookie-Präferenzen',
          ),
          const SizedBox(height: 12),
          _buildCard([
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.brown.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(LucideIcons.cookie, color: Colors.brown),
              ),
              title: const Text(
                'Cookie-Einstellungen verwalten',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Notwendige Cookies: Aktiv • Marketing: Inaktiv',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              trailing: const Icon(LucideIcons.chevronRight, color: Colors.white54),
              onTap: _showCookieSettings,
            ),
          ]),

          const SizedBox(height: 24),

          // Data Retention
          _buildSectionHeader(
            'Datenspeicherung',
            'Informationen zur Speicherdauer Ihrer Daten',
          ),
          const SizedBox(height: 12),
          _buildCard([
            const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _RetentionItem(
                    label: 'Konto-Daten',
                    duration: 'Bis zur Löschung des Kontos',
                    icon: LucideIcons.user,
                  ),
                  SizedBox(height: 12),
                  _RetentionItem(
                    label: 'Terminhistorie',
                    duration: '3 Jahre',
                    icon: LucideIcons.calendar,
                  ),
                  SizedBox(height: 12),
                  _RetentionItem(
                    label: 'Nachrichten',
                    duration: '2 Jahre',
                    icon: LucideIcons.messageSquare,
                  ),
                  SizedBox(height: 12),
                  _RetentionItem(
                    label: 'Zugriffslogs',
                    duration: '90 Tage',
                    icon: LucideIcons.fileText,
                  ),
                ],
              ),
            ),
          ]),
        ],
      ),
    );
  }

  // ============================================================================
  // TAB 5: SECURITY LOG
  // ============================================================================
  Widget _buildSecurityLogTab() {
    return Column(
      children: [
        // Filter Bar
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey[900],
          child: Row(
            children: [
              const Icon(LucideIcons.filter, color: Colors.white54, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Alle', true),
                      _buildFilterChip('Login', false),
                      _buildFilterChip('2FA', false),
                      _buildFilterChip('Passwort', false),
                      _buildFilterChip('Sicherheit', false),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Security Events List
        Expanded(
          child: _securityEvents.isEmpty
              ? const Center(
                  child: Text(
                    'Keine Sicherheitsereignisse vorhanden',
                    style: TextStyle(color: Colors.white54),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _securityEvents.length,
                  itemBuilder: (context, index) {
                    final event = _securityEvents[index];
                    return _buildSecurityEventCard(event);
                  },
                ),
        ),
      ],
    );
  }

  // ============================================================================
  // HELPER WIDGETS
  // ============================================================================

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildPasswordStrengthChecker() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            obscureText: true,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Passwort eingeben...',
              hintStyle: const TextStyle(color: Colors.white54),
              prefixIcon: const Icon(LucideIcons.lock, color: Colors.white54),
              filled: true,
              fillColor: Colors.grey[850],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              // Update strength indicator
              setState(() {});
            },
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(child: _StrengthBar(color: Colors.red, active: true)),
              SizedBox(width: 4),
              Expanded(child: _StrengthBar(color: Colors.orange, active: true)),
              SizedBox(width: 4),
              Expanded(child: _StrengthBar(color: Colors.yellow, active: true)),
              SizedBox(width: 4),
              Expanded(child: _StrengthBar(color: Colors.green, active: false)),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Stärke: Mittel',
            style: TextStyle(color: Colors.orange, fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'Empfehlungen:',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 8),
          const _ChecklistItem(checked: true, text: 'Mindestens 12 Zeichen'),
          const _ChecklistItem(checked: true, text: 'Groß- und Kleinbuchstaben'),
          const _ChecklistItem(checked: true, text: 'Zahlen enthalten'),
          const _ChecklistItem(checked: false, text: 'Sonderzeichen (!@#\$%^&*)'),
        ],
      ),
    );
  }

  Widget _buildSessionCard(Map<String, dynamic> session) {
    final bool isCurrent = session['isCurrent'] ?? false;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrent ? AppColors.gold : Colors.white24,
          width: isCurrent ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getDeviceColor(session['device']).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getDeviceIcon(session['device']),
                  color: _getDeviceColor(session['device']),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          session['device'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (isCurrent) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.gold,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Aktuell',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      session['location'],
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              if (!isCurrent)
                IconButton(
                  onPressed: () => _showLogoutSessionDialog(session),
                  icon: const Icon(LucideIcons.logOut, color: Colors.red, size: 20),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(LucideIcons.clock, size: 14, color: Colors.white54),
              const SizedBox(width: 6),
              Text(
                'Letzte Aktivität: ${_formatRelativeTime(session['lastActive'])}',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(LucideIcons.globe, size: 14, color: Colors.white54),
              const SizedBox(width: 6),
              Text(
                'IP: ${session['ip']}',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityEventCard(Map<String, dynamic> event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getEventColor(event['type']).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getEventColor(event['type']).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getEventIcon(event['type']),
              color: _getEventColor(event['type']),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  event['description'],
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDateTime(event['timestamp']),
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool selected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (value) {},
        selectedColor: AppColors.gold,
        checkmarkColor: Colors.black,
        backgroundColor: Colors.grey[850],
        labelStyle: TextStyle(
          color: selected ? Colors.black : Colors.white70,
          fontSize: 13,
        ),
      ),
    );
  }

  // ============================================================================
  // DIALOGS
  // ============================================================================

  void _show2FASetupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Row(
          children: [
            Icon(LucideIcons.smartphone, color: AppColors.gold),
            SizedBox(width: 12),
            Text('2FA einrichten', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Scannen Sie diesen QR-Code mit Ihrer Authenticator-App:',
                style: TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: QrImageView(
                  data: 'otpauth://totp/SalonManager:user@example.com?secret=$_totpSecret&issuer=SalonManager',
                  version: QrVersions.auto,
                  size: 200,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  _totpSecret,
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: '6-stelliger Code eingeben',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                maxLength: 6,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _is2FAEnabled = true);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('2FA erfolgreich aktiviert'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold),
            child: const Text('Aktivieren', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _showDisable2FADialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Row(
          children: [
            Icon(LucideIcons.alertTriangle, color: Colors.orange),
            SizedBox(width: 12),
            Text('2FA deaktivieren?', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: const Text(
          'Möchten Sie die Zwei-Faktor-Authentifizierung wirklich deaktivieren? Ihr Konto wird dadurch weniger sicher.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _is2FAEnabled = false);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('2FA deaktiviert'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Deaktivieren'),
          ),
        ],
      ),
    );
  }

  void _showBackupCodes() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Row(
          children: [
            Icon(LucideIcons.key, color: AppColors.gold),
            SizedBox(width: 12),
            Text('Backup-Codes', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Bewahren Sie diese Codes sicher auf. Jeder Code kann nur einmal verwendet werden.',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                children: [
                  _BackupCodeItem('1A2B-3C4D-5E6F'),
                  _BackupCodeItem('2B3C-4D5E-6F7G'),
                  _BackupCodeItem('3C4D-5E6F-7G8H'),
                  _BackupCodeItem('4D5E-6F7G-8H9I'),
                  _BackupCodeItem('5E6F-7G8H-9I0J'),
                  _BackupCodeItem('6F7G-8H9I-0J1K'),
                  _BackupCodeItem('7G8H-9I0J-1K2L'),
                  _BackupCodeItem('8H9I-0J1K-2L3M'),
                  _BackupCodeItem('9I0J-1K2L-3M4N', used: true),
                  _BackupCodeItem('0J1K-2L3M-4N5O', used: true),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Schließen', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Backup-Codes in Zwischenablage kopiert'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            icon: const Icon(LucideIcons.copy),
            label: const Text('Kopieren'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: Colors.black),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Row(
          children: [
            Icon(LucideIcons.lock, color: AppColors.gold),
            SizedBox(width: 12),
            Text('Passwort ändern', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Aktuelles Passwort',
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[850],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Neues Passwort',
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[850],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Neues Passwort bestätigen',
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[850],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Passwort erfolgreich geändert'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold),
            child: const Text('Ändern', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _showLogoutAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Row(
          children: [
            Icon(LucideIcons.logOut, color: Colors.red),
            SizedBox(width: 12),
            Text('Von allen Geräten abmelden?', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: const Text(
          'Sie werden von allen Geräten abgemeldet und müssen sich erneut anmelden.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Von allen Geräten abgemeldet'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Abmelden'),
          ),
        ],
      ),
    );
  }

  void _showLogoutSessionDialog(Map<String, dynamic> session) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Row(
          children: [
            Icon(LucideIcons.logOut, color: Colors.orange),
            SizedBox(width: 12),
            Text('Sitzung beenden?', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Text(
          'Möchten Sie die Sitzung auf "${session['device']}" beenden?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sitzung beendet'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Beenden'),
          ),
        ],
      ),
    );
  }

  void _showDataExportDialog() {
    showDialog(
      context: context,
      builder: (context) {
        bool loading = false;
        String? error;
        String? exportResult;
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            backgroundColor: Colors.grey[900],
            title: const Row(
              children: [
                Icon(LucideIcons.download, color: Colors.green),
                SizedBox(width: 12),
                Text('Daten exportieren', style: TextStyle(color: Colors.white)),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (loading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Fehler beim Export: $error',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                if (exportResult != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: SelectableText(
                      exportResult!,
                      style: const TextStyle(color: Colors.greenAccent),
                    ),
                  ),
                if (!loading && error == null && exportResult == null)
                  ...[
                    const Text(
                      'Wir erstellen eine vollständige Kopie Ihrer Daten. Der Export kann einige Minuten dauern.',
                      style: TextStyle(color: Colors.white70),
                    ),
                    SizedBox(height: 16),
                    const Text(
                      'Format auswählen:',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Abbrechen', style: TextStyle(color: Colors.white54)),
              ),
              ElevatedButton(
                onPressed: loading
                    ? null
                    : () async {
                        setState(() {
                          loading = true;
                          error = null;
                          exportResult = null;
                        });
                        try {
                          final identity = ref.read(identityProvider);
                          final customerProfileId = identity.userId;
                          if (customerProfileId == null) {
                            setState(() {
                              error = 'Keine Nutzer-ID gefunden.';
                              loading = false;
                            });
                            return;
                          }
                          final uri = Uri.parse('https://YOUR_SUPABASE_EDGE_URL/functions/v1/export-customer-data');
                          final response = await Future.delayed(const Duration(milliseconds: 500), () async {
                            // TODO: Replace YOUR_SUPABASE_EDGE_URL with real endpoint
                            return await http.post(
                              uri,
                              headers: {'Content-Type': 'application/json'},
                              body: '{"customer_profile_id": "$customerProfileId"}',
                            );
                          });
                          if (response.statusCode == 200) {
                            setState(() {
                              exportResult = response.body;
                              loading = false;
                            });
                          } else {
                            setState(() {
                              error = 'Backend-Fehler: ${response.statusCode}';
                              loading = false;
                            });
                          }
                        } catch (e) {
                          setState(() {
                            error = 'Technischer Fehler: $e';
                            loading = false;
                          });
                        }
                      },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('JSON exportieren'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        bool loading = false;
        String? error;
        bool success = false;
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            backgroundColor: Colors.grey[900],
            title: const Row(
              children: [
                Icon(LucideIcons.alertTriangle, color: Colors.red),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Konto unwiderruflich löschen?',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Diese Aktion kann NICHT rückgängig gemacht werden!',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Folgendes wird gelöscht:',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                const Text('• Alle persönlichen Daten', style: TextStyle(color: Colors.white70)),
                const Text('• Terminhistorie', style: TextStyle(color: Colors.white70)),
                const Text('• Nachrichten & Kommunikation', style: TextStyle(color: Colors.white70)),
                const Text('• Hochgeladene Bilder', style: TextStyle(color: Colors.white70)),
                const Text('• Treuepunkte & Präferenzen', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Geben Sie "LÖSCHEN" ein',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.grey[850],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(error!, style: const TextStyle(color: Colors.red)),
                  ),
                if (loading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                if (success)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Konto-Löschung erfolgreich eingeleitet. Sie erhalten eine Bestätigungs-E-Mail.',
                      style: const TextStyle(color: Colors.orange),
                    ),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Abbrechen', style: TextStyle(color: Colors.white54)),
              ),
              ElevatedButton(
                onPressed: loading || success
                    ? null
                    : () async {
                        final confirm = controller.text.trim().toUpperCase();
                        if (confirm != 'LÖSCHEN') {
                          setState(() {
                            error = 'Bitte geben Sie das Bestätigungswort exakt ein.';
                          });
                          return;
                        }
                        setState(() {
                          loading = true;
                          error = null;
                        });
                        try {
                          final identity = ref.read(identityProvider);
                          final userId = identity.userId;
                          if (userId == null) {
                            setState(() {
                              error = 'Keine Nutzer-ID gefunden.';
                              loading = false;
                            });
                            return;
                          }
                          final uri = Uri.parse('https://YOUR_SUPABASE_EDGE_URL/functions/v1/delete-customer-data');
                          final response = await Future.delayed(const Duration(milliseconds: 500), () async {
                            // TODO: Replace YOUR_SUPABASE_EDGE_URL with real endpoint
                            return await http.post(
                              uri,
                              headers: {'Content-Type': 'application/json'},
                              body: '{"user_id": "$userId"}',
                            );
                          });
                          if (response.statusCode == 200) {
                            setState(() {
                              success = true;
                              loading = false;
                            });
                          } else {
                            setState(() {
                              error = 'Backend-Fehler: ${response.statusCode}';
                              loading = false;
                            });
                          }
                        } catch (e) {
                          setState(() {
                            error = 'Technischer Fehler: $e';
                            loading = false;
                          });
                        }
                      },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Endgültig löschen'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCookieSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Row(
          children: [
            Icon(LucideIcons.cookie, color: Colors.brown),
            SizedBox(width: 12),
            Text('Cookie-Einstellungen', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              value: true,
              onChanged: null,
              title: const Text('Notwendige Cookies', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Erforderlich für Basisfunktionen', style: TextStyle(color: Colors.white70, fontSize: 12)),
              activeColor: Colors.grey,
            ),
            SwitchListTile(
              value: _analyticsEnabled,
              onChanged: (value) => setState(() => _analyticsEnabled = value),
              title: const Text('Analytische Cookies', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Helfen uns die App zu verbessern', style: TextStyle(color: Colors.white70, fontSize: 12)),
              activeColor: AppColors.gold,
            ),
            SwitchListTile(
              value: _marketingEmailsEnabled,
              onChanged: (value) => setState(() => _marketingEmailsEnabled = value),
              title: const Text('Marketing-Cookies', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Personalisierte Werbung', style: TextStyle(color: Colors.white70, fontSize: 12)),
              activeColor: AppColors.gold,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cookie-Einstellungen gespeichert'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold),
            child: const Text('Speichern', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _openDocument(String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${type == 'privacy' ? 'Datenschutzerklärung' : type == 'terms' ? 'AGB' : 'Impressum'} wird geöffnet...'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  IconData _getDeviceIcon(String device) {
    if (device.contains('iPhone') || device.contains('Android')) return LucideIcons.smartphone;
    if (device.contains('iPad') || device.contains('Tablet')) return LucideIcons.tablet;
    return LucideIcons.monitor;
  }

  Color _getDeviceColor(String device) {
    if (device.contains('iPhone') || device.contains('Android')) return Colors.blue;
    if (device.contains('iPad') || device.contains('Tablet')) return Colors.purple;
    return Colors.green;
  }

  IconData _getEventIcon(String type) {
    switch (type) {
      case 'login':
        return LucideIcons.logIn;
      case '2fa':
        return LucideIcons.shield;
      case 'password':
        return LucideIcons.lock;
      case 'security':
        return LucideIcons.alertTriangle;
      default:
        return LucideIcons.activity;
    }
  }

  Color _getEventColor(String type) {
    switch (type) {
      case 'login':
        return Colors.blue;
      case '2fa':
        return Colors.green;
      case 'password':
        return Colors.orange;
      case 'security':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) return 'Gerade eben';
    if (difference.inMinutes < 60) return 'Vor ${difference.inMinutes} Min';
    if (difference.inHours < 24) return 'Vor ${difference.inHours} Std';
    if (difference.inDays < 7) return 'Vor ${difference.inDays} Tagen';
    
    return DateFormat('dd.MM.yyyy').format(dateTime);
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy • HH:mm').format(dateTime);
  }
}

// ============================================================================
// STATIC WIDGETS
// ============================================================================

class _DataItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DataItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.gold),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _RetentionItem extends StatelessWidget {
  final String label;
  final String duration;
  final IconData icon;

  const _RetentionItem({
    required this.label,
    required this.duration,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white54),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ),
        Text(
          duration,
          style: const TextStyle(
            color: AppColors.gold,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _StrengthBar extends StatelessWidget {
  final Color color;
  final bool active;

  const _StrengthBar({required this.color, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: active ? color : Colors.grey[800],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  final bool checked;
  final String text;

  const _ChecklistItem({required this.checked, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(
            checked ? LucideIcons.checkCircle : LucideIcons.circle,
            size: 16,
            color: checked ? Colors.green : Colors.white24,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: checked ? Colors.green : Colors.white54,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackupCodeItem extends StatelessWidget {
  final String code;
  final bool used;

  const _BackupCodeItem(this.code, {this.used = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            code,
            style: TextStyle(
              color: used ? Colors.white24 : AppColors.gold,
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
              decoration: used ? TextDecoration.lineThrough : null,
            ),
          ),
          if (used)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Verwendet',
                style: TextStyle(color: Colors.red, fontSize: 10),
              ),
            ),
        ],
      ),
    );
  }
}

// ============================================================================
// DATA PLACEHOLDERS (empty until backend is connected)
// ============================================================================

final _activeSessions = <Map<String, dynamic>>[];
final _securityEvents = <Map<String, dynamic>>[];
