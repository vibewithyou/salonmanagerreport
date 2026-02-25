# 🔐 Dashboard Login-System - Flutter Migration TODO

**Erstellt:** 13. Februar 2026  
**Status:** Planung  
**Ziel:** Integration des Dashboard-Login-Systems (Salon-Code + Time-Code) in die bestehende Flutter-App

---

## 📋 Übersicht

### Zwei Login-Systeme

Die App wird **zwei parallele Login-Systeme** haben:

1. **Bestehendes System** (bleibt unverändert)
   - Email/Password via Supabase Auth
   - User-Rollen aus `user_roles` Tabelle
   - Identity Provider für Rollenauslese
   - Routes: `/login`, `/register`, etc.

2. **Neues Dashboard-System** (wird hinzugefügt)
   - Salon-Code Login: `salon_id` + `salon_code` (6-stellig)
   - Time-Code Login: Mitarbeiter `time_code`
   - PostgreSQL RPC Functions für Verifizierung
   - Routes: `/dashboard-login`
   - **KEIN Supabase Auth** (keine Email/Password)

---

## 🗄️ Backend (Supabase) - BEREITS VORHANDEN ✅

### Vorhandene Tabellen

```sql
-- Salon-Codes für Admin-Login
CREATE TABLE public.salon_codes (
  id UUID PRIMARY KEY,
  salon_id UUID NOT NULL UNIQUE,
  code VARCHAR NOT NULL,  -- 6-stelliger Code z.B. "123456"
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Mitarbeiter Time-Codes
CREATE TABLE public.employee_time_codes (
  id UUID PRIMARY KEY,
  employee_id UUID NOT NULL,
  time_code VARCHAR NOT NULL,  -- z.B. "EMP-2024-001"
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Dashboard-Konfiguration pro Salon
CREATE TABLE public.salon_dashboard_config (
  id UUID PRIMARY KEY,
  salon_id UUID NOT NULL UNIQUE,
  enabled_modules JSONB DEFAULT {...},  -- Welche Module aktiviert sind
  permissions JSONB DEFAULT {...},       -- Berechtigungen
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

### Vorhandene PostgreSQL Functions

```sql
-- Salon-Code verifizieren
CREATE FUNCTION public.verify_salon_code(
  p_salon_id UUID,
  p_code TEXT
)
RETURNS TABLE(
  is_valid BOOLEAN,
  salon_id UUID,
  salon_name TEXT
)
SECURITY DEFINER;

-- Mitarbeiter Time-Code verifizieren
CREATE FUNCTION public.verify_employee_time_code(
  p_time_code VARCHAR
)
RETURNS TABLE(
  employee_id UUID,
  salon_id UUID,
  employee_name TEXT,
  is_active BOOLEAN
)
SECURITY DEFINER;
```

---

## 📦 Zu erstellende Flutter-Komponenten

### Phase 1: Models & Data Layer

#### ✅ TODO 1.1: Dashboard User Model erstellen

**Datei:** `lib/features/dashboard_login/models/dashboard_user.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_user.freezed.dart';
part 'dashboard_user.g.dart';

enum DashboardUserRole {
  @JsonValue('admin')
  admin,
  @JsonValue('employee')
  employee,
}

@freezed
class DashboardUser with _$DashboardUser {
  const factory DashboardUser({
    required String id,              // Format: "salon-{uuid}" oder "employee-{uuid}"
    required String salonId,
    required DashboardUserRole role,
    String? salonName,
    String? employeeName,
    String? employeeId,
  }) = _DashboardUser;

  factory DashboardUser.fromJson(Map<String, dynamic> json) =>
      _$DashboardUserFromJson(json);
}
```

**Aktionen:**
- [ ] Datei erstellen
- [ ] `freezed` & `json_serializable` imports hinzufügen
- [ ] Model definieren gemäß React-Struktur
- [ ] Code generieren: `flutter pub run build_runner build`

---

#### ✅ TODO 1.2: Dashboard Config Model erstellen

**Datei:** `lib/features/dashboard_login/models/dashboard_config.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_config.freezed.dart';
part 'dashboard_config.g.dart';

@freezed
class DashboardConfig with _$DashboardConfig {
  const factory DashboardConfig({
    required String id,
    required String salonId,
    required Map<String, bool> enabledModules,
    required Map<String, bool> permissions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _DashboardConfig;

  factory DashboardConfig.fromJson(Map<String, dynamic> json) =>
      _$DashboardConfigFromJson(json);
}

extension DashboardConfigX on DashboardConfig {
  bool isModuleEnabled(String moduleName) {
    return enabledModules[moduleName] ?? false;
  }
  
  bool hasPermission(String permissionName) {
    return permissions[permissionName] ?? false;
  }
}
```

**Aktionen:**
- [ ] Datei erstellen
- [ ] Extension Methods für Helper-Funktionen hinzufügen
- [ ] Code generieren

---

#### ✅ TODO 1.3: Dashboard Session Model erstellen

**Datei:** `lib/features/dashboard_login/models/dashboard_session.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dashboard_user.dart';

part 'dashboard_session.freezed.dart';
part 'dashboard_session.g.dart';

@freezed
class DashboardSession with _$DashboardSession {
  const factory DashboardSession({
    required DashboardUser user,
    required int expiresAt,  // Unix timestamp (ms)
  }) = _DashboardSession;

  factory DashboardSession.fromJson(Map<String, dynamic> json) =>
      _$DashboardSessionFromJson(json);
}

extension DashboardSessionX on DashboardSession {
  bool get isExpired {
    return DateTime.now().millisecondsSinceEpoch > expiresAt;
  }
  
  Duration get remainingTime {
    final remaining = expiresAt - DateTime.now().millisecondsSinceEpoch;
    return Duration(milliseconds: remaining > 0 ? remaining : 0);
  }
}
```

**Aktionen:**
- [ ] Datei erstellen
- [ ] Session-Validierung mit `isExpired` implementieren
- [ ] Code generieren

---

### Phase 2: Services Layer

#### ✅ TODO 2.1: Dashboard Auth Service erstellen

**Datei:** `lib/features/dashboard_login/services/dashboard_auth_service.dart`

```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/dashboard_user.dart';
import '../models/dashboard_config.dart';

class DashboardAuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Salon-Login mit salon_id + code
  Future<DashboardUser> loginWithSalonCode({
    required String salonId,
    required String code,
  }) async {
    // RPC: verify_salon_code
    final response = await _supabase.rpc(
      'verify_salon_code',
      params: {
        'p_salon_id': salonId,
        'p_code': code,
      },
    ).single();

    if (response['is_valid'] != true) {
      throw Exception('Ungültiger Salon-Code');
    }

    return DashboardUser(
      id: 'salon-$salonId',
      salonId: salonId,
      role: DashboardUserRole.admin,
      salonName: response['salon_name'],
    );
  }

  /// Mitarbeiter-Login mit time_code
  Future<DashboardUser> loginWithTimeCode({
    required String timeCode,
  }) async {
    // RPC: verify_employee_time_code
    final response = await _supabase.rpc(
      'verify_employee_time_code',
      params: {'p_time_code': timeCode},
    ).single();

    if (response['is_active'] != true) {
      throw Exception('Mitarbeiter nicht aktiv');
    }

    return DashboardUser(
      id: 'employee-${response['employee_id']}',
      salonId: response['salon_id'],
      role: DashboardUserRole.employee,
      employeeName: response['employee_name'],
      employeeId: response['employee_id'],
    );
  }

  /// Dashboard-Konfiguration laden
  Future<DashboardConfig> getDashboardConfig(String salonId) async {
    final response = await _supabase
        .from('salon_dashboard_config')
        .select()
        .eq('salon_id', salonId)
        .single();

    return DashboardConfig.fromJson(response);
  }
}
```

**Aktionen:**
- [ ] Datei erstellen
- [ ] `loginWithSalonCode()` implementieren
- [ ] `loginWithTimeCode()` implementieren
- [ ] `getDashboardConfig()` implementieren
- [ ] Error Handling hinzufügen

---

#### ✅ TODO 2.2: Dashboard Session Service erstellen

**Datei:** `lib/features/dashboard_login/services/dashboard_session_service.dart`

```dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dashboard_session.dart';
import '../models/dashboard_user.dart';

class DashboardSessionService {
  static const String _sessionKey = 'dashboard_auth_session';
  static const Duration sessionDuration = Duration(hours: 24);

  final SharedPreferences _prefs;

  DashboardSessionService(this._prefs);

  /// Session speichern
  Future<void> saveSession(DashboardUser user) async {
    final expiresAt = DateTime.now()
        .add(sessionDuration)
        .millisecondsSinceEpoch;

    final session = DashboardSession(
      user: user,
      expiresAt: expiresAt,
    );

    await _prefs.setString(_sessionKey, jsonEncode(session.toJson()));
  }

  /// Session laden
  Future<DashboardSession?> getSession() async {
    final jsonString = _prefs.getString(_sessionKey);
    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final session = DashboardSession.fromJson(json);

      if (session.isExpired) {
        await clearSession();
        return null;
      }

      return session;
    } catch (e) {
      await clearSession();
      return null;
    }
  }

  /// Session löschen
  Future<void> clearSession() async {
    await _prefs.remove(_sessionKey);
  }
}
```

**Aktionen:**
- [ ] Datei erstellen
- [ ] Session-Persistierung mit SharedPreferences
- [ ] Automatische Ablauf-Prüfung implementieren

---

### Phase 3: State Management (Riverpod)

#### ✅ TODO 3.1: Dashboard Auth Provider erstellen

**Datei:** `lib/features/dashboard_login/providers/dashboard_auth_provider.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/dashboard_user.dart';
import '../models/dashboard_config.dart';
import '../services/dashboard_auth_service.dart';
import '../services/dashboard_session_service.dart';

// Service Providers
final dashboardAuthServiceProvider = Provider<DashboardAuthService>((ref) {
  return DashboardAuthService();
});

final dashboardSessionServiceProvider = Provider<DashboardSessionService>((ref) {
  // Muss in main.dart über ProviderScope.overrides initialisiert werden
  throw UnimplementedError('DashboardSessionService muss initialisiert werden');
});

// State Class
class DashboardAuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final DashboardUser? user;
  final DashboardConfig? config;
  final String? error;

  const DashboardAuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.user,
    this.config,
    this.error,
  });

  DashboardAuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    DashboardUser? user,
    DashboardConfig? config,
    String? error,
  }) {
    return DashboardAuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      config: config ?? this.config,
      error: error ?? this.error,
    );
  }
}

// Notifier
class DashboardAuthNotifier extends StateNotifier<DashboardAuthState> {
  final DashboardAuthService _authService;
  final DashboardSessionService _sessionService;

  DashboardAuthNotifier(this._authService, this._sessionService)
      : super(const DashboardAuthState()) {
    _restoreSession();
  }

  /// Session aus SharedPreferences wiederherstellen
  Future<void> _restoreSession() async {
    final session = await _sessionService.getSession();

    if (session != null && !session.isExpired) {
      // Config laden
      final config = await _authService.getDashboardConfig(session.user.salonId);

      state = state.copyWith(
        isAuthenticated: true,
        user: session.user,
        config: config,
      );
    }
  }

  /// Salon-Login
  Future<void> loginWithSalonCode({
    required String salonId,
    required String code,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _authService.loginWithSalonCode(
        salonId: salonId,
        code: code,
      );

      final config = await _authService.getDashboardConfig(user.salonId);

      await _sessionService.saveSession(user);

      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        user: user,
        config: config,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// Time-Code Login
  Future<void> loginWithTimeCode({
    required String timeCode,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _authService.loginWithTimeCode(timeCode: timeCode);
      final config = await _authService.getDashboardConfig(user.salonId);

      await _sessionService.saveSession(user);

      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        user: user,
        config: config,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// Logout
  Future<void> logout() async {
    await _sessionService.clearSession();
    state = const DashboardAuthState();
  }
}

// Provider
final dashboardAuthProvider =
    StateNotifierProvider<DashboardAuthNotifier, DashboardAuthState>((ref) {
  final authService = ref.watch(dashboardAuthServiceProvider);
  final sessionService = ref.watch(dashboardSessionServiceProvider);
  return DashboardAuthNotifier(authService, sessionService);
});

// Convenience Providers
final isDashboardAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(dashboardAuthProvider).isAuthenticated;
});

final currentDashboardUserProvider = Provider<DashboardUser?>((ref) {
  return ref.watch(dashboardAuthProvider).user;
});

final dashboardConfigProvider = Provider<DashboardConfig?>((ref) {
  return ref.watch(dashboardAuthProvider).config;
});
```

**Aktionen:**
- [ ] Datei erstellen
- [ ] State Management mit Riverpod
- [ ] Auto-Restore Session implementieren
- [ ] Login-Methoden für beide Typen

---

### Phase 4: UI Screens - **KEIN UI DESIGN, NUR FUNKTIONALITÄT**

#### ✅ TODO 4.1: Dashboard Login Screen erstellen

**Datei:** `lib/features/dashboard_login/presentation/dashboard_login_screen.dart`

**Wichtig:** NUR FUNKTIONALITÄT, KEIN DESIGN! UI bleibt wie vom User vorgegeben.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/dashboard_auth_provider.dart';

class DashboardLoginScreen extends ConsumerStatefulWidget {
  const DashboardLoginScreen({super.key});

  @override
  ConsumerState<DashboardLoginScreen> createState() =>
      _DashboardLoginScreenState();
}

class _DashboardLoginScreenState extends ConsumerState<DashboardLoginScreen> {
  final _salonIdController = TextEditingController();
  final _salonCodeController = TextEditingController();
  final _timeCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isSalonLogin = true; // Toggle zwischen Salon und Time-Code

  @override
  void dispose() {
    _salonIdController.dispose();
    _salonCodeController.dispose();
    _timeCodeController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      if (_isSalonLogin) {
        // Salon-Login
        await ref.read(dashboardAuthProvider.notifier).loginWithSalonCode(
              salonId: _salonIdController.text.trim(),
              code: _salonCodeController.text.trim(),
            );
      } else {
        // Time-Code Login
        await ref.read(dashboardAuthProvider.notifier).loginWithTimeCode(
              timeCode: _timeCodeController.text.trim(),
            );
      }

      if (mounted) {
        context.go('/dashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login fehlgeschlagen: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(dashboardAuthProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Login')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Toggle zwischen Salon / Employee
              SegmentedButton<bool>(
                selected: {_isSalonLogin},
                onSelectionChanged: (Set<bool> selection) {
                  setState(() {
                    _isSalonLogin = selection.first;
                  });
                },
                segments: const [
                  ButtonSegment(value: true, label: Text('Salon-Owner')),
                  ButtonSegment(value: false, label: Text('Mitarbeiter')),
                ],
              ),

              const SizedBox(height: 24),

              // SALON LOGIN FORM
              if (_isSalonLogin) ...[
                TextFormField(
                  controller: _salonIdController,
                  decoration: const InputDecoration(
                    labelText: 'Salon ID',
                    hintText: 'UUID des Salons',
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Pflichtfeld' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _salonCodeController,
                  decoration: const InputDecoration(
                    labelText: 'Salon-Code',
                    hintText: '6-stelliger Code',
                  ),
                  maxLength: 6,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Pflichtfeld' : null,
                ),
              ],

              // TIME-CODE LOGIN FORM
              if (!_isSalonLogin) ...[
                TextFormField(
                  controller: _timeCodeController,
                  decoration: const InputDecoration(
                    labelText: 'Mitarbeiter Time-Code',
                    hintText: 'z.B. EMP-2024-001',
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Pflichtfeld' : null,
                ),
              ],

              const SizedBox(height: 24),

              // Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: authState.isLoading ? null : _handleLogin,
                  child: authState.isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Anmelden'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Aktionen:**
- [ ] Screen erstellen
- [ ] Formular für beide Login-Typen
- [ ] Toggle zwischen Salon/Employee
- [ ] Validierung
- [ ] Loading State anzeigen
- [ ] Error Handling mit SnackBar

---

#### ✅ TODO 4.2: Dashboard Main Screen erstellen

**Datei:** `lib/features/dashboard_login/presentation/dashboard_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/dashboard_auth_provider.dart';
import '../models/dashboard_user.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentDashboardUserProvider);
    final config = ref.watch(dashboardConfigProvider);

    if (user == null || config == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(user.role == DashboardUserRole.admin
            ? 'Admin Dashboard'
            : 'Mitarbeiter Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(dashboardAuthProvider.notifier).logout();
              if (context.mounted) {
                context.go('/dashboard-login');
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Angemeldet als:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.role == DashboardUserRole.admin
                          ? user.salonName ?? 'Admin'
                          : user.employeeName ?? 'Mitarbeiter',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text('Salon ID: ${user.salonId}'),
                    Text('Rolle: ${user.role.name}'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Module Grid (basierend auf enabled_modules)
            Text(
              'Verfügbare Module:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  if (config.isModuleEnabled('pos'))
                    _ModuleCard(
                      title: 'Kasse',
                      icon: Icons.point_of_sale,
                      onTap: () {},
                    ),
                  if (config.isModuleEnabled('booking'))
                    _ModuleCard(
                      title: 'Buchungen',
                      icon: Icons.calendar_today,
                      onTap: () {},
                    ),
                  if (config.isModuleEnabled('customers'))
                    _ModuleCard(
                      title: 'Kunden',
                      icon: Icons.people,
                      onTap: () {},
                    ),
                  if (config.isModuleEnabled('services'))
                    _ModuleCard(
                      title: 'Leistungen',
                      icon: Icons.content_cut,
                      onTap: () {},
                    ),
                  if (config.isModuleEnabled('analytics'))
                    _ModuleCard(
                      title: 'Statistiken',
                      icon: Icons.analytics,
                      onTap: () {},
                    ),
                  if (config.isModuleEnabled('time_tracking'))
                    _ModuleCard(
                      title: 'Zeiterfassung',
                      icon: Icons.access_time,
                      onTap: () {},
                    ),
                  if (config.isModuleEnabled('admin') &&
                      user.role == DashboardUserRole.admin)
                    _ModuleCard(
                      title: 'Verwaltung',
                      icon: Icons.admin_panel_settings,
                      onTap: () {},
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _ModuleCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
```

**Aktionen:**
- [ ] Dashboard Screen erstellen
- [ ] User-Info anzeigen (Name, Rolle, Salon)
- [ ] Module Grid basierend auf `enabled_modules`
- [ ] Logout-Funktionalität
- [ ] Rollenbasierte Anzeige (Admin vs Employee)

---

### Phase 5: Navigation & Routing

#### ✅ TODO 5.1: Router erweitern für Dashboard-Routes

**Datei:** `lib/core/routing/app_router.dart` (erweitern)

```dart
// Neue Routes hinzufügen zu bestehendem GoRouter

GoRoute(
  path: '/dashboard-login',
  builder: (context, state) => const DashboardLoginScreen(),
),

// Dashboard nur für eingeloggte Dashboard-User
ShellRoute(
  builder: (context, state, child) {
    // Dashboard Auth Check
    return child;
  },
  routes: [
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
      redirect: (context, state) {
        // Check ob Dashboard-User eingeloggt ist
        final ref = ProviderScope.containerOf(context);
        final isDashboardAuth = ref.read(isDashboardAuthenticatedProvider);
        
        if (!isDashboardAuth) {
          return '/dashboard-login';
        }
        return null;
      },
    ),
  ],
),
```

**Aktionen:**
- [ ] `/dashboard-login` Route hinzufügen
- [ ] `/dashboard` Route hinzufügen
- [ ] Redirect-Logik für Dashboard-Auth
- [ ] Trennung von normalem Auth und Dashboard-Auth

---

#### ✅ TODO 5.2: Entry Point erweitern (main.dart)

**Datei:** `lib/main.dart` (erweitern)

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Supabase initialisieren (bereits vorhanden)
  await SupabaseService().initialize();

  // NEU: SharedPreferences für Dashboard-Session
  final prefs = await SharedPreferences.getInstance();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('de')],
      path: 'assets/translations',
      fallbackLocale: const Locale('de'),
      startLocale: const Locale('de'),
      child: ProviderScope(
        overrides: [
          // NEU: Dashboard Session Service Provider
          dashboardSessionServiceProvider.overrideWithValue(
            DashboardSessionService(prefs),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}
```

**Aktionen:**
- [ ] SharedPreferences in main.dart initialisieren
- [ ] DashboardSessionService Provider Override
- [ ] Imports hinzufügen

---

### Phase 6: Testing & Validierung

#### ✅ TODO 6.1: Funktionale Tests

**Tests:**

- [ ] **Salon-Login testen**
  - [ ] Gültiger Code → Erfolgreicher Login
  - [ ] Ungültiger Code → Fehlermeldung
  - [ ] Falscher salon_id → Fehlermeldung

- [ ] **Mitarbeiter-Login testen**
  - [ ] Gültiger Time-Code → Erfolgreicher Login
  - [ ] Ungültiger Time-Code → Fehlermeldung
  - [ ] Inaktiver Mitarbeiter → Fehlermeldung

- [ ] **Session-Management testen**
  - [ ] Login → Session gespeichert
  - [ ] App neu starten → Auto-Login
  - [ ] Nach 24h → Session abgelaufen
  - [ ] Logout → Session gelöscht

- [ ] **Navigation testen**
  - [ ] Nicht eingeloggt → Redirect zu `/dashboard-login`
  - [ ] Eingeloggt → Zugriff auf `/dashboard`
  - [ ] Normal Auth und Dashboard Auth parallel

- [ ] **Config-Module testen**
  - [ ] Nur aktivierte Module anzeigen
  - [ ] Admin-Modul nur für Admins
  - [ ] Employee sieht nur erlaubte Module

---

#### ✅ TODO 6.2: Integration Tests

**Datei:** `test/integration/dashboard_login_test.dart`

```dart
void main() {
  group('Dashboard Login Integration', () {
    test('Salon-Login mit gültigem Code', () async {
      // Test implementieren
    });

    test('Session Persistence', () async {
      // Test implementieren
    });

    test('Logout funktioniert', () async {
      // Test implementieren
    });
  });
}
```

**Aktionen:**
- [ ] Integration Tests schreiben
- [ ] Mock Supabase verwenden
- [ ] Edge Cases testen

---

### Phase 7: Dokumentation & Cleanup

#### ✅ TODO 7.1: Dokumentation ergänzen

**Dateien zu aktualisieren:**

- [ ] `README.md` - Dashboard-Login dokumentieren
- [ ] `kontext/PROJECT_STATUS.md` - Status aktualisieren
- [ ] Code-Kommentare ergänzen

---

#### ✅ TODO 7.2: Code Review & Refactoring

- [ ] Error Handling überprüfen
- [ ] Loading States konsistent
- [ ] Code-Duplikation vermeiden
- [ ] Best Practices befolgen

---

## 📊 Abhängigkeiten in pubspec.yaml

### Bereits vorhanden ✅
```yaml
dependencies:
  flutter_riverpod: ^2.4.0
  go_router: ^13.0.0
  supabase_flutter: ^2.0.0
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  shared_preferences: ^2.2.0

dev_dependencies:
  build_runner: ^2.4.7
  freezed: ^2.4.5
  json_serializable: ^6.7.1
```

**Keine neuen Dependencies nötig!** ✅

---

## 🎯 Implementierungs-Reihenfolge (Empfohlen)

### Sprint 1: Foundation (1-2 Tage)
1. Models erstellen (TODO 1.1, 1.2, 1.3)
2. Code generieren mit `build_runner`
3. Service Layer (TODO 2.1, 2.2)

### Sprint 2: State Management (1 Tag)
4. Dashboard Auth Provider (TODO 3.1)
5. Session Restore implementieren

### Sprint 3: UI & Navigation (2 Tage)
6. Login Screen (TODO 4.1)
7. Dashboard Screen (TODO 4.2)
8. Router erweitern (TODO 5.1, 5.2)

### Sprint 4: Testing & Polish (1-2 Tage)
9. Tests schreiben (TODO 6.1, 6.2)
10. Dokumentation (TODO 7.1, 7.2)

**Gesamtdauer:** 5-7 Tage

---

## 🔄 Unterschied: Normales Login vs Dashboard Login

| Feature | Normales Login | Dashboard Login |
|---------|----------------|-----------------|
| **Auth-Methode** | Email + Password | Salon-Code / Time-Code |
| **Supabase Auth** | ✅ Ja (signInWithPassword) | ❌ Nein (nur RPC) |
| **Tabelle** | `user_roles` | `salon_codes`, `employee_time_codes` |
| **Session** | Supabase Session | SharedPreferences (24h) |
| **Routes** | `/login`, `/admin`, `/employee`, `/customer` | `/dashboard-login`, `/dashboard` |
| **Rollen** | admin, manager, stylist, employee, customer | admin, employee (nur 2) |
| **Use Case** | Haupt-App für alle User | Internes Dashboard für Salon |

---

## 🚨 WICHTIGE Hinweise

### ⚠️ Parallele Systeme
- Beide Login-Systeme funktionieren **unabhängig** voneinander
- Ein User kann in beiden Systemen eingeloggt sein
- Keine Konflikte, da verschiedene Routes und State

### ⚠️ Kein UI Design ändern
- User hat explizit gesagt: "änder bitte nix am ui"
- Nur Funktionalität implementieren
- Bestehendes UI-Design beibehalten
- Neue Screens: Minimalistisches, funktionales Design

### ⚠️ Security
- Supabase RPC Functions sind SECURITY DEFINER
- Codes werden NICHT im Client gehashed
- Session nur 24h gültig
- Bei Ablauf: Automatischer Logout

---

## ✅ Checkliste Zusammenfassung

### Models & Data (7 Tasks)
- [ ] `dashboard_user.dart` erstellen
- [ ] `dashboard_config.dart` erstellen
- [ ] `dashboard_session.dart` erstellen
- [ ] Code generieren mit build_runner
- [ ] `dashboard_auth_service.dart` erstellen
- [ ] `dashboard_session_service.dart` erstellen
- [ ] Supabase RPC Calls testen

### State Management (2 Tasks)
- [ ] `dashboard_auth_provider.dart` erstellen
- [ ] Auto-Restore Session implementieren

### UI & Navigation (4 Tasks)
- [ ] `dashboard_login_screen.dart` erstellen
- [ ] `dashboard_screen.dart` erstellen
- [ ] Router erweitern (app_router.dart)
- [ ] main.dart anpassen (SharedPreferences)

### Testing (6 Tasks)
- [ ] Salon-Login Test
- [ ] Time-Code Login Test
- [ ] Session Persistence Test
- [ ] Navigation Guards Test
- [ ] Module Config Test
- [ ] Integration Tests

### Cleanup (2 Tasks)
- [ ] Dokumentation aktualisieren
- [ ] Code Review & Refactoring

**TOTAL: 21 Tasks**

---

## 📝 Notizen für Entwickler

1. **PostgreSQL Functions existieren bereits** in Supabase
   - `verify_salon_code(p_salon_id, p_code)`
   - `verify_employee_time_code(p_time_code)`
   - Keine Backend-Änderungen nötig!

2. **Tabellen existieren bereits**
   - `salon_codes`
   - `employee_time_codes`
   - `salon_dashboard_config`

3. **React-Code als Referenz**
   - Siehe `login.md` für vollständige React-Implementierung
   - Logic 1:1 übertragbar auf Flutter

4. **Freezed Code-Generierung**
   - Nach jeder Model-Änderung:
     ```bash
     flutter pub run build_runner build --delete-conflicting-outputs
     ```

5. **Test-Daten in Supabase**
   - Salon ID: `b9fbbe58-3b16-43d3-88af-0570ecd3d653`
   - Salon Code: `123456`
   - Test damit während Entwicklung

---

**🎉 Ende der TODO-Liste**

Diese Dokumentation ist vollständig und kann eigenständig für die Implementierung verwendet werden!
