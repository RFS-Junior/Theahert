// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// OrmGenerator
// **************************************************************************

// **************************************************
//     DORM: UserTheahert
// **************************************************

@JsonSerializable(anyMap: true, explicitToJson: true)
class UserTheahertData {
  @JsonKey(name: 'firstName', required: true, disallowNullValue: true)
  final String firstName;

  @JsonKey(name: 'lastName', required: true, disallowNullValue: true)
  final String lastName;

  @JsonKey(name: 'email', required: true, disallowNullValue: true)
  final String email;

  @JsonKey(name: 'phoneNumber')
  final String? phoneNumber;

  @JsonKey(name: 'userType', required: true, disallowNullValue: true)
  final String userType;

  factory UserTheahertData.fromJson(Map json) =>
      _$UserTheahertDataFromJson(json);

  const UserTheahertData({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.userType,
  });

  Map<String, Object?> toJson() => _$UserTheahertDataToJson(this);
}

@JsonSerializable(anyMap: true, explicitToJson: true)
class UserTheahert extends UserTheahertData implements _UserTheahert {
  @JsonKey(name: '_id', required: true, disallowNullValue: true)
  final String id;

  factory UserTheahert.fromJson(String id, Map json) =>
      _$UserTheahertFromJson({...json, '_id': id});

  const UserTheahert({
    required this.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.phoneNumber,
    required super.userType,
  });

  @override
  Map<String, Object?> toJson() {
    return {
      ..._$UserTheahertToJson(this)..remove('_id'),
    };
  }
}

class UserTheahertDependency extends Dependency<UserTheahertData> {
  const UserTheahertDependency() : super.strong();
}

class UserTheahertEntity implements Entity<UserTheahertData, UserTheahert> {
  const UserTheahertEntity._();

  @override
  String get tableName => 'user';

  @override
  UserTheahert fromData(
    UserTheahertDependency dependency,
    String id,
    UserTheahertData data,
  ) {
    return UserTheahert(
      id: id,
      firstName: data.firstName,
      lastName: data.lastName,
      email: data.email,
      phoneNumber: data.phoneNumber,
      userType: data.userType,
    );
  }

  @override
  UserTheahert fromJson(String id, Map json) => UserTheahert.fromJson(id, json);

  @override
  String identify(UserTheahert model) => model.id;

  @override
  Map toJson(UserTheahertData data) => data.toJson();
}

// **************************************************
//     DORM
// **************************************************

class Dorm {
  final Reference _root;

  const Dorm(this._root);

  Repository<UserTheahertData, UserTheahert> get users =>
      Repository(root: _root, entity: const UserTheahertEntity._());
}
