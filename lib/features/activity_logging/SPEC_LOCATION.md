# Location Logging Feature Specification

## Overview

Enable users to log the location of activities using Google Places API for place selection, with automatic GPS capture for all logged activities.

## Requirements

### Functional Requirements

1. **Location Input Field**
   - Typeahead text field using Google Places Autocomplete (New) API
   - Shows for activities configured with `ActivityDetailType.location`
   - Placeholder text: "Search for a place..."
   - Results display: name + secondary text (e.g., "Central Park · New York, NY")
   - Maximum 5 results shown
   - Tap outside dismisses results
   - Selected state shows name + secondary text with X button to clear

2. **Current Location Feature**
   - Trailing icon (locateFixed) fetches current GPS and reverse geocodes to nearest place
   - Results biased toward user's current GPS location (no country restriction)
   - Auto-populates field after permission is granted via primer

3. **Silent GPS Capture**
   - Capture user's GPS coordinates when logging ANY activity (once permission granted)
   - Store in `user_activity.logged_location` (PostGIS POINT)
   - This is the user's location when they logged it, NOT where the activity happened
   - Captures current GPS even for retroactively logged activities (past dates)

4. **Permission Flow**
   - Primer dialog appears on location field interaction (not on screen load)
   - After granting: auto-fetch current location and populate field
   - If denied: search still works, but no GPS bias or auto-populate features
   - Suffix icon triggers permission request if not already granted
   - Settings toggle in Customization section to re-request permissions

5. **Health Synced Activities**
   - Extract location from health data if available (Apple Health workouts may include route data)
   - If not available, leave `logged_location` as null

6. **Offline Behavior**
   - Show error message on timeout
   - No caching of places

### Non-Functional Requirements

1. Google Places API calls should timeout after 10 seconds
2. Location accuracy: high (GPS)
3. GPS timeout: 10 seconds

## Architecture

### Data Model

```
┌─────────────────────────────────────────────────────────────────┐
│                         location                                 │
├─────────────────────────────────────────────────────────────────┤
│ location_id (PK)  │ TEXT        │ Google place_id               │
│ lng_lat           │ GEOGRAPHY   │ PostGIS POINT(lng, lat)       │
│ name              │ TEXT        │ Place name from Google        │
│ address           │ TEXT        │ Formatted address from Google │
│ created_at        │ TIMESTAMPTZ │ Record creation timestamp     │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                      user_activity                               │
├─────────────────────────────────────────────────────────────────┤
│ ... existing fields ...                                          │
│ logged_location   │ GEOGRAPHY   │ User's GPS when logging (NEW) │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                   user_activity_detail                           │
├─────────────────────────────────────────────────────────────────┤
│ ... existing fields ...                                          │
│ lat_lng           │ TEXT        │ DEPRECATED - do not use       │
│ location_id (FK)  │ TEXT        │ References location (NEW)     │
└─────────────────────────────────────────────────────────────────┘
```

### Location Table Design

- **Globally shared**: All users share the same location records
- **Deduplication**: Google place_id ensures no duplicate places
- **Upsert pattern**: Insert if new, return existing if already present

### Two Location Data Points

| Field | Table | Purpose | When Populated |
|-------|-------|---------|----------------|
| `logged_location` | user_activity | User's GPS at logging time | ALL activities (silent capture) |
| `location_id` | user_activity_detail | User-selected place | Activities with location detail type |

These can differ: user may be at home (logged_location) logging a run that happened at Central Park (location_id).

## Components

### Domain Models

```dart
// lib/features/activity_logging/domain/location.dart
@freezed
abstract class Location with _$Location {
  const factory Location({
    required String locationId,  // Google place_id
    required double lng,
    required double lat,
    required String name,
    required String address,
    DateTime? createdAt,
  }) = _Location;
}

// lib/features/activity_logging/domain/gps_coordinates.dart
@freezed
abstract class GpsCoordinates with _$GpsCoordinates {
  const factory GpsCoordinates({
    required double latitude,
    required double longitude,
  }) = _GpsCoordinates;
}
```

### Exceptions

```dart
// lib/features/activity_logging/domain/location_exception.dart
abstract class LocationException extends AppException { ... }
class GpsLocationException extends LocationException { ... }
class PlacesSearchException extends LocationException { ... }
class SaveLocationException extends LocationException { ... }
class LocationPermissionDeniedException extends LocationException { ... }
```

### Repository Layer

```dart
// lib/features/activity_logging/data/location_repository.dart
class LocationRepository {
  Future<Location?> getById(String locationId);
  Future<Location> upsert(Location location);
}

// lib/features/activity_logging/data/google_places_repository.dart
class GooglePlacesRepository {
  Future<List<PlacePrediction>> searchPlaces(String query, {GpsCoordinates? biasLocation});
  Future<Location> getPlaceDetails(String placeId);
  Future<Location?> reverseGeocode(GpsCoordinates coordinates);
}
```

### Service Layer

```dart
// lib/features/activity_logging/application/location_service.dart
class LocationService {
  // Permission management
  Future<LocationPermissionStatus> checkPermission();
  Future<LocationPermissionStatus> requestPermission();

  // GPS operations
  Future<GpsCoordinates> getCurrentLocation();
  Future<GpsCoordinates?> getCurrentLocationIfPermitted();

  // Places operations
  Future<List<PlacePrediction>> searchPlaces(String query);
  Future<Location> selectPlace(String placeId);
  Future<Location?> fetchCurrentPlace();
}
```

### UI Components

```dart
// lib/features/activity_logging/presentation/widgets/detail_inputs/location_input.dart
class LocationInput extends ConsumerStatefulWidget {
  const LocationInput({required this.activityDetail});
  final ActivityDetail activityDetail;
}

// lib/features/activity_logging/presentation/widgets/location_permission_primer.dart
class LocationPermissionPrimer extends StatelessWidget { ... }
```

### Providers

```dart
// lib/features/activity_logging/presentation/providers/location_permission_provider.dart
@riverpod
class LocationPermissionStateNotifier extends _$LocationPermissionStateNotifier {
  void markPrimerShown();
  Future<LocationPermissionStatus> requestPermission();
  Future<void> openSettings();
  Future<void> refresh();
}
```

## Data Operations

### Create Location (Upsert)

```dart
Future<Location> upsert(Location location) async {
  await _supabase.from('location').upsert(
    {
      'location_id': location.locationId,
      'lng_lat': 'POINT(${location.lng} ${location.lat})',
      'name': location.name,
      'address': location.address,
    },
    onConflict: 'location_id',
    ignoreDuplicates: true,
  );
  return _supabase.from('location').select().eq('location_id', location.locationId).single();
}
```

### Silent GPS Capture (in form submission)

```dart
// Before creating user activity
final coords = await locationService.getCurrentLocationIfPermitted();

final activity = CreateUserActivity(
  // ... existing fields ...
  loggedLocationLng: coords?.longitude,
  loggedLocationLat: coords?.latitude,
);
```

### Google Places API Calls

- **Autocomplete**: `POST https://places.googleapis.com/v1/places:autocomplete`
- **Place Details**: `GET https://places.googleapis.com/v1/places/{placeId}`
- **Nearby Search** (for reverse geocode): `POST https://places.googleapis.com/v1/places:searchNearby`

## Integration

### Settings Screen

Add location permission toggle in Customization section between "Home screen vibration" and notifications:

```dart
// settings_screen.dart, after line 445
_LocationPermissionListTile(),
```

### Log Activity Screen

Replace `_buildLocationInput()` placeholder (lines 446-481):

```dart
Widget _buildLocationInput(ActivityDetail detail) {
  return LocationInput(activityDetail: detail);
}
```

### Form Provider

Update `DetailValue` class to include `locationId`:

```dart
class DetailValue {
  // ... existing fields ...
  final String? locationId;
}
```

Add `setLocationValue` method to notifier:

```dart
void setLocationValue(String activityDetailId, String? locationId);
```

## Testing Requirements

### Unit Tests

1. **LocationService**
   - Permission checking returns correct status
   - GPS fetch throws on permission denied
   - Search biases results when location available
   - selectPlace saves to database

2. **LocationRepository**
   - Upsert creates new location
   - Upsert returns existing location on conflict
   - PostGIS point parsing works correctly

3. **GooglePlacesRepository**
   - Autocomplete parses response correctly
   - Place details parses response correctly
   - Timeout throws PlacesSearchException

### Widget Tests

1. **LocationInput**
   - Renders with placeholder text
   - Shows search results on input
   - Clears on X button tap
   - Triggers permission primer when appropriate
   - Suffix icon fetches current location

2. **LocationPermissionPrimer**
   - Renders benefits text
   - Enable button returns true
   - Not Now button returns false

### Integration Tests

1. Full location selection flow
2. Permission grant and auto-populate flow
3. Settings toggle behavior

## Future Considerations

1. **Saved Places** - Allow users to nickname frequently used locations
2. **Location History** - Show recent locations for quick selection
3. **Map View** - Display activities on a map
4. **Proximity Queries** - "Find activities near X"
5. **Location-based Insights** - "You usually exercise at the gym on Tuesdays"

## Success Criteria

- [ ] Location table created with PostGIS support
- [ ] user_activity.logged_location field added
- [ ] user_activity_detail.location_id FK added
- [ ] lat_lng field deprecated (data preserved)
- [ ] Location domain model created
- [ ] LocationRepository with upsert logic
- [ ] GooglePlacesRepository with autocomplete, details, reverse geocode
- [ ] LocationService with permission + GPS + places operations
- [ ] LocationInput widget with typeahead
- [ ] LocationPermissionPrimer dialog
- [ ] LocationPermissionProvider for state management
- [ ] Form provider updated with locationId support
- [ ] Silent GPS capture in form submission
- [ ] Settings toggle for location permission
- [ ] Platform permissions configured (iOS/Android)
- [ ] Unit tests for service and repositories
- [ ] Widget tests for LocationInput

## Items to Complete

- [ ] Create database migrations
- [ ] Create Location freezed model
- [ ] Create GpsCoordinates freezed model
- [ ] Create LocationException classes
- [ ] Create LocationRepository
- [ ] Create GooglePlacesRepository
- [ ] Create LocationService
- [ ] Create LocationInput widget
- [ ] Create LocationPermissionPrimer dialog
- [ ] Create LocationPermissionProvider
- [ ] Update DetailValue class with locationId
- [ ] Update CreateUserActivityDetail with locationId
- [ ] Update CreateUserActivity with logged location fields
- [ ] Update activity_form_provider with setLocationValue
- [ ] Add silent GPS capture to form submission
- [ ] Replace log_activity_screen placeholder
- [ ] Update edit_activity_screen
- [ ] Add settings toggle
- [ ] Add geolocator package
- [ ] Add GOOGLE_PLACES_API_KEY to env files
- [ ] Update EnvService with googlePlacesApiKey
- [ ] Configure iOS Info.plist
- [ ] Configure Android manifest
- [ ] Run code generation
- [ ] Write unit tests
- [ ] Write widget tests
- [ ] Manual testing on iOS/Android
