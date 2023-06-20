// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grade.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Grade _$GradeFromJson(Map<String, dynamic> json) {
  return _Grade.fromJson(json);
}

/// @nodoc
mixin _$Grade {
  String get name => throw _privateConstructorUsedError;
  Map<String, String> get grades => throw _privateConstructorUsedError;
  String get total => throw _privateConstructorUsedError;
  set total(String value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GradeCopyWith<Grade> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GradeCopyWith<$Res> {
  factory $GradeCopyWith(Grade value, $Res Function(Grade) then) =
      _$GradeCopyWithImpl<$Res, Grade>;
  @useResult
  $Res call({String name, Map<String, String> grades, String total});
}

/// @nodoc
class _$GradeCopyWithImpl<$Res, $Val extends Grade>
    implements $GradeCopyWith<$Res> {
  _$GradeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? grades = null,
    Object? total = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      grades: null == grades
          ? _value.grades
          : grades // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_GradeCopyWith<$Res> implements $GradeCopyWith<$Res> {
  factory _$$_GradeCopyWith(_$_Grade value, $Res Function(_$_Grade) then) =
      __$$_GradeCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, Map<String, String> grades, String total});
}

/// @nodoc
class __$$_GradeCopyWithImpl<$Res> extends _$GradeCopyWithImpl<$Res, _$_Grade>
    implements _$$_GradeCopyWith<$Res> {
  __$$_GradeCopyWithImpl(_$_Grade _value, $Res Function(_$_Grade) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? grades = null,
    Object? total = null,
  }) {
    return _then(_$_Grade(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      grades: null == grades
          ? _value.grades
          : grades // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Grade implements _Grade {
  _$_Grade({required this.name, required this.grades, this.total = '0'});

  factory _$_Grade.fromJson(Map<String, dynamic> json) =>
      _$$_GradeFromJson(json);

  @override
  final String name;
  @override
  final Map<String, String> grades;
  @override
  @JsonKey()
  String total;

  @override
  String toString() {
    return 'Grade(name: $name, grades: $grades, total: $total)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GradeCopyWith<_$_Grade> get copyWith =>
      __$$_GradeCopyWithImpl<_$_Grade>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_GradeToJson(
      this,
    );
  }
}

abstract class _Grade implements Grade {
  factory _Grade(
      {required final String name,
      required final Map<String, String> grades,
      String total}) = _$_Grade;

  factory _Grade.fromJson(Map<String, dynamic> json) = _$_Grade.fromJson;

  @override
  String get name;
  @override
  Map<String, String> get grades;
  @override
  String get total;
  set total(String value);
  @override
  @JsonKey(ignore: true)
  _$$_GradeCopyWith<_$_Grade> get copyWith =>
      throw _privateConstructorUsedError;
}
