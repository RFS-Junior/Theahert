// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserTheahertData _$UserTheahertDataFromJson(Map json) {
  $checkKeys(
    json,
    requiredKeys: const ['firstName', 'lastName', 'email', 'userType'],
    disallowNullValues: const ['firstName', 'lastName', 'email', 'userType'],
  );
  return UserTheahertData(
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    email: json['email'] as String,
    phoneNumber: json['phoneNumber'] as String?,
    userType: json['userType'] as String,
  );
}

Map<String, dynamic> _$UserTheahertDataToJson(UserTheahertData instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'userType': instance.userType,
    };

UserTheahert _$UserTheahertFromJson(Map json) {
  $checkKeys(
    json,
    requiredKeys: const ['firstName', 'lastName', 'email', 'userType', '_id'],
    disallowNullValues: const [
      'firstName',
      'lastName',
      'email',
      'userType',
      '_id'
    ],
  );
  return UserTheahert(
    id: json['_id'] as String,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    email: json['email'] as String,
    phoneNumber: json['phoneNumber'] as String?,
    userType: json['userType'] as String,
  );
}

Map<String, dynamic> _$UserTheahertToJson(UserTheahert instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'userType': instance.userType,
      '_id': instance.id,
    };
