# HR Connect - Feature Architecture Guide

Dokumen teknis sebagai referensi konsistensi penulisan kode pada setiap fitur.

---

## 1. Folder Structure per Feature

Setiap fitur mengikuti **Clean Architecture** dengan pendekatan **feature-first**:

```
lib/features/<feature_name>/
├── data/
│   ├── datasources/
│   │   └── <feature>_remote_datasource.dart    # Abstract + Impl
│   ├── models/
│   │   └── <feature>_model.dart                # Extends Entity, fromJson/toJson
│   └── repositories/
│       └── <feature>_repository_impl.dart       # Implements domain repository
├── domain/
│   ├── entities/
│   │   └── <feature>_entity.dart                # Pure Dart class, no dependencies
│   ├── repositories/
│   │   └── <feature>_repository.dart            # Abstract class (contract)
│   └── usecases/
│       └── <action>_usecase.dart                # Single-responsibility use case
└── presentation/
    ├── providers/
    │   ├── <feature>_states.dart                # Sealed class state hierarchy
    │   ├── <feature>_providers.dart             # Riverpod annotated providers
    │   └── <feature>_providers.g.dart           # Generated (build_runner)
    ├── screens/
    │   └── <feature>_screen.dart                # ConsumerWidget / ConsumerStatefulWidget
    └── widgets/
        └── <widget_name>.dart                   # Reusable UI components
```

### Kapan layer boleh dihilangkan

| Situasi                                                     | Layer yang boleh skip                                             |
| ----------------------------------------------------------- | ----------------------------------------------------------------- |
| Feature hanya butuh logic lokal (GPS, timer) tanpa Supabase | `data/`, `domain/` -- langsung logic di provider                  |
| Feature UI-only (settings, profile static)                  | `data/`, `domain/`, `providers/`                                  |
| Feature yang reuse use case dari fitur lain                 | `data/`, `domain/` -- provider langsung akses provider fitur lain |

Contoh: `attendance_map` tidak punya `data/` dan `domain/` karena reuse `attendance` use case.

---

## 2. State Management: Riverpod (Annotation-Based)

### 2.1 State Class (Sealed Class)

File: `presentation/providers/<feature>_states.dart`

```dart
import 'package:latlong2/latlong.dart'; // atau import entity yang relevan

sealed class FeatureState {
  const FeatureState();
}

class FeatureInitial extends FeatureState {}

class FeatureLoading extends FeatureState {}

class FeatureLoaded extends FeatureState {
  final SomeEntity data;
  const FeatureLoaded(this.data);

  // Tambahkan copyWith jika state perlu partial update
  FeatureLoaded copyWith({SomeEntity? data}) {
    return FeatureLoaded(data ?? this.data);
  }
}

class FeatureSuccess extends FeatureState {}

class FeatureError extends FeatureState {
  final String message;
  final String? source;  // untuk identifikasi asal error
  const FeatureError(this.message, {this.source});
}
```

**Aturan:**

- Selalu `sealed class` -- memungkinkan exhaustive switch di UI
- `const` constructor di semua subclass
- `source` pada Error state untuk membedakan asal error (login, register, network)
- `copyWith` hanya jika ada partial state update (misal: `isProcessing` toggle)

### 2.2 Provider (Riverpod Generator)

File: `presentation/providers/<feature>_providers.dart`

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '<feature>_states.dart';

part '<feature>_providers.g.dart';

// --- Data Layer Providers (jika ada) ---
@riverpod
FeatureRemoteDataSource featureRemoteDataSource(Ref ref) {
  return FeatureRemoteDataSourceImpl(Supabase.instance.client);
}

@riverpod
FeatureRepository featureRepository(Ref ref) {
  return FeatureRepositoryImpl(ref.watch(featureRemoteDataSourceProvider));
}

// --- Use Case Providers (jika ada) ---
@riverpod
SomeUseCase someUseCase(Ref ref) {
  return SomeUseCase(ref.watch(featureRepositoryProvider));
}

// --- State Notifier ---
@riverpod
class FeatureNotifier extends _$FeatureNotifier {
  @override
  FeatureState build() {
    // Initial logic (auto-load, session check, etc.)
    _loadInitialData();
    return FeatureLoading();
  }

  Future<void> _loadInitialData() async {
    // Business logic disini, BUKAN di screen
  }

  Future<void> someAction() async {
    // Ubah state sesuai flow
    state = FeatureLoading();
    // ... logic ...
    state = FeatureLoaded(data);
  }
}
```

**Aturan:**

- `@riverpod` untuk auto-dispose providers (default)
- `@Riverpod(keepAlive: true)` hanya jika data harus persist selama app hidup (misal: attendance data)
- Notifier class selalu `extends _$FeatureNotifier` (generated)
- `build()` return initial state, bisa trigger async load
- Semua business logic ada di notifier, **BUKAN** di screen

### 2.3 Naming Convention (Generated)

| Annotation                                   | Generated Provider Name |
| -------------------------------------------- | ----------------------- |
| `@riverpod class AuthNotifier`               | `authProvider`          |
| `@riverpod class AttendanceNotifier`         | `attendanceProvider`    |
| `@riverpod class AttendanceMapNotifier`      | `attendanceMapProvider` |
| `@riverpod SomeUseCase someUseCase(Ref ref)` | `someUseCaseProvider`   |

Pattern: class name tanpa "Notifier" suffix, lowercase camelCase + `Provider`.

### 2.4 Code Generation

Setelah membuat/mengubah providers, jalankan:

```bash
dart run build_runner build --delete-conflicting-outputs
```

File `.g.dart` akan ter-generate otomatis. **JANGAN** edit file `.g.dart` secara manual.

---

## 3. Screen Pattern

### 3.1 Stateless (prefer ini jika tidak ada MapController, AnimationController, dll)

```dart
class FeatureScreen extends ConsumerWidget {
  const FeatureScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(featureProvider);

    // Side effects (navigasi, snackbar)
    ref.listen(featureProvider, (prev, next) {
      if (next is FeatureSuccess) context.pop(true);
      if (next is FeatureError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message)),
        );
      }
    });

    return Scaffold(
      body: switch (state) {
        FeatureLoading() => const CircularProgressIndicator(),
        FeatureLoaded(:final data) => _buildContent(context, ref, data),
        FeatureError(:final message) => _buildError(context, ref, message),
        _ => const SizedBox.shrink(),
      },
    );
  }
}
```

### 3.2 Stateful (hanya jika butuh controller: MapController, TextEditingController, dll)

```dart
class FeatureScreen extends ConsumerStatefulWidget {
  const FeatureScreen({super.key});

  @override
  ConsumerState<FeatureScreen> createState() => _FeatureScreenState();
}

class _FeatureScreenState extends ConsumerState<FeatureScreen> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(featureProvider);
    ref.listen(featureProvider, (prev, next) { /* side effects */ });
    // ... UI berdasarkan state
  }
}
```

**Aturan:**

- **TIDAK ADA** `setState()` untuk business logic -- semua lewat provider
- `setState()` hanya boleh untuk UI-only state (misal: `_mapReady` flag)
- `ref.watch()` untuk reactive rebuild
- `ref.listen()` untuk side effects (navigasi, snackbar, dialog)
- `ref.read()` untuk fire-and-forget actions (button tap)

---

## 4. Data Layer Pattern

### 4.1 Entity (Domain)

```dart
class EmployeeEntity {
  final String id;
  final String fullName;
  // ... pure fields, no Supabase/JSON dependency

  const EmployeeEntity({required this.id, required this.fullName});
}
```

### 4.2 Model (Data) -- extends Entity

```dart
class EmployeeModel extends EmployeeEntity {
  EmployeeModel({required super.id, required super.fullName});

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'full_name': fullName,
  };
}
```

### 4.3 DataSource (Data)

```dart
abstract class FeatureRemoteDataSource {
  Future<FeatureModel> getData();
}

class FeatureRemoteDataSourceImpl implements FeatureRemoteDataSource {
  final SupabaseClient supabaseClient;
  FeatureRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<FeatureModel> getData() async {
    final response = await supabaseClient.from('table').select().single();
    return FeatureModel.fromJson(response);
  }
}
```

### 4.4 Repository

**Domain (contract):**

```dart
abstract class FeatureRepository {
  Future<Either<Failure, FeatureEntity>> getData();
}
```

**Data (implementation):**

```dart
class FeatureRepositoryImpl implements FeatureRepository {
  final FeatureRemoteDataSource remoteDataSource;
  FeatureRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, FeatureEntity>> getData() async {
    return await remoteDataSource.getData();
  }
}
```

### 4.5 Use Case

```dart
class GetDataUseCase {
  final FeatureRepository repository;
  GetDataUseCase(this.repository);

  Future<Either<Failure, FeatureEntity>> call() {
    return repository.getData();
  }
}
```

---

## 5. Error Handling

Menggunakan `dartz` `Either<Failure, T>` pattern di seluruh domain & data layer:

```dart
// Di data source / repository
return Left(ServerFailure('Something went wrong'));
return Right(data);

// Di provider / use case
result.fold(
  (failure) => state = FeatureError(failure.message),
  (data) => state = FeatureLoaded(data),
);
```

Failure types tersedia di `core/error/failures.dart`:

- `ServerFailure` -- error server/database
- `NetworkFailure` -- tidak ada koneksi
- `AuthenticationFailure` -- auth gagal
- `ValidationFailure` -- validasi input
- `DataNotFoundFailure` -- data tidak ada
- `DataConflictFailure` -- data duplikat

---

## 6. Styling & Theme

Semua styling menggunakan design system dari `core/theme/`:

| Class                                       | Penggunaan                          |
| ------------------------------------------- | ----------------------------------- |
| `AppColors.primary`                         | Warna utama (#135BEC)               |
| `AppColors.success` / `.error` / `.warning` | Status colors                       |
| `AppTypography.headlineMedium`              | Text styles (Manrope font)          |
| `AppSpacing.lg` (16)                        | Spacing values (4/8/12/16/20/24/32) |
| `AppRadius.mdRadius`                        | Border radius presets               |
| `AppShadows.card`                           | Shadow presets                      |

**JANGAN** hardcode warna, font size, atau spacing. Selalu gunakan design system.

---

## 7. Routing

Route di `core/router/app_router.dart`:

```dart
GoRoute(
  path: '/feature/sub-route',
  name: 'feature-sub-route',
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>?;
    return FeatureScreen(param: extra?['key']);
  },
),
```

**Navigasi dari screen:**

```dart
// Push with result
final result = await context.push<bool>('/route', extra: {'key': value});
if (result == true) ref.read(provider.notifier).refresh();

// Pop with result
context.pop(true);
```

---

## 8. Checklist Membuat Feature Baru

1. [ ] Buat folder structure: `lib/features/<name>/`
2. [ ] Buat entity di `domain/entities/`
3. [ ] Buat repository contract di `domain/repositories/`
4. [ ] Buat use case(s) di `domain/usecases/`
5. [ ] Buat model (extends entity) di `data/models/`
6. [ ] Buat data source di `data/datasources/`
7. [ ] Buat repository impl di `data/repositories/`
8. [ ] Buat sealed state class di `presentation/providers/<feature>_states.dart`
9. [ ] Buat providers di `presentation/providers/<feature>_providers.dart`
10. [ ] Run `dart run build_runner build --delete-conflicting-outputs`
11. [ ] Buat screen di `presentation/screens/`
12. [ ] Buat widgets di `presentation/widgets/`
13. [ ] Tambah route di `core/router/app_router.dart`
14. [ ] Run `flutter analyze` -- pastikan 0 error/warning
