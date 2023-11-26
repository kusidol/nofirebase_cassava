import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

enum UserStatus { invalid, waiting, active, inactive }

enum RequestInfoStatus { No, Waiting, Yes }

@JsonSerializable()
class User {
  int userID;
  String username;
  String title;
  String firstName;
  String lastName;
  String phoneNo;
  UserStatus userStatus;
  int latestLogin;
  RequestInfoStatus requestInfoStatus;

  User(
    this.userID,
    this.username,
    this.title,
    this.firstName,
    this.lastName,
    this.phoneNo,
    this.userStatus,
    this.latestLogin,
    this.requestInfoStatus,
  );
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
