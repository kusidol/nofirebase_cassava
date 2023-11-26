import 'package:json_annotation/json_annotation.dart';
import 'user.dart';

part 'refreshtoken.g.dart';

@JsonSerializable()
class RefreshToken {
  final String refreshtoken;

  // User user;

  RefreshToken(this.refreshtoken);

  factory RefreshToken.fromJson(Map<String, dynamic> json) =>
      _$TokenFromJson(json);

  Map<String, dynamic> toJson() => _$TokenToJson(this);
}
