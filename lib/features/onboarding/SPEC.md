# Onboarding Feature Spec

## Overview

A multi-phase onboarding flow that introduces new users to Logly, collects personalization data, authenticates, and sets up their activity preferences and health integrations.

**Flow:** Value Prop (3 pages) → Transition → Getting to Know You (6 questions) → Sign In → Transition → Favorites → Health → Home

## Requirements

### Value Prop Screens
- 3 existing pages: Track Everything, Build Streaks, Get Insights
- PageView with dot indicator (existing implementation)
- Skip button (top-right) and Next/Get Started button (bottom)
- "Get Started" on last page navigates to `/onboarding/questions`

### Getting to Know You Questions
- 6 questions presented in a shell with segmented progress bar (6 segments)
- Shell provides: back button (top-left), skip button (top-right), continue button (bottom)
- Back hidden on first question (Gender); skip hidden on transition screen
- Continue always enabled (no selection = same as skip = field left null)
- Skip advances to next question only, not skip-all
- Horizontal slide animation (PageView) for content transitions
- Transition screen before first question: "Let's get to know you" / "Answer a few quick questions to personalize your experience"

#### Questions (in order):
1. **Gender** — RadioListTile: Male, Female, Prefer not to say
2. **Birthday** — CupertinoPicker: Month/Day/Year, age range 13-120, default year 2000
3. **Units** — RadioListTile: Imperial, Metric (writes to existing `unit_system` column)
4. **What brought you here?** — CheckboxListTile (multiselect, 5 options, placeholder values for now)
5. **How do you like to see your progress?** — CheckboxListTile (multiselect, 5 options, placeholder)
6. **What best describes you?** — CheckboxListTile (multiselect, 5 options, placeholder)

### Sign In
- Standalone screen (no shell/progress bar)
- Existing Apple/Google sign-in implementation
- After auth completes, router redirects to post-auth setup

### Post-Auth Setup
- Shell with segmented progress bar (2 segments)
- Transition screen: "Set up your activities" / "Choose your favorites and connect your health data"
- Step 1: Favorites selection (refactored from existing screen)
- Step 2: Health permissions (refactored from existing screen)
- Back hidden on favorites; skip available on both
- On completion: calls `completeOnboarding()` and navigates to home

### Returning Users
- If profile questions NOT answered → show questions flow, then sign-in, then post-auth setup
- If profile questions answered → skip to post-auth setup
- Settings banner for existing users missing profile data: "Complete your profile"

## Architecture

### State Management
- **Pre-auth answers:** In-memory Riverpod `OnboardingAnswersStateNotifier` (`@Riverpod(keepAlive: true)`). Holds gender, dateOfBirth, unitSystem, motivations, progressPreferences, userDescriptors. Lost on app kill (acceptable).
- **Post-auth persistence:** `persistToServer()` writes answers to profile table after authentication.
- **Favorites state:** Existing `onboardingFavoritesStateProvider` (unchanged).

### Database Schema
Profile table additions:
- `gender` (text, nullable)
- `date_of_birth` (date, nullable)
- `motivations` (jsonb, nullable — array of strings)
- `progress_preferences` (jsonb, nullable — array of strings)
- `user_descriptors` (jsonb, nullable — array of strings)
- `unit_system` (text, existing — reused)

### Routing
- `/onboarding` — Value prop pager (existing, navigation target updated)
- `/onboarding/questions` — Getting to Know You shell (NEW)
- `/auth` — Sign in (existing, standalone)
- `/onboarding/setup` — Post-auth setup shell (NEW)
- Remove: `/onboarding/favorites`, `/onboarding/health`

### Layers
- **Domain:** `OnboardingAnswers` (Freezed), updated `ProfileData` (5 new fields)
- **Repository:** `saveProfileAnswers()`, `hasAnsweredProfileQuestions()`
- **Service:** `saveProfileAnswers(OnboardingAnswers)`, `hasAnsweredProfileQuestions()`
- **Providers:** `OnboardingAnswersStateNotifier`, `hasAnsweredProfileQuestionsProvider`

## Components

### Shared Widgets
- `SegmentedProgressBar` — reusable bar with configurable segment count and current segment
- `OnboardingTopBar` — back button + progress bar + skip button with show/hide options
- `TransitionContent` — centered icon, title, subtitle for interstitial screens

### Shell Screens
- `OnboardingQuestionsShell` — hosts transition + 6 questions in a PageView
- `PostAuthSetupShell` — hosts transition + favorites + health in a PageView

### Content Widgets
- 6 question content widgets (gender, birthday, units, motivations, progress prefs, user descriptors)
- `FavoritesContent` — extracted from `FavoritesSelectionScreen`
- `HealthContent` — extracted from `HealthPermissionScreen`

## Data Operations

| Operation | Layer | Method |
|-----------|-------|--------|
| Save profile answers | Repository | `saveProfileAnswers(gender, dateOfBirth, unitSystem, motivations, progressPreferences, userDescriptors)` |
| Check if questions answered | Repository | `hasAnsweredProfileQuestions()` |
| Save profile answers (coordinated) | Service | `saveProfileAnswers(OnboardingAnswers)` |
| Check if questions answered | Service | `hasAnsweredProfileQuestions()` |
| Hold in-memory answers | Provider | `OnboardingAnswersStateNotifier` methods |
| Persist to server | Provider | `OnboardingAnswersStateNotifier.persistToServer()` |

## Integration

- Router redirect logic updated for pre-auth onboarding routes
- Intro pager navigates to `/onboarding/questions` instead of `/onboarding/favorites`
- Post-auth setup shell persists answers in `initState`
- Settings screen shows "Complete your profile" banner via `hasAnsweredProfileQuestionsProvider`
- Existing `completeOnboarding()` call moved to end of post-auth setup shell

## Testing Requirements

- Unit tests for `OnboardingAnswers` model serialization
- Unit tests for `saveProfileAnswers` repository method (mock Supabase)
- Unit tests for `OnboardingAnswersStateNotifier` (set/toggle/persist/reset)
- Widget tests for each question content widget (selection state, provider interaction)
- Widget tests for `SegmentedProgressBar` (segment count, fill state)
- Widget tests for shell screens (navigation between steps, back/skip/continue behavior)
- Integration test for full new-user flow
- Integration test for returning user flow

## Future Considerations

- Persist pre-auth answers to SharedPreferences for app-kill resilience
- Add profile editing screen in settings (not just the banner)
- A/B test question order for completion rates
- Analytics events for each question step (completed, skipped, time spent)
- Dynamic question options from backend instead of hardcoded

## Success Criteria

- [ ] Value prop screens flow into Getting to Know You questions
- [ ] Transition screen "Let's get to know you" appears between value props and questions
- [ ] 6 question screens render correct input types (radio, cupertino picker, checkbox)
- [ ] Segmented progress bar updates correctly across questions
- [ ] Back button hidden on first question, skip advances to next only
- [ ] Continue works without selection (leaves null)
- [ ] Horizontal slide animation between questions
- [ ] Sign-in screen appears standalone after questions
- [ ] Answers persist to profile after authentication
- [ ] Transition screen "Set up your activities" appears before favorites
- [ ] Favorites and health screens work in 2-segment post-auth shell
- [ ] Onboarding completes and navigates to home
- [ ] Returning users who haven't answered questions see questions flow
- [ ] Settings banner appears for users with incomplete profile
- [ ] Birthday picker constrained to age 13-120
- [ ] Unit system writes to existing column

## Items to Complete

- [ ] Create database migration for profile question columns
- [ ] Update `ProfileData` Freezed model with new fields
- [ ] Create `OnboardingAnswers` Freezed model
- [ ] Add `SaveProfileAnswersException` to exceptions
- [ ] Add `saveProfileAnswers()` to repository
- [ ] Add `hasAnsweredProfileQuestions()` to repository
- [ ] Add service methods for profile answers
- [ ] Create `OnboardingAnswersStateNotifier` provider
- [ ] Add `hasAnsweredProfileQuestionsProvider`
- [ ] Create `SegmentedProgressBar` widget
- [ ] Create `OnboardingTopBar` widget
- [ ] Create `TransitionContent` widget
- [ ] Create `GenderQuestionContent` widget
- [ ] Create `BirthdayQuestionContent` widget
- [ ] Create `UnitsQuestionContent` widget
- [ ] Create `MotivationsQuestionContent` widget
- [ ] Create `ProgressPreferencesQuestionContent` widget
- [ ] Create `UserDescriptorsQuestionContent` widget
- [ ] Create `OnboardingQuestionsShell` screen
- [ ] Extract `FavoritesContent` widget
- [ ] Extract `HealthContent` widget
- [ ] Create `PostAuthSetupShell` screen
- [ ] Add `OnboardingQuestionsRoute` to routes
- [ ] Add `OnboardingSetupRoute` to routes
- [ ] Remove old favorites/health routes
- [ ] Update router redirect logic
- [ ] Update intro pager navigation target
- [ ] Add settings banner for profile completion
- [ ] Run code generation
- [ ] Run analysis and lint
- [ ] Test full new-user flow
- [ ] Test returning-user flow
- [ ] Test settings banner flow
