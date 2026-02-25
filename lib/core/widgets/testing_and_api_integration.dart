import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

// ============================================================================
// UNIT TEST HELPERS
// ============================================================================

/// Base test helper for component testing
void testComponent(String description, WidgetTester Function(WidgetTester) test) {
  testWidgets(description, (WidgetTester tester) async {
    await test(tester);
  });
}

// ============================================================================
// RIVERPOD PROVIDERS FOR STATE MANAGEMENT
// ============================================================================

/// Time Tracking Provider
/// Tracks employee clock in/out times and duration
final employeeTimeProvider = StreamProvider.family<EmployeeTimeData, String>((ref, employeeId) {
  // Stream of time tracking updates
  return _getEmployeeTimeStream(employeeId);
});

/// Booking Data Provider
/// Manages booking wizard state through 7 steps
final bookingDataProvider = StateNotifierProvider((ref) {
  return BookingDataNotifier();
});

/// Appointments Provider
/// Real-time appointments for employee dashboard
final appointmentsProvider = StreamProvider<List<AppointmentData>>((ref) {
  return _getAppointmentsStream();
});

/// Gallery Images Provider
/// Fetches and manages gallery images with filtering
final galleryImagesProvider = StateNotifierProvider((ref) {
  return GalleryImagesNotifier();
});

/// POS Cart Provider
/// Manages shopping cart state for POS terminal
final cartProvider = StateNotifierProvider((ref) {
  return CartNotifier();
});

/// Chat Messages Provider
/// Real-time chat messages for selected conversation
final chatMessagesProvider = StreamProvider.family<List<ChatMessageData>, String>((ref, conversationId) {
  return _getChatMessagesStream(conversationId);
});

/// User Authentication Provider
/// Manages login state and user data
final authProvider = StateNotifierProvider((ref) {
  return AuthNotifier();
});

// ============================================================================
// STATE NOTIFIERS
// ============================================================================

class BookingDataNotifier extends StateNotifier<BookingData> {
  BookingDataNotifier() : super(BookingData());

  void updateSalon(String salonId) {
    state = state.copyWith(salonId: salonId);
  }

  void updateService(String serviceId) {
    state = state.copyWith(serviceId: serviceId);
  }

  void updateEmployee(String employeeId) {
    state = state.copyWith(employeeId: employeeId);
  }

  void updateDateTime(DateTime date, String time) {
    state = state.copyWith(selectedDate: date, selectedTime: time);
  }

  void updateCustomerInfo(String name, String email, String phone) {
    state = state.copyWith(
      customerName: name,
      customerEmail: email,
      customerPhone: phone,
    );
  }

  void updateNotes(String notes) {
    state = state.copyWith(notes: notes);
  }

  void reset() {
    state = BookingData();
  }
}

class GalleryImagesNotifier extends StateNotifier<List<GalleryImageData>> {
  GalleryImagesNotifier() : super([]);

  Future<void> loadImages() async {
    // Load from Supabase
    final images = await _fetchGalleryImages();
    state = images;
  }

  void filterByTag(String tag) {
    // Filter implementation
  }

  Future<void> uploadImage(String title, List<String> tags) async {
    // Upload to Supabase storage
  }
}

class CartNotifier extends StateNotifier<List<CartItemData>> {
  CartNotifier() : super([]);

  void addItem(String productId, String name, double price) {
    final existingIndex = state.indexWhere((item) => item.productId == productId);
    if (existingIndex >= 0) {
      final updated = [...state];
      updated[existingIndex] = updated[existingIndex].copyWith(
        quantity: updated[existingIndex].quantity + 1,
      );
      state = updated;
    } else {
      state = [
        ...state,
        CartItemData(
          productId: productId,
          name: name,
          price: price,
          quantity: 1,
        ),
      ];
    }
  }

  void updateQuantity(String productId, int quantity) {
    final updated = state.map((item) {
      return item.productId == productId
          ? item.copyWith(quantity: quantity)
          : item;
    }).toList();
    state = updated;
  }

  void removeItem(String productId) {
    state = state.where((item) => item.productId != productId).toList();
  }

  double getSubtotal() {
    return state.fold<double>(0, (sum, item) => sum + (item.price * item.quantity));
  }

  double getTotal() {
    final subtotal = getSubtotal();
    return subtotal * 1.1; // 10% tax
  }

  void checkout(String paymentMethod) {
    // Process checkout
    state = [];
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState.unauthenticated());

  Future<void> login(String email, String password) async {
    state = const AuthState.loading();
    try {
      // Supabase login
      final user = await _supabaseLogin(email, password);
      state = AuthState.authenticated(user: user);
    } catch (e) {
      state = AuthState.error(message: e.toString());
    }
  }

  Future<void> logout() async {
    state = const AuthState.unauthenticated();
    // Supabase logout
  }
}

// ============================================================================
// DATA MODELS
// ============================================================================

class BookingData {
  final String? salonId;
  final String? serviceId;
  final String? employeeId;
  final DateTime? selectedDate;
  final String? selectedTime;
  final String? customerName;
  final String? customerEmail;
  final String? customerPhone;
  final String? notes;
  final List<String> photoUrls;

  BookingData({
    this.salonId,
    this.serviceId,
    this.employeeId,
    this.selectedDate,
    this.selectedTime,
    this.customerName,
    this.customerEmail,
    this.customerPhone,
    this.notes,
    this.photoUrls = const [],
  });

  BookingData copyWith({
    String? salonId,
    String? serviceId,
    String? employeeId,
    DateTime? selectedDate,
    String? selectedTime,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    String? notes,
    List<String>? photoUrls,
  }) {
    return BookingData(
      salonId: salonId ?? this.salonId,
      serviceId: serviceId ?? this.serviceId,
      employeeId: employeeId ?? this.employeeId,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerPhone: customerPhone ?? this.customerPhone,
      notes: notes ?? this.notes,
      photoUrls: photoUrls ?? this.photoUrls,
    );
  }
}

class EmployeeTimeData {
  final String employeeId;
  final DateTime clockInTime;
  final DateTime? clockOutTime;
  final Duration totalDuration;
  final bool isActive;

  EmployeeTimeData({
    required this.employeeId,
    required this.clockInTime,
    this.clockOutTime,
    required this.totalDuration,
    required this.isActive,
  });
}

class AppointmentData {
  final String id;
  final String customerName;
  final String serviceType;
  final DateTime appointmentTime;
  final Duration duration;
  final String status; // confirmed, pending, completed, cancelled
  final String employeeName;

  AppointmentData({
    required this.id,
    required this.customerName,
    required this.serviceType,
    required this.appointmentTime,
    required this.duration,
    required this.status,
    required this.employeeName,
  });
}

class GalleryImageData {
  final String id;
  final String url;
  final String title;
  final List<String> tags;
  final int likes;
  final int comments;
  final String uploadedBy;
  final DateTime uploadedAt;

  GalleryImageData({
    required this.id,
    required this.url,
    required this.title,
    required this.tags,
    required this.likes,
    required this.comments,
    required this.uploadedBy,
    required this.uploadedAt,
  });
}

class CartItemData {
  final String productId;
  final String name;
  final double price;
  final int quantity;

  CartItemData({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
  });

  CartItemData copyWith({
    String? productId,
    String? name,
    double? price,
    int? quantity,
  }) {
    return CartItemData(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}

class ChatMessageData {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderName;
  final String content;
  final DateTime timestamp;
  final String type; // text, image, file, voice

  ChatMessageData({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.timestamp,
    required this.type,
  });
}

sealed class AuthState {
  const AuthState();

  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated({required UserData user}) = _Authenticated;
  const factory AuthState.error({required String message}) = _Error;
}

class _Unauthenticated extends AuthState {
  const _Unauthenticated();
}

class _Loading extends AuthState {
  const _Loading();
}

class _Authenticated extends AuthState {
  final UserData user;
  const _Authenticated({required this.user});
}

class _Error extends AuthState {
  final String message;
  const _Error({required this.message});
}

class UserData {
  final String id;
  final String email;
  final String name;
  final String role;

  UserData({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });
}

// ============================================================================
// SUPABASE API INTEGRATION
// ============================================================================

/// Supabase Authentication
Future<UserData> _supabaseLogin(String email, String password) async {
  // TODO: Implement Supabase auth.signInWithPassword
  // Example: await supabase.auth.signInWithPassword(email: email, password: password);
  throw UnimplementedError('Supabase login not implemented');
}

/// Time Tracking Stream
Stream<EmployeeTimeData> _getEmployeeTimeStream(String employeeId) async* {
  // TODO: Implement Supabase realtime subscription to time_entries table
  // Example: supabase.from('time_entries').stream(primaryKey: ['id'])
  yield EmployeeTimeData(
    employeeId: employeeId,
    clockInTime: DateTime.now(),
    totalDuration: Duration.zero,
    isActive: true,
  );
}

/// Appointments Stream
Stream<List<AppointmentData>> _getAppointmentsStream() async* {
  // TODO: Implement Supabase realtime subscription to appointments table
  // Filter by today's date and employee_id
  yield [];
}

/// Gallery Images Fetch
Future<List<GalleryImageData>> _fetchGalleryImages() async {
  // TODO: Implement Supabase query to gallery_images table
  // With pagination and filtering support
  return [];
}

/// Chat Messages Stream
Stream<List<ChatMessageData>> _getChatMessagesStream(String conversationId) async* {
  // TODO: Implement Supabase realtime subscription to chat_messages table
  // Filtered by conversation_id, ordered by timestamp DESC
  yield [];
}

// ============================================================================
// UNIT TEST EXAMPLES
// ============================================================================

void runTests() {
  group('BookingData Unit Tests', () {
    test('copyWith preserves values', () {
      final data = BookingData(salonId: '1', serviceId: '2');
      final updated = data.copyWith(employeeId: '3');

      expect(updated.salonId, '1');
      expect(updated.serviceId, '2');
      expect(updated.employeeId, '3');
    });

    test('BookingDataNotifier updates state', () {
      final notifier = BookingDataNotifier();

      notifier.updateSalon('salon-1');
      expect(notifier.debugState.salonId, 'salon-1');

      notifier.updateService('service-1');
      expect(notifier.debugState.serviceId, 'service-1');
    });
  });

  group('CartNotifier Unit Tests', () {
    test('addItem increases quantity for existing product', () {
      final notifier = CartNotifier();

      notifier.addItem('p1', 'Product 1', 10.0);
      notifier.addItem('p1', 'Product 1', 10.0);

      expect(notifier.debugState.length, 1);
      expect(notifier.debugState[0].quantity, 2);
    });

    test('addItem creates new cart item', () {
      final notifier = CartNotifier();

      notifier.addItem('p1', 'Product 1', 10.0);
      notifier.addItem('p2', 'Product 2', 20.0);

      expect(notifier.debugState.length, 2);
    });

    test('getTotal includes 10% tax', () {
      final notifier = CartNotifier();

      notifier.addItem('p1', 'Product 1', 100.0);
      final total = notifier.getTotal();

      expect(total, 110.0); // 100 + 10% tax
    });

    test('removeItem deletes product from cart', () {
      final notifier = CartNotifier();

      notifier.addItem('p1', 'Product 1', 10.0);
      notifier.addItem('p2', 'Product 2', 20.0);
      notifier.removeItem('p1');

      expect(notifier.debugState.length, 1);
      expect(notifier.debugState[0].productId, 'p2');
    });

    test('checkout clears cart', () {
      final notifier = CartNotifier();

      notifier.addItem('p1', 'Product 1', 10.0);
      notifier.checkout('card');

      expect(notifier.debugState.isEmpty, true);
    });
  });

  group('EmployeeTimeData Unit Tests', () {
    test('duration calculation works', () {
      final clockIn = DateTime(2024, 1, 1, 8, 0);
      final clockOut = DateTime(2024, 1, 1, 17, 0);

      final timeData = EmployeeTimeData(
        employeeId: 'emp-1',
        clockInTime: clockIn,
        clockOutTime: clockOut,
        totalDuration: clockOut.difference(clockIn),
        isActive: false,
      );

      expect(timeData.totalDuration.inHours, 9);
    });
  });

  group('CartItemData Unit Tests', () {
    test('copyWith updates quantity', () {
      final item = CartItemData(
        productId: 'p1',
        name: 'Product',
        price: 10.0,
        quantity: 1,
      );

      final updated = item.copyWith(quantity: 5);

      expect(updated.quantity, 5);
      expect(updated.productId, 'p1');
    });
  });
}

// ============================================================================
// WIDGET TEST EXAMPLES
// ============================================================================

void runWidgetTests() {
  group('AppButton Widget Tests', () {
    testWidgets('Button renders correctly', (WidgetTester tester) async {
      // TODO: Build AppButton widget and verify
      // - Button text displays
      // - Button colors are correct
      // - Button responds to taps
      // - Loading state shows spinner
      // - Disabled state prevents interaction
    });
  });

  group('AppInput Widget Tests', () {
    testWidgets('Input field accepts text', (WidgetTester tester) async {
      // TODO: Build AppInput widget and verify
      // - Text input works
      // - Error state displays correctly
      // - Focus management works
      // - Validation callbacks trigger
    });
  });

  group('BookingWizard Widget Tests', () {
    testWidgets('Wizard navigates through steps', (WidgetTester tester) async {
      // TODO: Build BookingWizardScreen and verify
      // - Initial step renders
      // - Next button advances to next step
      // - Previous button goes back
      // - Progress indicator updates
      // - Final step shows summary
    });
  });
}

// ============================================================================
// ERROR HANDLING & LOADING STATES
// ============================================================================

/// Widget for handling async data with loading/error states
class AsyncDataBuilder<T> extends StatelessWidget {
  final AsyncValue<T> asyncValue;
  final Widget Function(T data) builder;
  final Widget Function(Object error, StackTrace stackTrace)? errorBuilder;
  final Widget? loadingBuilder;

  const AsyncDataBuilder({
    Key? key,
    required this.asyncValue,
    required this.builder,
    this.errorBuilder,
    this.loadingBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return asyncValue.when(
      data: builder,
      loading: () => loadingBuilder ?? _buildLoadingState(context),
      error: (error, stack) =>
          errorBuilder?.call(error, stack) ??
          _buildErrorState(context, error),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text('Error: ${error.toString()}'),
        ],
      ),
    );
  }
}

/// Skeleton screen loader
class SkeletonLoading extends StatefulWidget {
  final List<SkeletonItem> items;

  const SkeletonLoading({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  State<SkeletonLoading> createState() => _SkeletonLoadingState();
}

class _SkeletonLoadingState extends State<SkeletonLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.items
          .map((item) => _SkeletonItem(
                animation: _controller,
                item: item,
              ))
          .toList(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _SkeletonItem extends StatelessWidget {
  final AnimationController animation;
  final SkeletonItem item;

  const _SkeletonItem({
    required this.animation,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.3, end: 0.7).animate(animation),
      child: Container(
        width: item.width,
        height: item.height,
        margin: item.margin,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(item.borderRadius),
        ),
      ),
    );
  }
}

class SkeletonItem {
  final double width;
  final double height;
  final EdgeInsets margin;
  final double borderRadius;

  SkeletonItem({
    this.width = double.infinity,
    this.height = 16,
    this.margin = const EdgeInsets.all(8),
    this.borderRadius = 8,
  });
}
