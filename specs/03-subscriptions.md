# 03 - Subscriptions

## Overview

Premium features are gated via RevenueCat. The app uses RevenueCat's native UI for paywalls. Entitlements are synced to Supabase via webhooks for server-side feature checks (particularly for AI Insights edge function).

## Requirements

### Functional Requirements

- [ ] Initialize RevenueCat SDK on app launch
- [ ] Display RevenueCat paywall UI when accessing premium features
- [ ] Check entitlements before accessing gated features
- [ ] Sync entitlements to Supabase via webhook
- [ ] Support restore purchases functionality
- [ ] Handle subscription expiration gracefully

### Non-Functional Requirements

- [ ] Entitlement checks must be fast (cached locally)
- [ ] Paywall must be displayed within 500ms
- [ ] Webhook must process within 5 seconds

## Architecture

### Premium Features

| Feature Code | Description |
|--------------|-------------|
| `ai_insights` | Access to AI-powered activity insights |
| `custom_activity` | Create custom activities with detail fields |
| `name_override` | Custom naming for logged activities |

### Entitlement Flow

```
1. User attempts premium action
2. Check local entitlement cache
3. If not entitled:
   - Display RevenueCat paywall
   - User completes purchase
   - RevenueCat webhook fires
   - Supabase updates user_entitlement
   - Local cache updated
4. If entitled: Allow action
```

### Webhook Flow

```
RevenueCat Event → Supabase Edge Function → Update user_entitlement table
```

## Components

### Files to Create

```
lib/features/subscriptions/
├── data/
│   └── subscription_repository.dart
├── domain/
│   ├── entitlement.dart
│   ├── subscription_exception.dart
│   └── feature_code.dart
└── presentation/
    ├── providers/
    │   ├── subscription_service_provider.dart
    │   └── entitlement_provider.dart
    └── widgets/
        └── premium_gate.dart
```

### Key Classes

| Class | Purpose |
|-------|---------|
| `SubscriptionRepository` | RevenueCat SDK interactions |
| `SubscriptionService` | Business logic for entitlements |
| `Entitlement` | Domain model for entitlements |
| `FeatureCode` | Enum of premium feature codes |
| `PremiumGate` | Widget that shows paywall if not entitled |

## Data Operations

### Initialize RevenueCat

```dart
Future<void> initializeRevenueCat(String userId) async {
  await Purchases.configure(
    PurchasesConfiguration(apiKey)
      ..appUserID = userId,
  );
}
```

### Check Entitlement

```dart
Future<bool> hasFeature(FeatureCode feature) async {
  final customerInfo = await Purchases.getCustomerInfo();
  return customerInfo.entitlements.active.containsKey(feature.value);
}
```

### Show Paywall

```dart
Future<void> showPaywall(BuildContext context) async {
  await RevenueCatUI.presentPaywall();
}
```

### Restore Purchases

```dart
Future<void> restorePurchases() async {
  await Purchases.restorePurchases();
}
```

## Database Schema

### revenue_cat.entitlement

| Column | Type | Description |
|--------|------|-------------|
| entitlement_id | uuid | Primary key |
| code | text | Entitlement code (e.g., 'pro') |

### revenue_cat.feature

| Column | Type | Description |
|--------|------|-------------|
| name | text | Feature code (primary key) |

### revenue_cat.entitlement_feature

| Column | Type | Description |
|--------|------|-------------|
| entitlement_id | uuid | FK to entitlement |
| feature | text | FK to feature |

### revenue_cat.user_entitlement

| Column | Type | Description |
|--------|------|-------------|
| user_id | uuid | FK to profile |
| entitlement_id | uuid | FK to entitlement |
| active_until | timestamptz | Expiration date |

## Integration Points

- **Core**: RevenueCat initialized in bootstrap
- **Auth**: User ID passed to RevenueCat on sign-in
- **Activity Logging**: Name override gated
- **Activity Catalog**: Custom activity creation gated
- **AI Insights**: Entire feature gated

## Testing Requirements

### Unit Tests

- [ ] SubscriptionService correctly checks entitlements
- [ ] Feature codes map correctly
- [ ] Expiration logic handles edge cases

### Widget Tests

- [ ] PremiumGate shows content when entitled
- [ ] PremiumGate shows paywall trigger when not entitled

### Integration Tests

- [ ] RevenueCat SDK initializes correctly
- [ ] Paywall displays and handles purchase
- [ ] Webhook updates database correctly

## Success Criteria

- [ ] RevenueCat SDK initializes without errors
- [ ] Entitlement checks work online and offline (cached)
- [ ] Paywall displays correctly
- [ ] Purchases sync to Supabase
- [ ] Restore purchases works
- [ ] Subscription expiration handled gracefully
- [ ] All three premium features properly gated
