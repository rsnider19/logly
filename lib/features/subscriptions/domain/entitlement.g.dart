// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entitlement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Entitlement _$EntitlementFromJson(Map<String, dynamic> json) => _Entitlement(
  identifier: json['identifier'] as String,
  isActive: json['is_active'] as bool,
  expirationDate: json['expiration_date'] == null ? null : DateTime.parse(json['expiration_date'] as String),
  purchaseDate: json['purchase_date'] == null ? null : DateTime.parse(json['purchase_date'] as String),
  productIdentifier: json['product_identifier'] as String?,
);

Map<String, dynamic> _$EntitlementToJson(_Entitlement instance) => <String, dynamic>{
  'identifier': instance.identifier,
  'is_active': instance.isActive,
  'expiration_date': instance.expirationDate?.toIso8601String(),
  'purchase_date': instance.purchaseDate?.toIso8601String(),
  'product_identifier': instance.productIdentifier,
};
