# 05a - Custom Name Feature

## Overview

The Custom Name feature allows premium users to override the default activity name with a personalized label (e.g., "Morning Run" instead of "Running"). This name appears everywhere the activity is displayed, including home chips, edit screens, and statistics. The feature is gated behind the `activityNameOverride` entitlement.

## Requirements

### Functional Requirements

- [ ] Display Custom Name text field on Log Activity screen
- [ ] Display Custom Name text field on Edit Activity screen
- [ ] Field positioned after Date picker, before Subactivity selector
- [ ] Freeform text input with 50 character limit
- [ ] Generic placeholder: "e.g. Morning Run"
- [ ] Premium-only: non-premium users see disabled field with lock icon
- [ ] Tapping locked field navigates to subscription screen via paywall
- [ ] Existing custom names display even if subscription lapses (read-only)
- [ ] Lapsed users cannot add/modify custom names

### Non-Functional Requirements

- [ ] Field must sync with form state on every keystroke
- [ ] Lock icon visible in field suffix when user lacks entitlement
- [ ] Paywall must complete before returning focus to form

## Architecture

### Component Flow

```
CustomNameInput Widget
    ↓
    ├── Watch entitlementStateProvider (premium check)
    ├── Watch activityFormStateProvider (current value)
    │
    ├── [Has Access] → Enabled TextField
    │       ↓
    │       onChanged → setActivityNameOverride()
    │
    └── [No Access] → Disabled TextField + Lock Icon
            ↓
            onTap → subscriptionServiceProvider.showPaywall()
```

### State Management

The `activityFormStateProvider` already has:
- `activityNameOverride` field in `ActivityFormState`
- `setActivityNameOverride(String?)` method
- Proper handling in `initForEdit()` and `submit()`

No changes needed to the provider - only UI implementation required.

### Premium Gating

Use existing providers:
- `entitlementStateProvider` - reactive state with `hasFeature(FeatureCode.activityNameOverride)`
- `subscriptionServiceProvider` - `showPaywall()` method for upgrade flow

## Components

### Files to Create

```
lib/features/activity_logging/presentation/widgets/
└── custom_name_input.dart
```

### Files to Modify

```
lib/features/activity_logging/presentation/screens/
├── log_activity_screen.dart
└── edit_activity_screen.dart
```

### CustomNameInput Widget

Reusable widget encapsulating:
- Premium entitlement check
- Text field with lock icon suffix (when locked)
- Paywall trigger on tap (when locked)
- TextEditingController management
- Form state synchronization

```dart
class CustomNameInput extends ConsumerStatefulWidget {
  const CustomNameInput({
    this.initialValue,
    super.key,
  });

  final String? initialValue;
}
```

**Props:**
- `initialValue` - Pre-populate field when editing existing activity

**Behavior:**
- Watch `entitlementStateProvider` to determine access
- Watch `activityFormStateProvider` for current value
- On change: call `setActivityNameOverride()`
- On tap (locked): call `subscriptionServiceProvider.showPaywall()`

## Data Operations

No new data operations required. The existing form submission flow already handles `activityNameOverride`:

- `prepareOptimisticSave()` - includes override in request
- `submit()` - passes override to service for create/update
- `initForEdit()` - loads existing override from `UserActivity`

## Integration

### With Subscription System

```dart
final entitlements = ref.watch(entitlementStateProvider);
final hasAccess = entitlements.hasFeature(FeatureCode.activityNameOverride);
```

### With Form State

```dart
ref.read(activityFormStateProvider.notifier).setActivityNameOverride(value);
```

### With Paywall

```dart
await ref.read(subscriptionServiceProvider).showPaywall();
```

## Testing Requirements

### Unit Tests

- [ ] CustomNameInput respects 50 character limit
- [ ] setActivityNameOverride updates form state correctly
- [ ] Form submission includes nameOverride in request

### Widget Tests

- [ ] Field enabled when user has activityNameOverride entitlement
- [ ] Field disabled with lock icon when user lacks entitlement
- [ ] Tapping locked field triggers paywall
- [ ] initialValue pre-populates field correctly
- [ ] Typing updates form state
- [ ] Lapsed user sees existing name but cannot edit

### Integration Tests

- [ ] Full log flow saves custom name to database
- [ ] Edit flow displays and updates existing custom name
- [ ] Custom name appears on home screen chips after save

## Future Considerations

- **Name Suggestions**: Could add time-based or subactivity-based suggestions (e.g., auto-suggest "Morning Run" at 7am)
- **Name History**: Could track frequently used names for quick selection
- **Name Templates**: Could allow users to create reusable name templates

## Success Criteria

- [ ] CustomNameInput widget created with premium gating
- [ ] Widget integrated into LogActivityScreen after date picker
- [ ] Widget integrated into EditActivityScreen after date picker
- [ ] Lock icon visible for non-premium users
- [ ] Paywall triggers on locked field tap
- [ ] Premium users can enter up to 50 characters
- [ ] Existing names display for lapsed users (read-only)
- [ ] Form submission includes custom name
- [ ] Custom name displays on home screen chips

## Items to Complete

- [ ] Create `CustomNameInput` widget in `widgets/custom_name_input.dart`
- [ ] Add widget to `LogActivityScreen` after `DatePickerField`/`DateRangePicker`
- [ ] Add widget to `EditActivityScreen` after `DatePickerField`/`DateRangePicker`
- [ ] Write widget tests for premium gating behavior
- [ ] Write widget tests for text input behavior
- [ ] Manual QA: test premium flow end-to-end
- [ ] Manual QA: test lapsed subscription behavior
