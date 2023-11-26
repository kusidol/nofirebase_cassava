import 'package:json_annotation/json_annotation.dart';

part 'objectlist.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ObjectList<T> {
  final List<T> list;

  ObjectList(this.list);

  factory ObjectList.fromJson(Map<String, dynamic> json, fromJsonT) {
    return _$ObjectListFromJson(json, fromJsonT);
  }

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$ObjectListToJson(this, toJsonT);
}
