import 'package:freezed_annotation/freezed_annotation.dart';

part 'entitlement.freezed.dart';
part 'entitlement.g.dart';

/// Represents a user's entitlement to premium features.
@freezed
abstract class Entitlement with _$Entitlement {
  const factory Entitlement({
    required String identifier,
    required bool isActive,
    DateTime? expirationDate,
    DateTime? purchaseDate,
    String? productIdentifier,
  }) = _Entitlement;

  factory Entitlement.fromJson(Map<String, dynamic> json) => _$EntitlementFromJson(json);
}
