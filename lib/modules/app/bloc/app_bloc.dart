import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../repositories/auth_repository/models/auth_models.dart';

part 'app_bloc.g.dart';
part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends HydratedBloc<AppEvent, AppState> {
  AppBloc() : super(AppInitial()) {
    on<InitialAppData>(_onInitialAppData);
    on<FinishSplash>(_onFinishSplash);
    on<SetUserData>(_onSetUserData);
    on<SetUserLogout>(_onSetUserLogout);
  }

  @override
  AppState? fromJson(Map<String, dynamic> json) {
    return _$AppStateFromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(AppState state) {
    return _$AppStateToJson(state);
  }

  FutureOr<void> _onInitialAppData(
    InitialAppData event,
    Emitter<AppState> emit,
  ) {}
  FutureOr<void> _onFinishSplash(FinishSplash event, Emitter<AppState> emit) {
    emit(state.copyWith(alreadySplash: true));
  }

  FutureOr<void> _onSetUserData(SetUserData event, Emitter<AppState> emit) {
    emit(
      state.copyWith(
        token: event.token,
        refreshToken: event.refreshToken,
        user: event.user,
      ),
    );
  }

  Future<void> _onSetUserLogout(
    SetUserLogout event,
    Emitter<AppState> emit,
  ) async {
    try {
      // getIt<SocketServices>().allClose();
      emit(state.logout());
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
