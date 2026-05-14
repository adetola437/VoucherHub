# Architecture

## Overview

The app is built with **Flutter** using a **feature-first Clean Architecture** approach, combined with **BLoC/Cubit** for state management. Every feature is self-contained and follows the same layered structure, making it easy to navigate, test, and extend.

```
Presentation  ←→  Domain (Cubit + Repository Interface)  ←→  Data
```

---

## Architectural Layers

### 1. Data Layer

Responsible for all external communication and data serialisation.

| Component | Responsibility |
|-----------|---------------|
| `RemoteDataSource` | Makes raw API calls via `IApiService` and returns typed models |
| `Model` | Plain Dart class with `fromJson` / `toJson`. No business logic. |
| `RepositoryImpl` | Implements the domain repository interface by delegating to the data source |

### 2. Domain Layer (lightweight)

Rather than a separate `domain/` folder with use-case classes, the domain contract lives as a repository interface (`IXxxRepository`) co-located inside the feature's `data/repository/` folder. The Cubit depends on this interface, not the implementation — keeping the dependency arrow pointing inward.

### 3. Presentation Layer

Each screen is split into three files that share a single part/part-of relationship:

| File | Role |
|------|------|
| `contracts/xxx.dart` | Abstract interfaces for both the controller and the view |
| `controllers/xxx.dart` | Concrete controller — owns the Cubit, handles navigation and user actions |
| `views/xxx.dart` | Pure UI widget — declared as `part of` the controller file |

This separation means the view never knows how navigation or business logic is wired; it only calls methods on the controller contract. Swapping a view implementation requires zero changes to the controller.

---

## State Management — BLoC/Cubit

Each feature has a single `XxxCubit` with a sealed state hierarchy:

```
AuthCubit       → AuthInitial | AuthLoading | AuthAuthenticated | AuthUnauthenticated | AuthError
ProductsCubit   → ProductsInitial | ProductsLoading | ProductsLoaded | ProductsError | ProductDetailLoading | ProductDetailLoaded
CartCubit       → CartInitial | CartLoading | CartLoaded | CartItemAdded | CartError
CheckoutCubit   → CheckoutInitial | CheckoutCalculating | CheckoutTotalLoaded | CheckoutProcessing | CheckoutSuccess | CheckoutFailure | CheckoutError
OrdersCubit     → OrdersInitial | OrdersLoading | OrdersLoaded | OrderDetailLoading | OrderDetailLoaded | OrdersError
VouchersCubit   → VouchersInitial | VouchersLoading | VouchersLoaded | VoucherDetailLoading | VoucherDetailLoaded | VouchersError
```

Cubits are registered as `lazySingletons` in `AppInitializer` via **GetIt**, so they survive navigation and share state across screens (e.g. the cart badge in the catalogue app bar reacts to `CartCubit` without being explicitly passed).

---

## Dependency Injection

`AppInitializer` bootstraps the entire dependency graph at startup in four ordered phases:

1. **Core** — `SharedPreferences`, `FlutterSecureStorage`, `NetworkInfo`, `SecureStorage`, `LocalStorage`, `IApiClient`, `IApiService`
2. **Data Sources** — one `IXxxRemoteDataSource` per feature
3. **Repositories** — one `IXxxRepository` per feature, injected with its data source (and optionally `LocalStorage` for caching)
4. **Cubits** — one `XxxCubit` per feature, injected with its repository

This order guarantees every dependency is available before the widget tree is built.

---

## Networking

```
IApiService  →  IApiClient (Dio)  →  VoucherHub REST API
```

| Component | Detail |
|-----------|--------|
| **Dio** | HTTP client with `BaseOptions` (base URL, timeouts from `.env`) |
| **`_AuthInterceptor`** | Reads the JWT from `SecureStorage` on every request and injects `Authorization: Bearer <token>` |
| **`PrettyDioLogger`** | Request/response logging — active in **debug builds only** (`kDebugMode`) |
| **`IApiClient.request<T>`** | Generic method that handles the `{ success, data, message }` envelope, unwraps `data`, and returns `Either<Failure, T>` |
| **`Failure` hierarchy** | `NetworkFailure`, `ServerFailure`, `ValidationFailure`, `UnauthorizedFailure`, `TimeoutFailure`, `CancelledFailure`, `UnknownFailure` — mapped from every possible Dio exception and HTTP status code |

---

## Navigation

Navigation uses **GoRouter** with a `StatefulShellRoute` for the persistent bottom navigation bar (Catalogue / Cart / Orders / Vouchers / Profile). Full-screen routes (product detail, checkout, voucher detail, etc.) are registered above the shell so they cover the bottom bar.

The app always starts at `/splash`. The `SplashScreen` checks `LocalStorage` for a stored JWT and redirects to either `/products` (authenticated) or `/login` (unauthenticated).

---

## Security

| Concern | Implementation |
|---------|---------------|
| JWT storage | `flutter_secure_storage` (Keychain on iOS, EncryptedSharedPreferences on Android) |
| Token injection | `_AuthInterceptor` — never hardcoded in request bodies |
| Debug logging | `PrettyDioLogger` is compile-time excluded from release builds via `kDebugMode` |
| Session persistence | Token expiry is stored alongside the token; `SplashScreen` checks validity on launch |

---

## Local Persistence

| Data | Storage | Key |
|------|---------|-----|
| JWT access token | `SecureStorage` (encrypted) | `access_token` |
| Token expiry | `SharedPreferences` | `token_expiry` |
| User profile JSON | `SharedPreferences` | `user_data` |
| Product catalogue cache | `SharedPreferences` | `product_catalogue` |

The product catalogue is cached after the first successful fetch and served from cache on subsequent launches, with a pull-to-refresh to force a network update.

---

## Data Flow — End to End Example (Add to Cart)

```
User taps "Add to Cart"
  → ProductDetailController.addToCart()
    → CartCubit.addToCart(productCode, amount, quantity)
      → CartRepositoryImpl.addToCart(...)
        → CartRemoteDataSourceImpl.addToCart(...)
          → IApiService.post('/cart/items', body: {...})
            → IApiClient.request<CartModel>(...)
              → Dio POST  →  VoucherHub API
              ← Response JSON
            ← Either<Failure, CartModel>
          ← Either<Failure, CartModel>
        ← Either<Failure, CartModel>
      → emit(CartItemAdded(cart))  or  emit(CartError(message))
    ← BlocConsumer in ProductDetailView reacts
      → SnackBar "Item added to cart" + pop screen  (success)
      → SnackBar with error message                 (failure)
```

---

## Key Libraries

| Library | Purpose |
|---------|---------|
| `flutter_bloc` | BLoC/Cubit state management |
| `get_it` | Service locator / dependency injection |
| `dio` | HTTP client |
| `dartz` | Functional `Either` type for error handling |
| `go_router` | Declarative navigation |
| `flutter_secure_storage` | Encrypted token storage |
| `shared_preferences` | Lightweight local persistence |
| `flutter_screenutil` | Responsive layout sizing |
| `shimmer` | Loading skeleton animations |
| `url_launcher` | Open redemption URLs in the browser |
| `flutter_dotenv` | `.env` configuration file loading |
| `equatable` | Value equality for models and states |
| `pretty_dio_logger` | Debug-only network logging |
