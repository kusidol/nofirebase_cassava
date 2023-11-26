part of 'token.dart';

Token _$TokenFromJson(Map<String, dynamic> json) => Token(
      json['token'] as String,
      // User.fromJson(json['user']) as User ,
    );

Map<String, dynamic> _$TokenToJson(Token instance) => <String, dynamic>{
      'token': instance.token,
      // 'user': instance.user,
    };
