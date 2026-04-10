part of 'app_bloc.dart';

sealed class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

final class InitialAppData extends AppEvent {}

final class SetUserLogout extends AppEvent {}

final class FinishSplash extends AppEvent {}
