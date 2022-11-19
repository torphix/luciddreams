part of 'auth_cubit.dart';

class AuthState {
  bool loggedIn;
  bool isConfirmed;
  LoadingStatus loadingStatus;

  AuthState({
    this.loggedIn = false,
    this.isConfirmed = false,
    this.loadingStatus = const InitialLoadingStatus(),
  });

  AuthState copyWith({
    bool? loggedIn,
    bool? isConfirmed,
    LoadingStatus? loadingStatus,
  }) {
    return AuthState(
      loggedIn: loggedIn ?? this.loggedIn,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      loadingStatus: loadingStatus ?? this.loadingStatus,
    );
  }
}
