import 'package:freezed_annotation/freezed_annotation.dart';

part 'role_type_model.freezed.dart';
part 'role_type_model.g.dart';

@freezed
abstract class GetRoleModel with _$GetRoleModel {
  const factory GetRoleModel({
    @Default(false) bool status,
    @Default('') String message,
    @Default([]) List<RoleDatum> data,
  }) = _GetRoleModel;

  factory GetRoleModel.fromJson(Map<String, dynamic> json) => _$GetRoleModelFromJson(json);
}

@freezed
abstract class RoleDatum with _$RoleDatum {
  const factory RoleDatum({
    @Default(0) int id,
    @JsonKey(name: 'role_name') @Default('') String roleName,
    @JsonKey(name: 'created_at') @Default('') String createdAt,
    @JsonKey(name: 'updated_at') @Default('') String updatedAt,
}) = _RoleDatum;

  factory RoleDatum.fromJson(Map<String, dynamic> json) => _$RoleDatumFromJson(json);
}