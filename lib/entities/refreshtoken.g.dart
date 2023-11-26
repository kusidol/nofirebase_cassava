part of 'refreshtoken.dart';

RefreshToken _$TokenFromJson(Map<String, dynamic> json) => RefreshToken(
      json['refreshToken'] as String,
      // User.fromJson(json['user']) as User ,
    );

Map<String, dynamic> _$TokenToJson(RefreshToken instance) => <String, dynamic>{
      'refreshToken': instance.refreshtoken,
      // 'user': instance.user,
    };
