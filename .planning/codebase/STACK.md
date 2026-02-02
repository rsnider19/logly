# Technology Stack

**Analysis Date:** 2026-02-02

## Languages

**Primary:**
- Dart 3.9.0+ - Flutter app, core business logic, repositories, services
- TypeScript - Supabase migrations, database types, edge functions, seed scripts
- SQL - Database migrations, stored procedures, seed data
- YAML - Flutter configuration, CI/CD

**Secondary:**
- Kotlin - Android native integrations
- Swift - iOS native integrations

## Runtime

**Environment:**
- Flutter 3.35.0+ - Mobile framework targeting iOS and Android
- Dart SDK 3.9.0+ - Dart runtime included in Flutter SDK

**Package Manager:**
- Pub (Dart package manager) - Primary dependency management
- Lockfile: `pubspec.lock` present (68KB lock file)

## Frameworks

**Core:**
- Flutter 3.35.0+ - Cross-platform mobile UI framework
- Supabase (PostgREST API) 2.12.0 - Backend as a Service for auth, database, storage
- Riverpod 3.2.0 - State management with code generation via `riverpod_generator` 4.0.2
- Go Router 17.0.1 - Navigation with `go_router_builder` 4.1.3 for strong typing

**Backend Infrastructure:**
- PostgreSQL 17 (via Supabase) - Primary relational database
- Drift 2.22.1 - Local SQLite ORM for offline caching with code generation via `drift_dev` 2.22.2
- SQLite 3 - Local client-side database on device

**Code Generation:**
- Freezed 3.0.6 - Immutable data classes with `freezed_annotation` 3.1.0
- JSON Serializable 6.11.3 - JSON serialization via `json_annotation` 4.9.0
- Riverpod Generator 4.0.2 - Provider code generation via `riverpod_annotation` 4.0.1
- Flutter Gen 5.12.0 - Asset reference generation via `flutter_gen_runner`
- Build Runner 2.10.5 - Code generation orchestrator

**Testing:**
- Flutter Test - Built-in test framework
- Mocktail 1.0.4 - Mocking library for unit tests
- Very Good Analysis 10.0.0 - Linting rules

**Build & Development:**
- Flutter Build Runner - Code generation for Drift, Freezed, Riverpod, JSON serializable
- FVM (Flutter Version Manager) - Flutter SDK management (configured in `.fvmrc`)
- Custom Lint 0.8.1 - Custom analysis rules
- Riverpod Lint 3.1.2 - Riverpod-specific lint rules
- Sentry Dart Plugin 3.2.1 - Error reporting integration
- Flutter Launcher Icons 0.14.4 - App icon generation
- Flutter Native Splash 2.4.7 - Splash screen generation

## Key Dependencies

**Critical:**
- `supabase_flutter` 2.12.0 - Supabase client with auth, database, storage, RPC support
- `supabase_auth_ui` 0.5.5 - Pre-built auth UI components
- `purchases_flutter` 9.10.7 - RevenueCat SDK for in-app purchases (iOS)
- `purchases_ui_flutter` 9.10.7 - RevenueCat purchase UI components
- `riverpod_annotation` 4.0.1 - Provider annotations for code generation
- `flutter_riverpod` 3.2.0 - State management provider system

**State & Data:**
- `drift` 2.22.1 - Local SQLite caching ORM with compile-time safety
- `shared_preferences` 2.5.4 - Key-value local storage for user preferences
- `flutter_secure_storage` 10.0.0 - Encrypted local storage for sensitive data

**Health & Fitness Integration:**
- `health` 13.2.1 - Cross-platform health data access (HealthKit on iOS, Google Health Connect on Android)
- `permission_handler` 12.0.1 - Unified permissions API for iOS/Android

**Analytics & Error Tracking:**
- `sentry_flutter` 9.10.0 - Error tracking and crash reporting in non-debug builds
- `logger` 2.5.0 - Structured logging with Sentry breadcrumb integration
- `mixpanel_flutter` 2.4.4 - Analytics (imported but usage not directly visible in main codebase)
- `growthbook_sdk_flutter` 4.1.1 - Feature flags and A/B testing

**Device & System:**
- `device_info_plus` 12.3.0 - Device information access
- `flutter_udid` 4.1.1 - Unique device identifier
- `package_info_plus` 9.0.0 - App version and build info
- `path_provider` 2.1.5 - Standard app directories access
- `timezone` 0.10.0 - Timezone database for scheduled notifications
- `intl` 0.20.2 - Internationalization and localization

**Authentication:**
- `google_sign_in` 6.2.2 - Google OAuth integration
- `sign_in_with_apple` 6.1.4 - Apple Sign-in integration
- `flutter_secure_storage` 10.0.0 - Token storage

**Notifications:**
- `flutter_local_notifications` 19.5.0 - Local push notifications (scheduled daily reminders)

**UI & Styling:**
- `flutter_svg` 2.2.3 - SVG rendering
- `shimmer` 3.0.0 - Loading state shimmer effect
- `cached_network_image` 3.4.1 - Image caching and loading
- `flex_color_scheme` 8.2.0 - Color scheme management
- `lucide_icons_flutter` 3.1.9 - Icon library
- `auto_size_text` 3.0.0 - Responsive text sizing
- `gap` 3.0.1 - Consistent spacing utility
- `dotted_border` 3.1.0 - Styled borders
- `smooth_page_indicator` 2.0.1 - Page indicator
- `table_calendar` 3.2.0 - Calendar widget
- `fl_chart` 1.1.1 - Charts and graphs for activity statistics
- `visibility_detector` 0.4.0+2 - Visibility detection for widgets

**Chat & AI:**
- `flutter_chat_core` 2.9.0 - Chat UI framework
- `flutter_chat_ui` 2.11.1 - Pre-built chat UI components
- `flyer_chat_text_stream_message` 2.3.0 - Streaming message support for AI responses
- `gpt_markdown` 1.1.5 - Markdown rendering for LLM responses

**Utilities & Helpers:**
- `uuid` 4.5.2 - UUID generation
- `recase` 4.1.0 - String case conversion
- `dartx` 1.2.0 - Dart extension library
- `path` 1.9.0 - Cross-platform path manipulation
- `url_launcher` 6.3.2 - System URL handling
- `share_plus` 12.0.1 - System share sheet integration
- `in_app_review` 2.0.11 - In-app review prompt
- `app_settings` 7.0.0 - Direct app settings navigation
- `timeago` 3.7.1 - Human-readable relative dates
- `infinite_scroll_pagination` 5.1.1 - Pagination for lists
- `flutter_cache_manager` 3.4.1 - Cache management
- `flutter_dotenv` 6.0.0 - Environment variable loading from .env files

## Configuration

**Environment:**
- Three flavor configuration via `.env` files in `env/` directory:
  - `env/.env.development` - Local Supabase, test API keys
  - `env/.env.staging` - Staging Supabase, staging credentials
  - `env/.env.production` - Production Supabase, production credentials
- Loaded at startup via `EnvService.load(envPath)` in `bootstrap.dart`
- Variables accessed through type-safe `EnvService` getters in `lib/core/services/env_service.dart`

**Build:**
- `pubspec.yaml` - Dart package manifest with all dependencies
- `build.yaml` - Build runner configuration
- `analysis_options.yaml` - Lint rules via `very_good_analysis`
- `.fvmrc` - Flutter version pinning
- `flutter_gen_runner` configuration - Asset generation
- `devtools_options.yaml` - DevTools configuration

**Platform-specific:**
- `android/` - Android native code, permissions, app signing configuration
- `ios/` - iOS native code, permissions, podfile dependencies
- `macos/` - macOS app configuration (if applicable)

## Platform Requirements

**Development:**
- macOS or Linux for Flutter SDK
- Dart SDK 3.9.0+
- Flutter 3.35.0+
- FVM (Flutter Version Manager) recommended - version pinned in `.fvmrc`
- Xcode 14+ (for iOS development)
- Android SDK 34+ with NDK (for Android development)
- Very Good CLI for running tests with coverage

**Production:**
- iOS 12.0+ (iOS deployment target in Xcode)
- Android API 21+ (minSdkVersion in Android build config)
- Deployment via App Store (iOS) and Google Play Store (Android)
- CI/CD via Codemagic (see `codemagic.yaml` for build and deployment pipeline)

---

*Stack analysis: 2026-02-02*
