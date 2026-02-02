# External Integrations

**Analysis Date:** 2026-02-02

## APIs & External Services

**Backend as a Service:**
- **Supabase** - Core backend platform
  - PostgREST API for database operations
  - Auth for user management and OAuth
  - Storage for file uploads
  - Edge Functions for serverless logic
  - Realtime subscriptions (configured but disabled locally)
  - SDK: `supabase_flutter` 2.12.0
  - Configuration: `SUPABASE_URL`, `SUPABASE_ANON_KEY` in env files
  - URL formats:
    - Dev: `http://127.0.0.1:54321` (local Supabase)
    - Staging/Prod: `https://<project>.supabase.co`

**Monetization:**
- **RevenueCat** - In-app purchases and subscription management
  - Handles iOS App Store and Google Play billing
  - Cross-platform entitlement checking
  - Synced with Supabase user ID for subscription status
  - SDK: `purchases_flutter` 9.10.7, `purchases_ui_flutter` 9.10.7
  - API Keys: `REVENUE_CAT_API_KEY_TEST`, `REVENUE_CAT_API_KEY_APPLE`, `REVENUE_CAT_API_KEY_GOOGLE`
  - Repository: `lib/features/subscriptions/data/subscription_repository.dart`
  - Service: `lib/features/subscriptions/presentation/providers/subscription_service_provider.dart`
  - Features controlled via entitlements (e.g., `logly-pro`)

**Analytics:**
- **Mixpanel** - Event analytics and user tracking
  - SDK: `mixpanel_flutter` 2.4.4
  - Integrated but no explicit configuration in env files (may use SDK defaults)

**Feature Flags & A/B Testing:**
- **GrowthBook** - Feature flag management and experiments
  - SDK: `growthbook_sdk_flutter` 4.1.1
  - Enables runtime feature toggles without app updates

**Error Tracking:**
- **Sentry** - Crash reporting and error monitoring
  - SDK: `sentry_flutter` 9.10.0
  - Configuration: `SENTRY_DSN` in env files (only for non-debug builds)
  - Environment detection: `development`, `staging`, or `production` based on Supabase URL
  - Sample rates: 20% for production, 100% for staging/dev
  - Screenshots and view hierarchy attachment enabled
  - Breadcrumb integration via `LoggerService` in `lib/core/services/logger_service.dart`
  - Initializer: `lib/core/services/sentry_initializer.dart` syncs user context on auth changes

## Data Storage

**Databases:**
- **PostgreSQL 17** (via Supabase)
  - Remote: Production and staging hosted by Supabase
  - Local: PostgreSQL 17 in development via Supabase local emulation
  - Client: PostgREST (RESTful access), not direct SQL
  - Operations through `supabase_flutter` SDK using PostgREST endpoints
  - Connection: `SUPABASE_URL` and `SUPABASE_ANON_KEY`

**SQLite (Local Caching):**
- **SQLite 3** via Drift ORM
  - Local file: `~/Documents/logly.sqlite` (from `getApplicationDocumentsDirectory()`)
  - Purpose: Offline cache for activities, log entries, and user data
  - Schema: Single `CachedData` table with id, type, data (JSON), expiresAt
  - ORM: Drift 2.22.1 (`lib/app/database/drift_database.dart`)
  - Automatic schema management with migration support

**File Storage:**
- **Supabase Storage** - User-uploaded files and attachments
  - Not actively used in current implementation
  - File size limit: 50MiB per Supabase config
  - Configuration: `lib/app/app.dart` clears cache on startup

**Caching:**
- **In-Memory & SharedPreferences**
  - SharedPreferences 2.5.4 for user preferences
  - Riverpod for in-memory state caching
  - Flutter Cache Manager 3.4.1 for network image caching
  - Default cache cleared on app launch

## Authentication & Identity

**Auth Providers:**
- **Supabase Auth** - Primary authentication backend
  - OAuth 2.0 integration with Google and Apple
  - Session management via JWT tokens
  - Email/password auth capability (not currently used)
  - Token storage: `flutter_secure_storage` 10.0.0
  - Stream: `AuthRepository.authStateChanges` for reactive auth state

- **Google Sign-In**
  - SDK: `google_sign_in` 6.2.2
  - Client IDs (env vars):
    - Web: `GOOGLE_WEB_CLIENT_ID` (used as serverClientId)
    - iOS: `GOOGLE_IOS_CLIENT_ID`
    - Android: Package name + SHA-1 fingerprint (configured in Google Cloud Console)
  - Integration: `lib/features/auth/data/auth_repository.dart` line 77-110
  - Flow: Google Sign-In → ID token → Supabase signInWithIdToken

- **Apple Sign-In**
  - SDK: `sign_in_with_apple` 6.1.4
  - Scope: Email permission requested
  - Integration: `lib/features/auth/data/auth_repository.dart` line 30-71
  - Flow: Apple credential → Identity token → Supabase signInWithIdToken

**Token Management:**
- Tokens stored encrypted via `flutter_secure_storage`
- Supabase manages token refresh automatically
- RevenueCat user login synced to Supabase user ID in `SubscriptionRepository.loginUser()`

## Monitoring & Observability

**Error Tracking:**
- **Sentry** (see error tracking above)
  - Breadcrumbs added for debug, info, warning logs
  - Error events with technical details and exception type tags
  - User context (ID, email) set when authenticated
  - Disabled in debug mode

**Logs:**
- **Console logging** via `logger` 2.5.0 package
  - Pretty printer with method count and colors
  - Level: DEBUG in development, WARNING in release
  - File: `lib/core/services/logger_service.dart`
  - Sentry integration: Logs ≥ warning level sent as breadcrumbs/events

## Health Integration

**Apple HealthKit (iOS):**
- **Health Package** 13.2.1
  - Data types: Workouts, active energy burned, distance
  - Permissions: WORKOUT type required
  - Repository: `lib/features/health_integration/data/health_repository.dart`

**Google Health Connect (Android):**
- **Health Package** 13.2.1
  - Data types: Workouts, distance delta, calories burned
  - Permissions: HEALTH type required
  - Same repository as iOS via platform-specific implementations

**Permissions:**
- SDK: `permission_handler` 12.0.1
  - Platform-specific permission requests
  - iOS/Android permissions configured in native build files
  - Service: `lib/features/health_integration/application/health_sync_service.dart`

**Syncing:**
- Stored procedures in Supabase for workout ingestion
  - Path: `supabase/migrations/` - see drift and health-related migrations
- Initializer: `lib/features/health_integration/application/health_sync_initializer.dart`

## Device & System Integration

**Device Information:**
- **Device Info Plus** 12.3.0 - Device model, OS version
- **Flutter UDID** 4.1.1 - Unique device identifier
- **Package Info Plus** 9.0.0 - App version and build number

**Notifications:**
- **Flutter Local Notifications** 19.5.0 - Local push notifications
  - Android: Notification channel "logly_reminders" (ID: `logly_reminders`)
  - iOS: Badge, alert, sound permissions requested (but not auto-granted)
  - Timezone: Via `timezone` 0.10.0 package
  - Service: `lib/features/settings/application/notification_service.dart`
  - Daily reminder ID: 0

**System Integration:**
- **Share Plus** 12.0.1 - Share exported data, share app links
- **URL Launcher** 6.3.2 - Open URLs, email, phone numbers
- **App Settings** 7.0.0 - Direct navigation to system settings
- **In App Review** 2.0.11 - Prompt user to rate app

## CI/CD & Deployment

**Hosting:**
- **Supabase** - Backend API, Auth, Database, Storage (prod/staging only)
- **iOS App Store** - iOS app distribution
- **Google Play Store** - Android app distribution

**CI Pipeline:**
- **Codemagic** (`codemagic.yaml`)
  - Flutter build automation for iOS and Android
  - Flavor support: development, staging, production
  - App signing, provisioning profiles, keystores

**Local Development:**
- **Supabase CLI** - Local PostgreSQL and API emulation
  - Config: `supabase/config.toml`
  - Ports: API (54321), DB (54322), Studio (54323), Email (54324)
  - Runs migrations automatically on `supabase start`

## Environment Configuration

**Required Env Vars by Flavor:**

**Development (.env.development):**
- `SUPABASE_URL=http://127.0.0.1:54321` (local)
- `SUPABASE_ANON_KEY=<local-key>`
- `GOOGLE_WEB_CLIENT_ID`
- `GOOGLE_IOS_CLIENT_ID`
- `GOOGLE_ANDROID_CLIENT_ID`
- `REVENUE_CAT_API_KEY_TEST` (sandbox testing)
- `SENTRY_DSN` (optional, empty in dev)

**Staging (.env.staging):**
- `SUPABASE_URL=https://your-staging-project.supabase.co`
- `SUPABASE_ANON_KEY=<staging-key>`
- Google client IDs
- `REVENUE_CAT_API_KEY_TEST` or platform-specific keys
- `SENTRY_DSN=https://YOUR_STAGING_KEY@...`

**Production (.env.production):**
- `SUPABASE_URL=https://vblosujbjjfiprmlzhyx.supabase.co` (actual prod)
- `SUPABASE_ANON_KEY=<prod-key>`
- Google client IDs
- `REVENUE_CAT_API_KEY_APPLE`, `REVENUE_CAT_API_KEY_GOOGLE`
- `SENTRY_DSN=https://YOUR_PRODUCTION_KEY@...`

**Secrets Location:**
- Env files in `env/` directory (not committed to Git)
- Secrets injected at build time via CI/CD (Codemagic, GitHub Actions)
- Sensitive data: OAuth credentials, Supabase keys, RevenueCat keys stored securely

## Webhooks & Callbacks

**Incoming:**
- None explicitly configured

**Outgoing:**
- None explicitly configured

**Supabase Realtime (Disabled):**
- WebSocket subscriptions available but disabled in local config
- Could be enabled for real-time activity sync in future

---

*Integration audit: 2026-02-02*
