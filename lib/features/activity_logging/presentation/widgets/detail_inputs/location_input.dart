import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/activity_catalog/domain/activity_detail.dart';
import 'package:logly/features/activity_logging/application/location_service.dart';
import 'package:logly/features/activity_logging/data/google_places_repository.dart';
import 'package:logly/features/activity_logging/domain/location.dart';
import 'package:logly/features/activity_logging/presentation/providers/activity_form_provider.dart';
import 'package:logly/features/activity_logging/presentation/providers/location_permission_provider.dart';
import 'package:logly/features/activity_logging/presentation/widgets/location_permission_primer.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Input widget for selecting a location via Google Places Autocomplete.
///
/// Features:
/// - Typeahead search with Google Places API
/// - Current location button that triggers permission primer if needed
/// - Results biased toward user's current GPS location
/// - Selected location display with clear button
class LocationInput extends ConsumerStatefulWidget {
  const LocationInput({
    required this.activityDetail,
    super.key,
  });

  final ActivityDetail activityDetail;

  @override
  ConsumerState<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends ConsumerState<LocationInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();

  OverlayEntry? _overlayEntry;
  List<PlacePrediction> _predictions = [];
  bool _isLoading = false;
  bool _isFetchingCurrent = false;
  Location? _selectedLocation;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    _initializeFromState();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _initializeFromState() {
    final formState = ref.read(activityFormStateProvider);
    final detailValue = formState.detailValues[widget.activityDetail.activityDetailId];

    if (detailValue?.locationId != null) {
      _loadExistingLocation(detailValue!.locationId!);
    }
  }

  Future<void> _loadExistingLocation(String locationId) async {
    final service = ref.read(locationServiceProvider);
    final location = await service.getLocationById(locationId);
    if (location != null && mounted) {
      setState(() {
        _selectedLocation = location;
        _controller.text = location.shortDisplayText;
      });
    }
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _checkAndRequestPermission();
    } else {
      // Delay overlay removal to allow tap handling
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted && !_focusNode.hasFocus) {
          _removeOverlay();
        }
      });
    }
  }

  Future<void> _checkAndRequestPermission() async {
    final permissionState = await ref.read(locationPermissionStateProvider.future);

    if (permissionState.status != LocationPermissionStatus.granted && !permissionState.hasShownPrimer) {
      await _showPrimerAndRequestPermission();
    }
  }

  Future<void> _showPrimerAndRequestPermission() async {
    if (!mounted) return;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const LocationPermissionPrimer(),
    );

    if (result == true && mounted) {
      final status = await ref.read(locationPermissionStateProvider.notifier).requestPermission();

      if (status == LocationPermissionStatus.granted) {
        await _fetchCurrentLocation();
      }
    } else {
      ref.read(locationPermissionStateProvider.notifier).markPrimerShown();
    }
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();

    if (query.length < 2) {
      _removeOverlay();
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      final service = ref.read(locationServiceProvider);
      final predictions = await service.searchPlaces(query);

      if (mounted) {
        setState(() {
          _predictions = predictions;
          _isLoading = false;
        });
        _showOverlay();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Search failed. Please check your connection.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showOverlay() {
    _removeOverlay();
    if (_predictions.isEmpty) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => _buildOverlay(),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
  }

  Widget _buildOverlay() {
    final renderBox = context.findRenderObject() as RenderBox?;
    final size = renderBox?.size ?? Size.zero;

    return Positioned(
      width: size.width,
      child: CompositedTransformFollower(
        link: _layerLink,
        showWhenUnlinked: false,
        offset: Offset(0, size.height + 4),
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(8),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 250),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _predictions.length,
              itemBuilder: (context, index) {
                final prediction = _predictions[index];
                return ListTile(
                  leading: const Icon(LucideIcons.mapPin),
                  title: Text(
                    prediction.mainText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: prediction.secondaryText.isNotEmpty
                      ? Text(
                          prediction.secondaryText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      : null,
                  onTap: () => _onPredictionSelected(prediction),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onPredictionSelected(PlacePrediction prediction) async {
    _removeOverlay();
    _focusNode.unfocus();

    setState(() => _isLoading = true);

    try {
      final service = ref.read(locationServiceProvider);
      final location = await service.selectPlace(prediction.placeId);

      if (mounted) {
        setState(() {
          _selectedLocation = location;
          _controller.text = location.shortDisplayText;
          _isLoading = false;
        });

        ref.read(activityFormStateProvider.notifier).setLocationValue(
              widget.activityDetail.activityDetailId,
              location.locationId,
            );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to select place. Please try again.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _fetchCurrentLocation() async {
    final permissionState = await ref.read(locationPermissionStateProvider.future);

    if (permissionState.status != LocationPermissionStatus.granted) {
      if (!permissionState.hasShownPrimer) {
        await _showPrimerAndRequestPermission();
        return;
      } else {
        // Permission denied, can't fetch location
        return;
      }
    }

    setState(() => _isFetchingCurrent = true);

    try {
      final service = ref.read(locationServiceProvider);
      final location = await service.fetchCurrentPlace();

      if (location != null && mounted) {
        setState(() {
          _selectedLocation = location;
          _controller.text = location.shortDisplayText;
          _isFetchingCurrent = false;
        });

        ref.read(activityFormStateProvider.notifier).setLocationValue(
              widget.activityDetail.activityDetailId,
              location.locationId,
            );
      } else if (mounted) {
        setState(() => _isFetchingCurrent = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not find a place near your location.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isFetchingCurrent = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to get location. Please try again.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _clearSelection() {
    setState(() {
      _selectedLocation = null;
      _controller.clear();
      _predictions = [];
    });
    _removeOverlay();

    ref.read(activityFormStateProvider.notifier).setLocationValue(
          widget.activityDetail.activityDetailId,
          null,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.activityDetail.label,
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        CompositedTransformTarget(
          link: _layerLink,
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            readOnly: _selectedLocation != null,
            decoration: InputDecoration(
              hintText: 'Search for a place...',
              prefixIcon: const Icon(LucideIcons.mapPin),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isLoading || _isFetchingCurrent)
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  else if (_selectedLocation != null)
                    IconButton(
                      icon: const Icon(LucideIcons.x),
                      onPressed: _clearSelection,
                      tooltip: 'Clear location',
                    )
                  else
                    IconButton(
                      icon: const Icon(LucideIcons.locateFixed),
                      onPressed: _fetchCurrentLocation,
                      tooltip: 'Use current location',
                    ),
                ],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: _selectedLocation == null ? _onSearchChanged : null,
            onTap: _selectedLocation != null
                ? () {
                    _clearSelection();
                    _focusNode.requestFocus();
                  }
                : null,
          ),
        ),
      ],
    );
  }
}
