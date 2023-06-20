import 'package:freezed_annotation/freezed_annotation.dart';

part 'grade.freezed.dart';

part 'grade.g.dart';

class GradesPayload {
  final String name;
  final Map<String, String> request;

  GradesPayload({
    required this.name,
    required this.request,
  });

  factory GradesPayload.fromJson(Map<String, dynamic> json) {
    return GradesPayload(
      name: json['name'],
      request: json['request'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'request': request,
    };
  }

  String toString() {
    return 'GradesPayload(name: $name, request: $request)';
  }
}

@unfreezed
class Grade with _$Grade {
  factory Grade({
    required final String name,
    required final Map<String, String> grades,
    @Default('0') String total,
  }) = _Grade;

  factory Grade.fromJson(Map<String, Object?> json) => _$GradeFromJson(json);
}
