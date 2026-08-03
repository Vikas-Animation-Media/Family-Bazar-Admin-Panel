import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_model.freezed.dart';
part 'token_model.g.dart';

@freezed
abstract class GetTokenModel with _$GetTokenModel {
  const factory GetTokenModel({
    @Default(false) bool status,
    @Default('') String message,
    @Default('') String token,
}) = _GetTokenModel;

  factory GetTokenModel.fromJson(Map<String, dynamic> json) => _$GetTokenModelFromJson(json);
}