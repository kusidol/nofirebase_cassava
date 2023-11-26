// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userinfield.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInField _$UserInFieldFromJson(Map<String, dynamic> json) => UserInField(
      json['userID'] as int,
      json['fieldID'] == null ? 0 : json['fieldID'] as int,
      $enumDecode(_$RoleEnumMap, json['role']),
    );

Map<String, dynamic> _$UserInFieldToJson(UserInField instance) =>
    <String, dynamic>{
      'userID': instance.userID,
      'fieldID': instance.fieldID,
      'role': _$RoleEnumMap[instance.role]!,
    };

const _$RoleEnumMap = {
  Role.staffCreator: 'staffCreator',
  Role.staffResponse: 'staffResponse',
  Role.staffSurvey: 'staffSurvey',
  Role.farmerOwner: 'farmerOwner',
  Role.farmerSurvey: 'farmerSurvey',
};
