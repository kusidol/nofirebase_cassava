import 'package:json_annotation/json_annotation.dart';

part 'response.g.dart';

@JsonSerializable(genericArgumentFactories: true, nullable: true)
class Response<T> {
  final int status;

  final T body;

  final String message;

  Response(this.status, this.body, this.message);

  factory Response.fromJson(Map<String, dynamic> json, fromJsonT) {
    return _$ResponseFromJson(json, fromJsonT);
  }

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$ResponseToJson(this, toJsonT);
}
