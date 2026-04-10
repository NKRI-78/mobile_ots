part of 'app_bloc.dart';

@JsonSerializable()
final class AppState extends Equatable {
  final String token;
  final UserModel? user;
  final String refreshToken;
  final bool loadingNotif;

  final bool alreadySplash;

  const AppState({
    this.token = '',
    this.refreshToken = '',
    this.user,
    this.loadingNotif = false,

    this.alreadySplash = false,
  });

  bool get userEmpty => token.isEmpty;
  bool get isLoggedIn => user != null && token.isNotEmpty;

  @override
  List<Object?> get props => [
    token,
    refreshToken,
    user,
    loadingNotif,

    alreadySplash,
  ];

  AppState logout() {
    return AppState(
      token: '',
      refreshToken: '',
      user: null,
      alreadySplash: alreadySplash,
    );
  }

  AppState copyWith({
    String? token,
    String? refreshToken,

    bool? loadingNotif,
    bool? alreadySplash,
    bool? isRelease,
  }) {
    return AppState(
      alreadySplash: alreadySplash ?? this.alreadySplash,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      user: user ?? this.user,
      loadingNotif: loadingNotif ?? this.loadingNotif,
    );
  }

  factory AppState.fromJson(Map<String, dynamic> json) =>
      _$AppStateFromJson(json);

  Map<String, dynamic> toJson() => _$AppStateToJson(this);
}

final class AppInitial extends AppState {}
