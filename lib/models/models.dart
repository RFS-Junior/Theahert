import 'package:dorm_annotations/dorm_annotations.dart';
import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';
part 'models.dorm.dart';

@Model(name: 'user', repositoryName: 'users')
abstract class _UserTheahert {
  @Field(name: 'firstName')
  String get firstName;

  @Field(name: 'lastName')
  String get lastName;

  @Field(name: 'email')
  String get email;

  @Field(name: 'phoneNumber')
  String? get phoneNumber;

  @Field(name: 'userType')
  String get userType;
}
