import 'package:json_annotation/json_annotation.dart';

part 'userinfield.g.dart';

enum Role {
  staffCreator,
  staffResponse,
  staffSurvey,
  farmerOwner,
  farmerSurvey
}

@JsonSerializable()
class UserInField {
  int userID;
  int fieldID;
  Role role;

  UserInField(
    this.userID,
    this.fieldID,
    this.role,
  );
  factory UserInField.fromJson(Map<String, dynamic> json) =>
      _$UserInFieldFromJson(json);

  Map<String, dynamic> toJson() => _$UserInFieldToJson(this);
}
