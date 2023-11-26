// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['userId'] == null ? 0 : json['userId'] as int,
      json['username'] == null ? "" : json['username'] as String,
      json['title'] == null ? "" : json['title'] as String,
      json['firstName'] == null ? "" : json['firstName'] as String,
      json['lastName'] == null ? "" : json['lastName'] as String,
      json['phoneNo'] == null ? "" : json['phoneNo'] as String,
      $enumDecode(_$UserStatusEnumMap, json['userStatus']),
      json['latestLogin'] == null ? 0 : json['latestLogin'] as int,
      $enumDecode(_$RequestInfoStatusEnumMap, json['requestInfoStatus']),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userId': instance.userID,
      'username': instance.username,
      'title': instance.title,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phoneNo': instance.phoneNo,
      'userStatus': _$UserStatusEnumMap[instance.userStatus]!,
      'latestLogin': instance.latestLogin,
      'requestInfoStatus':
          _$RequestInfoStatusEnumMap[instance.requestInfoStatus]!,
    };

const _$UserStatusEnumMap = {
  UserStatus.invalid: 'invalid',
  UserStatus.waiting: 'waiting',
  UserStatus.active: 'active',
  UserStatus.inactive: 'inactive',
};

const _$RequestInfoStatusEnumMap = {
  RequestInfoStatus.No: 'No',
  RequestInfoStatus.Waiting: 'Waiting',
  RequestInfoStatus.Yes: 'Yes',
};
