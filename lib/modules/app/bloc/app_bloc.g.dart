// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppState _$AppStateFromJson(Map<String, dynamic> json) => AppState(
  token: json['token'] as String? ?? '',
  refreshToken: json['refreshToken'] as String? ?? '',
  user: json['user'] == null
      ? null
      : UserModel.fromJson(json['user'] as Map<String, dynamic>),
  loadingNotif: json['loadingNotif'] as bool? ?? false,
  alreadySplash: json['alreadySplash'] as bool? ?? false,
);

Map<String, dynamic> _$AppStateToJson(AppState instance) => <String, dynamic>{
  'token': instance.token,
  'user': instance.user,
  'refreshToken': instance.refreshToken,
  'loadingNotif': instance.loadingNotif,
  'alreadySplash': instance.alreadySplash,
};
