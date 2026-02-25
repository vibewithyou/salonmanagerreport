# Employee Tabs - Quick Reference Guide

Schnelle Referenz für die 4 neuen Employee Tabs.

---

## 🚀 Schnellstart

### Import alle Tabs
```dart
import 'customers_tab.dart';
import 'portfolio_tab.dart';
import 'past_appointments_tab.dart';
import 'pos_tab_enhanced.dart';
import 'employee_tabs_integration.dart';
```

### Verwende kombiniert
```dart
EmployeeTabsIntegration(
  salonId: 'salon-id',
  employeeId: 'employee-id',
  employeeName: 'Name',
)
```

### Verwende einzeln
```dart
// POS Kasse
POSTabEnhanced(
  salonId: salonId,
  employeeId: employeeId,
)

// Kundenmanagement
CustomersTab(
  salonId: salonId,
)

// Portfolio Galerie
PortfolioTab(
  employeeId: employeeId,
  employeeName: employeeName,
)

// Termin-Historie
PastAppointmentsTab(
  employeeId: employeeId,
)
```

---

## 📱 UI Components Übersicht

### POSTabEnhanced
```
┌─ Service List          │  Cart Panel ─┐
├─ Category Filter       │  Items       ─┤
├─ [Service 1]           │  Subtotal    ─┤
├─ [Service 2]           │  Discount    ─┤
├─ [Service 3]           │  Total       ─┤
│                         │  [Cash][Card]─┤
│                         │  [Checkout]  ─┘
```

### CustomersTab
```
┌─ Search Bar            ┐
├─ [Name] [Visits] [€]   │
├─ [Customer 1] ────────→ Detail Sheet
├─ [Customer 2]    
├─ [Customer 3]         
```

### PortfolioTab
```
┌─ [🟦 🔲] [+]          ┐
├─ ┌─┐ ┌─┐ ┌─┐         
├─ │1│ │2│ │3│ ──────→ Lightbox
├─ ├─┤ ├─┤ ├─┤
├─ │4│ │5│ │6│
```

### PastAppointmentsTab
```
┌─ [📅 Date Range] [30T]─┐
├─ [Alle] [✓] [✗] [⏱]   │
├─ Statistics Card       │
├─ [Appointment 1] ────→ Details
├─ [Appointment 2]
```

---

## 🔌 Riverpod Providers

### POS Tab
```dart
// Laden von Services
final services = ref.watch(salonServicesProvider(salonId));

// Cache invalidieren
ref.read(employeeDashboardCacheProvider.notifier).refreshSalonServices(salonId);
```

### Customers Tab
```dart
// Laden von Customers
final customers = ref.watch(salonCustomersProvider(salonId));

// Laden von Customer Details
final customer = ref.watch(customerWithHistoryProvider(customerId));

// Cache invalidieren
ref.read(employeeDashboardCacheProvider.notifier).refreshSalonCustomers(salonId);
```

### Portfolio Tab
```dart
// Laden von Portfolio Images
final portfolio = ref.watch(employeePortfolioProvider(employeeId));

// Mit Tags
final portfolioWithTags = ref.watch(employeePortfolioWithTagsProvider(employeeId));

// Cache invalidieren
ref.read(employeeDashboardCacheProvider.notifier).refreshEmployeePortfolio(employeeId);
```

### Past Appointments Tab
```dart
// Laden von Past Appointments (limit 50)
final appointments = ref.watch(pastAppointmentsProvider((employeeId, 50)));

// Laden von Statistiken
final stats = ref.watch(appointmentStatisticsProvider(employeeId));

// Cache invalidieren
ref.read(employeeDashboardCacheProvider.notifier).refreshPastAppointments(employeeId, 50);
ref.read(employeeDashboardCacheProvider.notifier).refreshAppointmentStatistics(employeeId);
```

---

## 🎨 Theme Constants

### Farben
```dart
// Gold Theme
AppColors.gold          // #CC9933 (Primary)
Colors.black            // Background
Colors.grey[900]        // Cards
Colors.white            // Primary Text
Colors.white70          // Secondary Text

// Status Farben
Colors.green            // Completed/Success
Colors.red              // Cancelled/Error
Colors.orange           // Pending
Colors.blue             // Confirmed
```

### Spacing
```dart
const EdgeInsets.all(16)                    // Standard Padding
const EdgeInsets.symmetric(horizontal: 16)  // Horizontal
const EdgeInsets.only(bottom: 12)          // Specific
const SizedBox(height: 12)                  // Spacing
```

### Border Radius
```dart
BorderRadius.circular(12)           // Standard
BorderRadius.circular(8)            // Small
BorderRadius.circular(16)           // Large
BorderRadius.vertical(top: Radius.circular(20))
```

---

## 📊 Data Models

### POS
```dart
SalonServiceDto {
  String id,
  String salonId,
  String name,
  String? description,
  int durationMinutes,
  double price,
  String? category,
}

CartItem {
  SalonServiceDto service,
  int quantity,
  double get total => service.price * quantity,
}
```

### Customers
```dart
SalonCustomerDto {
  String id,
  String salonId,
  String firstName,
  String lastName,
  String? phone,
  String? email,
  DateTime createdAt,
  DateTime updatedAt,
  List<AppointmentSummaryDto> appointments,
  double totalSpending,
  DateTime? lastVisitDate,
}
```

### Portfolio
```dart
EmployeePortfolioImageDto {
  String id,
  String employeeId,
  String imageUrl,
  String? caption,
  DateTime createdAt,
  String? color,        // Hex: #RRGGBB
  String? hairstyle,
}
```

### Past Appointments
```dart
PastAppointmentDto {
  String id,
  String? customerProfileId,
  String? guestName,
  String? guestEmail,
  String? serviceId,
  DateTime startTime,
  String status,        // completed, cancelled, pending, confirmed
  double? price,
  String? appointmentNumber,
}

AppointmentStatisticsDto {
  int totalAppointments,
  int totalCompleted,
  int totalCancelled,
  double totalRevenue,
  double completionRate,
}
```

---

## 🎯 Common Tasks

### POS: Artikel hinzufügen
```dart
void _addToCart(SalonServiceDto service) {
  final existingIndex = _cartItems.indexWhere((item) => item.service.id == service.id);
  if (existingIndex >= 0) {
    _cartItems[existingIndex].quantity++;
  } else {
    _cartItems.add(CartItem(service: service, quantity: 1));
  }
  setState(() {}); // Aktualisierung
}
```

### POS: Total berechnen
```dart
double _calculateTotal() {
  final subtotal = _cartItems.fold(0, (sum, item) => sum + item.total);
  final discount = subtotal * (_discountPercent / 100);
  return subtotal - discount;
}
```

### Customers: Search filtern
```dart
void _filterCustomers() {
  final query = _searchController.text.toLowerCase().trim();
  _filteredCustomers = customers.where((customer) {
    final name = '${customer.firstName} ${customer.lastName}'.toLowerCase();
    return name.contains(query) || customer.email?.contains(query) == true;
  }).toList();
}
```

### Customers: Sort
```dart
void _sortCustomers() {
  switch (_sortBy) {
    case 'visits':
      _filteredCustomers.sort((a, b) => b.appointments.length.compareTo(a.appointments.length));
      break;
    case 'spending':
      _filteredCustomers.sort((a, b) => b.totalSpending.compareTo(a.totalSpending));
      break;
    case 'name':
    default:
      _filteredCustomers.sort((a, b) => 
        '${a.firstName} ${a.lastName}'.compareTo('${b.firstName} ${b.lastName}')
      );
  }
}
```

### Portfolio: Grid Toggle
```dart
void _toggleGridSize(int columns) {
  setState(() {
    _gridColumnCount = columns;
  });
}

// Usage in GridView
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: _gridColumnCount, // 2 oder 3
  ),
)
```

### Past Appointments: Date Range Filter
```dart
void _filterAppointments(List<PastAppointmentDto> appointments) {
  _filteredAppointments = appointments.where((apt) {
    final isInRange = apt.startTime.isAfter(_dateRange.start) &&
                      apt.startTime.isBefore(_dateRange.end.add(Duration(days: 1)));
    
    if (!isInRange) return false;
    
    if (_filterStatus != 'all' && apt.status != _filterStatus) {
      return false;
    }
    
    return true;
  }).toList();
  
  // Sort by newest first
  _filteredAppointments.sort((a, b) => b.startTime.compareTo(a.startTime));
}
```

### Past Appointments: Quick Date Range
```dart
void _setQuickDateRange(int days) {
  final now = DateTime.now();
  setState(() {
    _dateRange = DateTimeRange(
      start: now.subtract(Duration(days: days)),
      end: now,
    );
  });
}
```

---

## ⚠️ Error Handling Pattern

### Alle Widgets nutzen dieses Pattern
```dart
// Watch Provider
final dataAsync = ref.watch(provider);

// Handle States
return dataAsync.when(
  data: (data) {
    // Render UI mit Daten
    return SizedBox(/*...*/);
  },
  loading: () {
    return Center(child: CircularProgressIndicator());
  },
  error: (error, stackTrace) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.alertCircle, size: 48, color: AppColors.error),
          const SizedBox(height: 16),
          const Text('Fehler beim Laden'),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              ref.refresh(provider); // Retry
            },
            icon: const Icon(LucideIcons.rotationCw),
            label: const Text('Erneut versuchen'),
          ),
        ],
      ),
    );
  },
);
```

---

## 🔍 State Management Pattern

### StatefulWidget Pattern (Lokal)
```dart
class MyTab extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyTab> createState() => _MyTabState();
}

class _MyTabState extends ConsumerState<MyTab> {
  // Local state (nicht in Riverpod)
  String _filterValue = '';
  
  @override
  void initState() {
    super.initState();
    // Initialisierung
  }
  
  @override
  void dispose() {
    // Cleanup
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // Mit Riverpod Providers kombinieren
    final data = ref.watch(myProvider);
    return data.when(/*...*/);
  }
}
```

---

## 📱 Responsive Design Pattern

Alle Widgets sind responsive für:
- ✅ Phone (360px - 600px)
- ✅ Tablet (600px - 1200px)
- ✅ Desktop (1200px+)

### Responsive Row Layout
```dart
Row(
  children: [
    Expanded(flex: 2, child: LeftPanel()),  // 66%
    Expanded(flex: 1, child: RightPanel()),  // 34%
  ],
)

// oder mit Breakpoints
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth < 600) {
      return SingleChildScrollView(child: Column(/*...*/));
    } else {
      return Row(children: [/*...*/]);
    }
  },
)
```

---

## 🎬 Animation Pattern

```dart
// Fade In Animation für Cards
AnimatedOpacity(
  opacity: _isVisible ? 1 : 0,
  duration: const Duration(milliseconds: 300),
  child: Card(/*...*/),
)

// Slide Animation für Sheet
SlideTransition(
  position: _animation,
  child: Container(/*...*/),
)
```

---

## 🧪 Widget Testing Template

```dart
testWidgets('CustomersTab renders customer list', (tester) async {
  await tester.pumpWidget(
    ProviderContainer(
      overrides: [
        salonCustomersProvider.overrideWithValue(
          AsyncValue.data(mockCustomers),
        ),
      ],
      child: MaterialApp(home: CustomersTab(salonId: 'test')),
    ),
  );
  
  expect(find.byType(Card), findsWidgets);
  expect(find.text('Anna Müller'), findsOneWidget);
});
```

---

## 🐛 Debugging Tipps

### Riverpod State Anschauen
```dart
// In Flutter DevTools Console
> ref.read(salonServicesProvider('salon-id'))
> await ref.read(salonServicesProvider('salon-id').future)
```

### Provider Refresh
```dart
// Manuell im Code
ref.refresh(salonServicesProvider(widget.salonId))

// Via DevTools
// Tools > Riverpod DevTools > Invalidate Provider
```

### State Logging
```dart
final debugProvider = FutureProvider((ref) async {
  print('Loading...');
  final data = await repository.getData();
  print('Loaded: $data');
  return data;
});
```

---

## 📚 Nützliche Links

- [Flutter Docs](https://flutter.dev/docs)
- [Riverpod Docs](https://riverpod.dev)
- [Material 3](https://m3.material.io)
- [Lucide Icons](https://lucide.dev)

---

## 📝 File Referenzen

| Datei | Zeilen | Widgets |
|-------|--------|---------|
| `pos_tab_enhanced.dart` | 853 | POSTabEnhanced, CartItem |
| `customers_tab.dart` | 745 | CustomersTab, _CustomerCard |
| `portfolio_tab.dart` | 703 | PortfolioTab, _ImageLightbox |
| `past_appointments_tab.dart` | 965 | PastAppointmentsTab, DatePicker |
| `employee_tabs_integration.dart` | 377 | EmployeeTabsIntegration |

---

## ✨ Pro Tips

1. **Nutze Riverpod DevTools** zur Debugging
2. **Teste mit Mock Data** vor echter API Integration
3. **Profile Code** mit Flutter DevTools für Performance
4. **Nutze `.select()`** für Fine-grained Updates
5. **Implementiere Offline Mode** via Hive Cache (Phase 2)

---

Viel Erfolg! 🚀
