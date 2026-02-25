import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import 'customers_tab.dart';
import 'portfolio_tab.dart';
import 'past_appointments_tab.dart';
import 'pos_tab_enhanced.dart';

/// EmployeeTabsIntegration - combines all 4 employee tabs
/// Used within an Employee Dashboard with TabView
/// 
/// Example Usage:
/// ```dart
/// TabBarView(
///   controller: tabController,
///   children: [
///     EmployeeTabsIntegration(
///       salonId: 'salon-id',
///       employeeId: 'employee-id',
///       employeeName: 'John Doe',
///     ),
///   ],
/// )
/// ```

class EmployeeTabsIntegration extends ConsumerStatefulWidget {
  final String salonId;
  final String employeeId;
  final String? employeeName;

  const EmployeeTabsIntegration({
    required this.salonId,
    required this.employeeId,
    this.employeeName,
    super.key,
  });

  @override
  ConsumerState<EmployeeTabsIntegration> createState() =>
      _EmployeeTabsIntegrationState();
}

class _EmployeeTabsIntegrationState
    extends ConsumerState<EmployeeTabsIntegration>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        automaticallyImplyLeading: false,
        title: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.gold, Colors.amber.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Mitarbeiter Tools',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: AppColors.gold,
            labelColor: AppColors.gold,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(
                icon: Icon(LucideIcons.creditCard),
                text: 'Kasse',
              ),
              Tab(
                icon: Icon(LucideIcons.users),
                text: 'Kunden',
              ),
              Tab(
                icon: Icon(LucideIcons.image),
                text: 'Portfolio',
              ),
              Tab(
                icon: Icon(LucideIcons.history),
                text: 'Historie',
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // POS Tab
          POSTabEnhanced(
            salonId: widget.salonId,
            employeeId: widget.employeeId,
          ),

          // Customers Tab
          CustomersTab(
            salonId: widget.salonId,
          ),

          // Portfolio Tab
          PortfolioTab(
            employeeId: widget.employeeId,
            employeeName: widget.employeeName,
          ),

          // Past Appointments Tab
          PastAppointmentsTab(
            employeeId: widget.employeeId,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// EXAMPLE FULL SCREEN USAGE
// ============================================================================

/// Example of how to integrate this into a full Employee Dashboard
class EmployeeDashboardWithTabs extends ConsumerStatefulWidget {
  const EmployeeDashboardWithTabs({super.key});

  @override
  ConsumerState<EmployeeDashboardWithTabs> createState() =>
      _EmployeeDashboardWithTabsState();
}

class _EmployeeDashboardWithTabsState
    extends ConsumerState<EmployeeDashboardWithTabs>
    with SingleTickerProviderStateMixin {
  late TabController _mainTabController;

  @override
  void initState() {
    super.initState();
    // 5 main sections: Appointments, Time Tracking, Check-in, Leave, Schedule, AND new Tools
    _mainTabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _mainTabController.dispose();
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
              colors: [AppColors.gold, Colors.amber.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Mitarbeiter Dashboard',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        bottom: TabBar(
          controller: _mainTabController,
          isScrollable: true,
          indicatorColor: AppColors.gold,
          labelColor: AppColors.gold,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(icon: Icon(LucideIcons.calendar), text: 'Termine'),
            Tab(icon: Icon(LucideIcons.clock), text: 'Zeit'),
            Tab(icon: Icon(LucideIcons.qrCode), text: 'Check-in'),
            Tab(icon: Icon(LucideIcons.palmtree), text: 'Urlaub'),
            Tab(icon: Icon(LucideIcons.calendarDays), text: 'Dienstplan'),
            Tab(icon: Icon(LucideIcons.store), text: 'Tools'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _mainTabController,
        children: [
          // Meine Termine
          Container(
            color: Colors.black,
            child: const Center(
              child: Text(
                'Termine Tab\n(bereits implementiert)',
                style: TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Zeiterfassung
          Container(
            color: Colors.black,
            child: const Center(
              child: Text(
                'Zeiterfassung Tab\n(bereits implementiert)',
                style: TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // QR Check-in
          Container(
            color: Colors.black,
            child: const Center(
              child: Text(
                'QR Check-in Tab\n(bereits implementiert)',
                style: TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Urlaubsanträge
          Container(
            color: Colors.black,
            child: const Center(
              child: Text(
                'Urlaubsanträge Tab\n(bereits implementiert)',
                style: TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Dienstplan
          Container(
            color: Colors.black,
            child: const Center(
              child: Text(
                'Dienstplan Tab\n(bereits implementiert)',
                style: TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // NEW: Tools (POS + Customers + Portfolio + History)
          EmployeeTabsIntegration(
            salonId: 'salon-123', // Pass actual salon ID
            employeeId: 'employee-123', // Pass actual employee ID
            employeeName: 'Max Mustermann',
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// ROUTING CONFIGURATION EXAMPLE
// ============================================================================

/// Add these routes to your GoRouter configuration
/// 
/// Example:
/// ```dart
/// GoRoute(
///   path: '/employee/tools',
///   builder: (context, state) => const EmployeeTabsIntegration(
///     salonId: state.pathParameters['salonId'] ?? '',
///     employeeId: state.pathParameters['employeeId'] ?? '',
///   ),
/// ),
/// ```

// ============================================================================
// TESTING REFERENCE DATA
// ============================================================================

/// Mock data for testing (in lib/utils/mock_data.dart)
/// 
/// ```dart
/// final mockServices = [
///   SalonServiceDto(
///     id: '1',
///     salonId: 'salon-1',
///     name: 'Haarschnitt',
///     description: 'Klassischer Schnitt',
///     durationMinutes: 30,
///     price: 35.0,
///     category: 'Haarschnitt',
///   ),
///   // ... more services
/// ];
///
/// final mockCustomers = [
///   SalonCustomerDto(
///     id: '1',
///     salonId: 'salon-1',
///     firstName: 'Anna',
///     lastName: 'Müller',
///     email: 'anna@example.com',
///     phone: '+49 123 456789',
///     createdAt: DateTime.now().subtract(Duration(days: 30)),
///     updatedAt: DateTime.now(),
///     totalSpending: 250.0,
///     lastVisitDate: DateTime.now().subtract(Duration(days: 7)),
///   ),
///   // ... more customers
/// ];
///
/// final mockPortfolioImages = [
///   EmployeePortfolioImageDto(
///     id: '1',
///     employeeId: 'emp-1',
///     imageUrl: 'https://example.com/image1.jpg',
///     caption: 'Blonde Highlights',
///     createdAt: DateTime.now(),
///     color: '#FFD700',
///     hairstyle: 'Highlights',
///   ),
///   // ... more images
/// ];
///
/// final mockPastAppointments = [
///   PastAppointmentDto(
///     id: '1',
///     customerProfileId: 'cust-1',
///     guestName: 'Anna Müller',
///     guestEmail: 'anna@example.com',
///     serviceId: 'svc-1',
///     startTime: DateTime.now().subtract(Duration(days: 2)),
///     status: 'completed',
///     price: 45.0,
///     appointmentNumber: 'APT-001',
///   ),
///   // ... more appointments
/// ];
/// ```
