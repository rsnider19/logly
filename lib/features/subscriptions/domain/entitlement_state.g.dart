// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entitlement_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EntitlementState _$EntitlementStateFromJson(Map<String, dynamic> json) =>
    _EntitlementState(
      isLoading: json['is_loading'] as bool? ?? true,
      activeEntitlements:
          (json['active_entitlements'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toSet() ??
          const {},
      error: json['error'] as String?,
    );

Map<String, dynamic> _$EntitlementStateToJson(_EntitlementState instance) =>
    <String, dynamic>{
      'is_loading': instance.isLoading,
      'active_entitlements': instance.activeEntitlements.toList(),
      'error': instance.error,
    };
