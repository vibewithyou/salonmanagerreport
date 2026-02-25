# Flutter SalonManager Skill

**Version:** 1.0  
**Created:** 15.02.2026  
**Target:** Migration from React Vite to Flutter with Supabase Backend

---

## 🎯 PROJECT OVERVIEW

This skill provides comprehensive guidance for migrating and building the **SalonManager** application in Flutter. The original React Vite application is a fully-featured salon management platform with:

- **Multi-role system**: Customer, Employee, Admin, Owner
- **Booking system** with wizard, availability, calendar
- **Gallery module** with Instagram-like features and AI-powered hairstyle suggestions
- **Real-time chat** between customers and staff
- **POS system** for point of sale
- **Time tracking** with NFC clock-in/out
- **Inventory management** with auto-orders
- **CRM & Loyalty** program
- **Compliance features** (GDPR, DATEV export)
- **Google Maps integration** for salon discovery
- **Multi-salon support** with salon switching

---

## 📚 ARCHITECTURE PATTERNS

### Current React Vite Architecture

```
src/
├── components/          # Reusable UI components
│   ├── admin/          # Admin-specific components
│   ├── booking/        # Booking wizard components
│   ├── calendar/       # Calendar views
│   ├── dashboard/      # Dashboard tabs and widgets
│   ├── gallery/        # Gallery and AI suggestions
│   ├── maps/           # Google Maps integration
│   ├── pos/            # Point of Sale
│   └── ui/             # shadcn/ui components
├── contexts/           # React Context (Auth, Theme, UserRole)
├── hooks/              # Custom hooks for data fetching
├── pages/              # Route-level pages
├── services/           # API services (Supabase, etc.)
└── integrations/       # Supabase client setup
```

### Target Flutter Architecture

```
lib/
├── core/
│   ├── constants/      # App colors, text styles, etc.
│   ├── theme/          # Light/Dark theme configuration
│   ├── utils/          # Helper functions
│   └── config/         # Supabase, environment config
├── features/           # Feature-based architecture
│   ├── auth/          
│   │   ├── data/       # Repositories, data sources
│   │   ├── domain/     # Entities, use cases
│   │   └── presentation/ # UI, providers, screens
│   ├── booking/
│   ├── gallery/
│   ├── dashboard/
│   ├── pos/
│   └── ...
├── models/             # Shared data models (Freezed)├── providers/          # Riverpod providers (global state)
├── services/           # API services, Supabase client
├── widgets/            # Shared widgets
├── navigation/         # GoRouter configuration
└── main.dart

```

**Key Principle**: Feature-first architecture with clean separation of concerns.

---

## 🏗️ STATE MANAGEMENT WITH RIVERPOD

### Pattern Overview

The React app uses **React Context + TanStack Query** for state management:
- `AuthContext` for authentication
- `ThemeContext` for theme switching
- `useQuery` hooks for data fetching with caching

Flutter equivalent uses **Riverpod** with similar patterns:
- `authProvider` for authentication state
- `themeProvider` for theme mode
- `FutureProvider` / `StreamProvider` for async data

### Example Migration Pattern

**React (TanStack Query):**
```typescript
// hooks/useSalons.ts
export const useSalons = () => {
  return useQuery({
    queryKey: ['salons'],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('salons')
        .select('*')
        .eq('is_active', true);
      if (error) throw error;
      return data;
    }
  });
};
```

**Flutter (Riverpod):**
```dart
// providers/salon_provider.dart
final salonsProvider = FutureProvider<List<Salon>>((ref) async {
  final supabase = ref.watch(supabaseClientProvider);
  final response = await supabase
      .from('salons')
      .select()
      .eq('is_active', true);
  
  if (response == null) throw Exception('Failed to fetch salons');
  
  return (response as List)
      .map((json) => Salon.fromJson(json))
      .toList();
});

// Usage in widget:
final salonsAsync = ref.watch(salonsProvider);

return salonsAsync.when(
  data: (salons) => SalonList(salons: salons),
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => ErrorWidget(error),
);
```

### Provider Types Reference

| React Pattern | Flutter Riverpod Equivalent | Use Case |
|--------------|----------------------------|----------|
| `useState` | `StateProvider<T>` | Simple local state |
| `useContext` | `Provider<T>` | Global immutable state |
| `useQuery` (fetch once) | `FutureProvider<T>` | One-time async data |
| `useQuery` (realtime) | `StreamProvider<T>` | Realtime Supabase data |
| `useMutation` | `StateNotifierProvider<T>` | Complex state with mutations |
| Custom Hook | `Provider` + `ref.watch` | Computed/derived state |

---

## 🗄️ SUPABASE INTEGRATION

### Setup Pattern

**React:**
```typescript
// integrations/supabase/client.ts
import { createClient } from '@supabase/supabase-js';

export const supabase = createClient(
  import.meta.env.VITE_SUPABASE_URL,
  import.meta.env.VITE_SUPABASE_ANON_KEY
);
```

**Flutter:**
```dart
// core/config/supabase_config.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConfig {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );
  }
  
  static SupabaseClient get client => Supabase.instance.client;
}

// Riverpod provider:
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return SupabaseConfig.client;
});
```

### Authentication Pattern

**React:**
```typescript
// contexts/AuthContext.tsx
const { data: { session } } = await supabase.auth.getSession();
const { data, error } = await supabase.auth.signInWithPassword({
  email, password
});
```

**Flutter:**
```dart
// features/auth/data/auth_repository.dart
class AuthRepository {
  final SupabaseClient _supabase;
  
  AuthRepository(this._supabase);
  
  Stream<AuthState> get authStateChanges => 
    _supabase.auth.onAuthStateChange.map((data) {
      return data.session != null 
        ? AuthState.authenticated(data.session!.user)
        : AuthState.unauthenticated();
    });
  
  Future<AuthResponse> signIn(String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
  
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}

// Provider:
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(supabaseClientProvider));
});

final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});
```

### Realtime Subscriptions

**React:**
```typescript
useEffect(() => {
  const channel = supabase
    .channel('appointments')
    .on('postgres_changes', 
      { event: '*', schema: 'public', table: 'appointments' },
      (payload) => { queryClient.invalidateQueries(['appointments']); }
    )
    .subscribe();
  
  return () => { supabase.removeChannel(channel); };
}, []);
```

**Flutter:**
```dart
// Use StreamProvider
final appointmentsStreamProvider = StreamProvider<List<Appointment>>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  
  return supabase
    .from('appointments')
    .stream(primaryKey: ['id'])
    .order('created_at', ascending: false)
    .map((data) => data.map((json) => Appointment.fromJson(json)).toList());
});
```

---

## 🎨 UI COMPONENT MIGRATION

### shadcn/ui → Flutter Widgets

The React app uses **shadcn/ui** (Radix UI + Tailwind CSS). Flutter equivalents:

| shadcn/ui Component | Flutter Equivalent | Notes |
|---------------------|-------------------|-------|
| `<Button>` | `ElevatedButton` / `FilledButton` | Use Material 3 variants |
| `<Input>` | `TextField` | With `InputDecoration` |
| `<Select>` | `DropdownButton` | Or `DropdownMenu` (M3) |
| `<Dialog>` | `showDialog()` + `AlertDialog` | Modal dialogs |
| `<Sheet>` | `showModalBottomSheet()` | Bottom sheets |
| `<Tabs>` | `TabBar` + `TabBarView` | With `DefaultTabController` |
| `<Card>` | `Card` | Material widget |
| `<Badge>` | `Chip` or custom `Container` | Use Chip for tags |
| `<Avatar>` | `CircleAvatar` | Built-in widget |
| `<Separator>` | `Divider` | Horizontal/vertical |
| `<Toast>` | `ScaffoldMessenger.showSnackBar()` | Or use `fluttertoast` package |
| `<Popover>` | `PopupMenuButton` | Context menus |
| `<Accordion>` | `ExpansionTile` / `ExpansionPanelList` | Collapsible lists |
| `<Checkbox>` | `Checkbox` | Material widget |
| `<Switch>` | `Switch` | Toggle switch |
| `<RadioGroup>` | `Radio` + `RadioListTile` | Radio buttons |
| `<Slider>` | `Slider` | Range slider |
| `<Progress>` | `LinearProgressIndicator` / `CircularProgressIndicator` | Loading indicators |

### Custom Component Pattern

**React (shadcn/ui Button):**
```typescript
<Button variant="destructive" size="lg" onClick={handleDelete}>
  <Trash2 className="mr-2 h-4 w-4" />
  Delete
</Button>
```

**Flutter Equivalent:**
```dart
FilledButton.tonalIcon(
  onPressed: handleDelete,
  icon: Icon(Icons.delete, size: 18),
  label: Text('Delete'),
  style: FilledButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.errorContainer,
    foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
  ),
)
```

### Creating Reusable Widgets

```dart
// widgets/app_button.dart
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ButtonVariant variant;
  
  const AppButton({
    required this.label,
    this.onPressed,
    this.icon,
    this.variant = ButtonVariant.primary,
  });
  
  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case ButtonVariant.primary:
        return icon != null
          ? FilledButton.icon(
              onPressed: onPressed,
              icon: Icon(icon),
              label: Text(label),
            )
          : FilledButton(
              onPressed: onPressed,
              child: Text(label),
            );
      case ButtonVariant.destructive:
        return FilledButton.tonalIcon(
          onPressed: onPressed,
          icon: Icon(icon ?? Icons.delete),
          label: Text(label),
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
          ),
        );
      // ... other variants
    }
  }
}

enum ButtonVariant { primary, secondary, destructive, ghost, outline }
```

---

## 🌈 THEMING & STYLING

### React (Tailwind CSS)

```typescript
<div className="bg-gray-900 text-white p-4 rounded-lg shadow-md">
  <h1 className="text-2xl font-bold mb-2">Title</h1>
  <p className="text-gray-300">Description</p>
</div>
```

### Flutter (Material Theme + Custom Colors)

```dart
// core/theme/app_theme.dart
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    // ... more theme configuration
  );
  
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    ),
    // ... dark theme configuration
  );
}

// Usage in widget:
Card(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Title',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Description',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    ),
  ),
)
```

### Theme Switching Pattern

**React:**
```typescript
const [theme, setTheme] = useState<'light' | 'dark' | 'system'>('system');
```

**Flutter:**
```dart
// providers/theme_provider.dart
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadThemeMode();
  }
  
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString('themeMode') ?? 'system';
    state = ThemeMode.values.firstWhere(
      (e) => e.toString() == 'ThemeMode.$themeModeString',
      orElse: () => ThemeMode.system,
    );
  }
  
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', mode.toString().split('.').last);
  }
}

// In main.dart:
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    
    return MaterialApp.router(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
```

---

## 🗺️ NAVIGATION & ROUTING

### React Router → GoRouter

**React:**
```typescript
// App.tsx
<BrowserRouter>
  <Routes>
    <Route path="/" element={<Index />} />
    <Route path="/login" element={<Login />} />
    <Route path="/booking" element={<Booking />} />
    <Route path="/dashboard/*" element={
      <ProtectedRoute>
        <Dashboard />
      </ProtectedRoute>
    } />
  </Routes>
</BrowserRouter>
```

**Flutter:**
```dart
// navigation/app_router.dart
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isAuthenticated = authState.value?.isAuthenticated ?? false;
      final isLoginRoute = state.matchedLocation == '/login';
      
      if (!isAuthenticated && !isLoginRoute && state.matchedLocation != '/') {
        return '/login';
      }
      if (isAuthenticated && isLoginRoute) {
        return '/dashboard';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => EntryScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/booking',
        builder: (context, state) => BookingScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => DashboardScreen(),
        routes: [
          GoRoute(
            path: 'profile',
            builder: (context, state) => ProfileScreen(),
          ),
          // ... nested routes
        ],
      ),
    ],
  );
});
```

### Passing Parameters

**React:**
```typescript
navigate(`/salon/${salonId}`, { state: { salon: salonData } });

// In component:
const { salonId } = useParams();
const location = useLocation();
const salon = location.state?.salon;
```

**Flutter:**
```dart
// Navigate:
context.go('/salon/${salon.id}', extra: salon);

// Or with named parameters:
context.goNamed('salonDetails', pathParameters: {'id': salon.id}, extra: salon);

// In route builder:
GoRoute(
  path: '/salon/:id',
  name: 'salonDetails',
  builder: (context, state) {
    final salonId = state.pathParameters['id']!;
    final salon = state.extra as Salon?;
    return SalonDetailScreen(salonId: salonId, salon: salon);
  },
),
```

---

## 📱 RESPONSIVE DESIGN

### React (Tailwind breakpoints)

```typescript
<div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
  {items.map(item => <ItemCard key={item.id} item={item} />)}
</div>
```

### Flutter (MediaQuery + LayoutBuilder)

```dart
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        if (constraints.maxWidth > 1200) {
          crossAxisCount = 4; // lg
        } else if (constraints.maxWidth > 768) {
          crossAxisCount = 2; // md
        } else {
          crossAxisCount = 1; // mobile
        }
        
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        );
      },
    );
  }
}
```

### Breakpoint Helper

```dart
// core/utils/breakpoints.dart
enum Breakpoint { mobile, tablet, desktop }

extension BreakpointExtension on BuildContext {
  Breakpoint get breakpoint {
    final width = MediaQuery.of(this).size.width;
    if (width < 768) return Breakpoint.mobile;
    if (width < 1200) return Breakpoint.tablet;
    return Breakpoint.desktop;
  }
  
  bool get isMobile => breakpoint == Breakpoint.mobile;
  bool get isTablet => breakpoint == Breakpoint.tablet;
  bool get isDesktop => breakpoint == Breakpoint.desktop;
}
```

---

## 🌐 INTERNATIONALIZATION (i18n)

### React (react-i18next)

```typescript
// i18n/index.ts
i18n.use(initReactI18next).init({
  resources: {
    de: { translation: deTranslations },
    en: { translation: enTranslations },
  },
  lng: 'de',
  fallbackLng: 'de',
});

// Usage:
const { t } = useTranslation();
<h1>{t('welcome.title')}</h1>
```

### Flutter (easy_localization)

```dart
// main.dart
await EasyLocalization.ensureInitialized();

runApp(
  EasyLocalization(
    supportedLocales: [Locale('de'), Locale('en')],
    path: 'assets/translations',
    fallbackLocale: Locale('de'),
    child: MyApp(),
  ),
);

// In widget:
Text('welcome.title'.tr())

// Or with context:
Text(context.tr('welcome.title'))

// With parameters:
Text('greeting'.tr(namedArgs: {'name': 'John'}))
// Translation: "Hallo {name}"
```

**Translation files:**
```
assets/translations/
├── de.json
└── en.json
```

---

## 📦 DATA MODELS WITH FREEZED

### React (TypeScript interfaces)

```typescript
interface Salon {
  id: string;
  name: string;
  description?: string;
  owner_id: string;
  is_active: boolean;
  created_at: string;
}
```

### Flutter (Freezed + JSON Serializable)

```dart
// models/salon.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'salon.freezed.dart';
part 'salon.g.dart';

@freezed
class Salon with _$Salon {
  const factory Salon({
    required String id,
    required String name,
    String? description,
    required String ownerId,
    required bool isActive,
    required DateTime createdAt,
  }) = _Salon;
  
  factory Salon.fromJson(Map<String, dynamic> json) => _$SalonFromJson(json);
}

// Generate code:
// flutter pub run build_runner build --delete-conflicting-outputs
```

**Benefits:**
- Immutability by default
- `copyWith` method for updates
- Equality checks (`==`, `hashCode`)
- Union types (sealed classes)
- JSON serialization

---

## 🔥 COMMON PATTERNS

### 1. Loading States

**React:**
```typescript
if (isLoading) return <Spinner />;
if (error) return <ErrorMessage error={error} />;
return <DataView data={data} />;
```

**Flutter:**
```dart
final dataAsync = ref.watch(dataProvider);

return dataAsync.when(
  data: (data) => DataView(data: data),
  loading: () => Center(child: CircularProgressIndicator()),
  error: (error, stack) => ErrorWidget(error: error),
);
```

### 2. Form Handling

**React (react-hook-form):**
```typescript
const { register, handleSubmit, formState: { errors } } = useForm();

<form onSubmit={handleSubmit(onSubmit)}>
  <input {...register('email', { required: true })} />
  {errors.email && <span>Email is required</span>}
  <button type="submit">Submit</button>
</form>
```

**Flutter (flutter_hooks + validators):**
```dart
class LoginForm extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              if (!value.contains('@')) {
                return 'Invalid email';
              }
              return null;
            },
          ),
          TextFormField(
            controller: passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                ref.read(authRepositoryProvider).signIn(
                  emailController.text,
                  passwordController.text,
                );
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
```

### 3. Image Upload

**React:**
```typescript
const handleImageUpload = async (file: File) => {
  const { data, error } = await supabase.storage
    .from('gallery')
    .upload(`${userId}/${Date.now()}_${file.name}`, file);
  
  if (error) throw error;
  return data.path;
};
```

**Flutter:**
```dart
// services/storage_service.dart
class StorageService {
  final SupabaseClient _supabase;
  
  StorageService(this._supabase);
  
  Future<String> uploadImage(File file, String userId) async {
    final fileName = '${userId}/${DateTime.now().millisecondsSinceEpoch}_${basename(file.path)}';
    
    await _supabase.storage
      .from('gallery')
      .upload(fileName, file);
    
    return fileName;
  }
  
  String getPublicUrl(String path) {
    return _supabase.storage.from('gallery').getPublicUrl(path);
  }
}

// Usage with image_picker:
final picker = ImagePicker();
final XFile? image = await picker.pickImage(source: ImageSource.gallery);

if (image != null) {
  final file = File(image.path);
  final path = await ref.read(storageServiceProvider).uploadImage(file, userId);
  // Save path to database...
}
```

### 4. Infinite Scroll / Pagination

**React:**
```typescript
const { data, fetchNextPage, hasNextPage } = useInfiniteQuery({
  queryKey: ['salons'],
  queryFn: ({ pageParam = 0 }) => fetchSalons(pageParam),
  getNextPageParam: (lastPage, pages) => lastPage.nextCursor,
});
```

**Flutter:**
```dart
class SalonListScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final salons = ref.watch(salonsProvider);
    
    useEffect(() {
      scrollController.addListener(() {
        if (scrollController.position.pixels >= 
            scrollController.position.maxScrollExtent * 0.9) {
          ref.read(salonsProvider.notifier).loadMore();
        }
      });
      return null;
    }, [scrollController]);
    
    return ListView.builder(
      controller: scrollController,
      itemCount: salons.length + (salons.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == salons.length) {
          return CircularProgressIndicator();
        }
        return SalonCard(salon: salons[index]);
      },
    );
  }
}

// Provider with pagination:
class SalonsNotifier extends StateNotifier<SalonsState> {
  final SupabaseClient _supabase;
  static const _pageSize = 20;
  
  SalonsNotifier(this._supabase) : super(SalonsState.initial()) {
    loadMore();
  }
  
  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;
    
    state = state.copyWith(isLoading: true);
    
    final response = await _supabase
      .from('salons')
      .select()
      .range(state.items.length, state.items.length + _pageSize - 1);
    
    final newItems = (response as List).map((json) => Salon.fromJson(json)).toList();
    
    state = state.copyWith(
      items: [...state.items, ...newItems],
      hasMore: newItems.length == _pageSize,
      isLoading: false,
    );
  }
}
```

---

## 🎯 FEATURE-SPECIFIC PATTERNS

### Gallery Module with AI

The React app has a sophisticated gallery module with:
- Instagram-like image grid
- Like/Save functionality
- Filters (salon, color, tags, search)
- AI-powered hairstyle suggestions (text-based and like-based)
- Modal with suggestions

**Key Flutter Implementation Points:**

1. **Masonry Grid Layout** → Use `flutter_staggered_grid_view` package
2. **Image Caching** → Use `cached_network_image` package
3. **Lightbox** → Use `photo_view` package
4. **AI Suggestions Modal** → Custom `showDialog` with `HairstyleSuggestionsModal` widget

```dart
// features/gallery/presentation/screens/gallery_screen.dart
class GalleryScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final images = ref.watch(galleryImagesProvider);
    final selectedSalon = ref.watch(selectedSalonFilterProvider);
    final selectedColors = ref.watch(selectedColorsFilterProvider);
    final searchTerm = ref.watch(searchTermProvider);
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Filter Bar
          SliverToBoxAdapter(
            child: FilterBar(
              onSalonChanged: (salon) => 
                ref.read(selectedSalonFilterProvider.notifier).state = salon,
              onColorsChanged: (colors) =>
                ref.read(selectedColorsFilterProvider.notifier).state = colors,
              onSearchChanged: (term) =>
                ref.read(searchTermProvider.notifier).state = term,
            ),
          ),
          
          // Image Grid
          images.when(
            data: (imageList) => SliverMasonryGrid.count(
              crossAxisCount: context.isDesktop ? 4 : context.isTablet ? 2 : 1,
              itemBuilder: (context, index) {
                final image = imageList[index];
                return GalleryImageCard(
                  image: image,
                  onLike: () => ref.read(galleryActionsProvider).toggleLike(image.id),
                  onSave: () => ref.read(galleryActionsProvider).toggleSave(image.id),
                  onTap: () => showImageLightbox(context, image, imageList),
                );
              },
              childCount: imageList.length,
            ),
            loading: () => SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => SliverFillRemaining(
              child: ErrorWidget(error: error),
            ),
          ),
        ],
      ),
      
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            onPressed: () => _showTextBasedSuggestions(context, ref),
            label: Text('AI Vorschläge'),
            icon: Icon(Icons.auto_awesome),
          ),
          SizedBox(height: 8),
          FloatingActionButton.extended(
            onPressed: () => _showLikeBasedRecommendations(context, ref),
            label: Text('Meine Empfehlungen'),
            icon: Icon(Icons.favorite),
          ),
        ],
      ),
    );
  }
  
  void _showTextBasedSuggestions(BuildContext context, WidgetRef ref) async {
    final description = await showDialog<String>(
      context: context,
      builder: (context) => HairstyleDescriptionDialog(),
    );
    
    if (description != null && description.isNotEmpty) {
      final suggestions = await ref.read(aiSuggestionsProvider.notifier)
        .generateFromText(description);
      
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => HairstyleSuggestionsModal(
            suggestions: suggestions,
            sourceType: SuggestionSource.text,
          ),
        );
      }
    }
  }
}
```

### Booking Wizard

Multi-step booking flow with:
- Step 1: Select Services
- Step 2: Choose Date & Time
- Step 3: Guest Info
- Step 4: Notes & Photos
- Step 5: Summary & Confirmation

**Flutter Implementation:**

```dart
// features/booking/presentation/screens/booking_wizard_screen.dart
class BookingWizardScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = ref.watch(bookingWizardStepProvider);
    final bookingData = ref.watch(bookingWizardDataProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Termin buchen'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (currentStep + 1) / 5,
          ),
        ),
      ),
      body: PageView(
        controller: ref.watch(bookingPageControllerProvider),
        physics: NeverScrollableScrollPhysics(),
        children: [
          ServiceSelectionStep(),
          DateTimeSelectionStep(),
          GuestInfoStep(),
          NotesAndPhotosStep(),
          SummaryStep(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (currentStep > 0)
              TextButton(
                onPressed: () => ref.read(bookingWizardStepProvider.notifier)
                  .previousStep(),
                child: Text('Zurück'),
              )
            else
              SizedBox(),
            
            FilledButton(
              onPressed: currentStep == 4
                ? () => _submitBooking(context, ref, bookingData)
                : () => ref.read(bookingWizardStepProvider.notifier).nextStep(),
              child: Text(currentStep == 4 ? 'Bestätigen' : 'Weiter'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Real-time Chat

**React:** Uses Supabase Realtime for message updates

**Flutter:**
```dart
// features/chat/data/chat_repository.dart
class ChatRepository {
  final SupabaseClient _supabase;
  
  ChatRepository(this._supabase);
  
  Stream<List<Message>> getMessagesStream(String conversationId) {
    return _supabase
      .from('messages')
      .stream(primaryKey: ['id'])
      .eq('conversation_id', conversationId)
      .order('created_at', ascending: true)
      .map((data) => data.map((json) => Message.fromJson(json)).toList());
  }
  
  Future<void> sendMessage(String conversationId, String content) async {
    await _supabase.from('messages').insert({
      'conversation_id': conversationId,
      'content': content,
      'sender_id': _supabase.auth.currentUser!.id,
    });
  }
}

// UI:
final messagesStream = ref.watch(messagesStreamProvider(conversationId));

return messagesStream.when(
  data: (messages) => ListView.builder(
    reverse: true,
    itemCount: messages.length,
    itemBuilder: (context, index) {
      final message = messages[messages.length - 1 - index];
      return MessageBubble(message: message);
    },
  ),
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => ErrorWidget(error: error),
);
```

### Google Maps Integration

**React:** Uses `@react-google-maps/api`

**Flutter:** Use `google_maps_flutter` package

```dart
// features/salon_search/presentation/screens/salon_map_screen.dart
class SalonMapScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocation = ref.watch(currentLocationProvider);
    final salons = ref.watch(nearbySalonsProvider);
    final selectedSalon = ref.watch(selectedSalonProvider);
    
    final mapController = useState<GoogleMapController?>(null);
    
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: currentLocation.value ?? LatLng(52.5200, 13.4050), // Berlin
              zoom: 13,
            ),
            onMapCreated: (controller) => mapController.value = controller,
            markers: salons.value?.map((salon) => Marker(
              markerId: MarkerId(salon.id),
              position: LatLng(salon.latitude, salon.longitude),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                selectedSalon?.id == salon.id
                  ? BitmapDescriptor.hueRed
                  : BitmapDescriptor.hueBlue,
              ),
              onTap: () => ref.read(selectedSalonProvider.notifier).state = salon,
            )).toSet() ?? {},
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          
          // Bottom Sheet with Salon Cards
          if (selectedSalon != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: DraggableScrollableSheet(
                initialChildSize: 0.3,
                minChildSize: 0.1,
                maxChildSize: 0.7,
                builder: (context, scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: ListView(
                      controller: scrollController,
                      children: [
                        SalonCard(salon: selectedSalon),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/salon-list'),
        label: Text('Listansicht'),
        icon: Icon(Icons.list),
      ),
    );
  }
}
```

---

## 🔧 DEVELOPMENT WORKFLOW

### Project Setup Checklist

1. **Create Flutter project:**
   ```bash
   flutter create --org com.salonmanager salonmanager
   cd salonmanager
   ```

2. **Add dependencies to `pubspec.yaml`:**
   ```yaml
   dependencies:
     # State Management
     flutter_riverpod: ^2.5.1
     hooks_riverpod: ^2.5.1
     flutter_hooks: ^0.20.5
     
     # Routing
     go_router: ^14.6.2
     
     # Supabase
     supabase_flutter: ^2.10.0
     
     # UI & Styling
     google_fonts: ^6.1.0
     
     # Data Models
     freezed_annotation: ^2.4.1
     json_annotation: ^4.9.0
     
     # Localization
     easy_localization: ^3.0.7
     
     # Storage
     shared_preferences: ^2.2.3
     
     # Google Maps
     google_maps_flutter: ^2.10.1
     geolocator: ^12.0.0
     
     # Image Handling
     image_picker: ^1.1.0
     cached_network_image: ^3.3.0
     
     # Utilities
     uuid: ^4.1.0
     http: ^1.2.0
     
   dev_dependencies:
     # Code Generation
     build_runner: ^2.4.12
     freezed: ^2.5.2
     json_serializable: ^6.8.0
     
     flutter_lints: ^5.0.0
   ```

3. **Setup environment variables:**
   ```
   # .env
   SUPABASE_URL=https://your-project.supabase.co
   SUPABASE_ANON_KEY=your-anon-key
   GOOGLE_MAPS_API_KEY=your-maps-key
   ```

4. **Initialize Supabase in main:**
   ```dart
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await EasyLocalization.ensureInitialized();
     await dotenv.load();
     await SupabaseConfig.initialize();
     
     runApp(
       ProviderScope(
         child: EasyLocalization(
           supportedLocales: [Locale('de'), Locale('en')],
           path: 'assets/translations',
           fallbackLocale: Locale('de'),
           child: MyApp(),
         ),
       ),
     );
   }
   ```

### Code Generation

```bash
# Generate Freezed & JSON files
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerate on save)
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Project Structure Best Practices

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart          # Color palette
│   │   ├── app_text_styles.dart     # Text styles
│   │   └── app_dimensions.dart      # Spacing, sizes
│   ├── theme/
│   │   └── app_theme.dart           # Light/Dark themes
│   ├── config/
│   │   ├── supabase_config.dart     # Supabase setup
│   │   └── env_config.dart          # Environment variables
│   └── utils/
│       ├── validators.dart           # Form validators
│       ├── formatters.dart           # Date, currency formatters
│       └── helpers.dart              # Utility functions
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── models/
│   │   │       └── auth_state.dart
│   │   ├── domain/
│   │   │   └── entities/
│   │   │       └── user.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── auth_provider.dart
│   │       │   └── auth_state_provider.dart
│   │       ├── screens/
│   │       │   ├── login_screen.dart
│   │       │   ├── register_screen.dart
│   │       │   └── forgot_password_screen.dart
│   │       └── widgets/
│   │           ├── login_form.dart
│   │           └── social_auth_buttons.dart
│   ├── dashboard/
│   ├── booking/
│   ├── gallery/
│   ├── salon_search/
│   └── ...
├── models/                           # Shared Freezed models
│   ├── salon.dart
│   ├── service.dart
│   ├── appointment.dart
│   └── ...
├── providers/                        # Global providers
│   ├── supabase_provider.dart
│   ├── theme_provider.dart
│   └── locale_provider.dart
├── services/                         # Shared services
│   ├── storage_service.dart
│   ├── location_service.dart
│   └── analytics_service.dart
├── widgets/                          # Shared widgets
│   ├── app_button.dart
│   ├── app_text_field.dart
│   ├── error_widget.dart
│   └── loading_widget.dart
├── navigation/
│   └── app_router.dart
└── main.dart
```

---

## 📋 MIGRATION CHECKLIST

### Phase 1: Foundation (Week 1)
- [ ] Setup Flutter project with dependencies
- [ ] Configure Supabase connection
- [ ] Implement authentication flow (login, register, logout)
- [ ] Create theme system (light/dark modes)
- [ ] Setup i18n (DE/EN)
- [ ] Create basic navigation structure (GoRouter)
- [ ] Build core reusable widgets

### Phase 2: Dashboard Shells (Week 2)
- [ ] Customer Dashboard shell
- [ ] Employee Dashboard shell
- [ ] Admin Dashboard shell
- [ ] Owner Dashboard shell
- [ ] Role-based routing
- [ ] Settings screens (profile, theme, language)
- [ ] Logout functionality

### Phase 3: Salon Search & Maps (Week 2-3)
- [ ] Google Maps integration
- [ ] Location services (GPS)
- [ ] Salon search with filters (radius, rating, price, categories)
- [ ] Salon list view
- [ ] Salon detail screen
- [ ] Map markers and info windows

### Phase 4: Booking System (Week 3-4)
- [ ] Booking wizard (5 steps)
- [ ] Service selection
- [ ] Date & time picker with availability
- [ ] Guest info form
- [ ] Notes & photo upload
- [ ] Booking summary & confirmation
- [ ] Appointment management (view, cancel, reschedule)

### Phase 5: Gallery Module (Week 5)
- [ ] Image grid with masonry layout
- [ ] Like/Save functionality
- [ ] Filters (salon, color, tags, search)
- [ ] Image upload
- [ ] Lightbox view
- [ ] AI suggestions (text-based)
- [ ] AI recommendations (like-based)
- [ ] Hairstyle suggestions modal

### Phase 6: Chat System (Week 6)
- [ ] Conversation list
- [ ] Real-time chat interface
- [ ] Message sending/receiving
- [ ] Appointment-linked chats
- [ ] Support chat
- [ ] Notifications for new messages

### Phase 7: Employee Features (Week 7)
- [ ] Calendar view
- [ ] Time tracking (clock in/out)
- [ ] NFC time codes
- [ ] Shift planner
- [ ] Shift swap requests
- [ ] Leave requests
- [ ] Employee portfolio

### Phase 8: Admin Features (Week 8-9)
- [ ] Employee management
- [ ] Salon settings
- [ ] Service management
- [ ] Dashboard analytics
- [ ] Module toggles
- [ ] Permission settings
- [ ] Activity logs

### Phase 9: POS & Inventory (Week 10)
- [ ] POS terminal
- [ ] Transaction history
- [ ] Inventory management
- [ ] Auto-order system
- [ ] Supplier management

### Phase 10: Advanced Features (Week 11-12)
- [ ] Reports & analytics
- [ ] GDPR compliance features
- [ ] DATEV export
- [ ] Loyalty program
- [ ] CRM features
- [ ] SEO settings
- [ ] Push notifications
- [ ] Offline mode basics

---

## ⚠️ COMMON PITFALLS & SOLUTIONS

### 1. Async State Management

**Problem:** React's `useEffect` cleanup vs Flutter's disposal

**Solution:** Use Riverpod's `ref.onDispose`:
```dart
ref.onDispose(() {
  subscription.cancel();
  controller.dispose();
});
```

### 2. Widget Rebuild Performance

**Problem:** Entire widget tree rebuilding on state change

**Solution:** Use `Consumer` widget or `select` to watch specific parts:
```dart
final userName = ref.watch(userProvider.select((user) => user.name));
```

### 3. Context Issues

**Problem:** `BuildContext` not available in async callbacks

**Solution:** Check `mounted` or use `ref.read()` instead of `ref.watch()`:
```dart
if (context.mounted) {
  ScaffoldMessenger.of(context).showSnackBar(...);
}

// Or use ref.read for one-time actions:
ref.read(someProvider.notifier).someAction();
```

### 4. Image Caching

**Problem:** Images reload on every navigation

**Solution:** Use `cached_network_image`:
```dart
CachedNetworkImage(
  imageUrl: imageUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

### 5. Deep Links

**Problem:** App not opening from URLs on mobile

**Solution:** Configure deep links in Android/iOS manifests and use GoRouter's redirect:
```dart
// android/app/src/main/AndroidManifest.xml
<intent-filter android:autoVerify="true">
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <data android:scheme="https" android:host="salonmanager.app" />
</intent-filter>
```

---

## 🚀 BEST PRACTICES

1. **Always use Freezed for models** - Immutability and type safety
2. **Prefer StreamProvider for real-time data** - Automatically handles subscriptions
3. **Use `ref.read()` for one-time actions** - Avoid unnecessary rebuilds
4. **Implement error boundaries** - Use `.when()` to handle loading/error states
5. **Follow Material Design 3** - Use M3 components for consistent UI
6. **Test on real devices** - Emulators don't catch all issues (especially maps, camera)
7. **Use const constructors** - Performance optimization
8. **Avoid setState in StatelessWidget** - Use Riverpod providers
9. **Cache network images** - Use `cached_network_image` package
10. **Handle keyboard** - Use `SingleChildScrollView` + `ScrollPhysics` for forms

---

## 📚 RESOURCES

### Official Documentation
- [Flutter Docs](https://docs.flutter.dev/)
- [Riverpod Docs](https://riverpod.dev/)
- [Supabase Flutter](https://supabase.com/docs/guides/getting-started/quickstarts/flutter)
- [GoRouter](https://pub.dev/packages/go_router)
- [Freezed](https://pub.dev/packages/freezed)

### Packages
- [pub.dev](https://pub.dev/) - Flutter package repository
- [flutter_hooks](https://pub.dev/packages/flutter_hooks) - React Hooks equivalent
- [easy_localization](https://pub.dev/packages/easy_localization) - i18n
- [google_maps_flutter](https://pub.dev/packages/google_maps_flutter) - Maps
- [cached_network_image](https://pub.dev/packages/cached_network_image) - Image caching

### Community
- [Flutter Discord](https://discord.gg/flutter)
- [r/FlutterDev](https://www.reddit.com/r/FlutterDev/)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)

---

## 🎓 LEARNING PATH

For developers familiar with React but new to Flutter:

1. **Week 1:** Flutter basics (Widgets, State, Lifecycle)
2. **Week 2:** Riverpod state management
3. **Week 3:** Navigation with GoRouter
4. **Week 4:** Supabase integration
5. **Week 5:** Forms and validation
6. **Week 6:** Async programming (Futures, Streams)
7. **Week 7:** Platform-specific features
8. **Week 8:** Testing and debugging

---

## 📝 NOTES

- The original React app is 100% feature-complete on the frontend
- Backend SQL migrations and Edge Functions are documented but not deployed yet
- Focus on maintaining feature parity while improving performance
- Consider mobile-first design given Flutter's strength on mobile
- Leverage Flutter's native performance for smooth animations
- Use Firebase Analytics for tracking if needed
- Plan for offline-first architecture in future iterations

---

**End of Skill Document**