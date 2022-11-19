
part of 'login_cubit.dart';



class LoginState {
  final String email;
  final String password;
  final LoadingStatus? loadingStatus;

  bool get isValidEmail => email.contains('@');
  bool get isValidPassword => password.length > 6;

  LoginState({
    this.email = '',
    this.password = '',
    this.loadingStatus,
  });

  LoginState copyWith({
    String? email,
    String? password,
    LoadingStatus? loadingStatus,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      loadingStatus: loadingStatus ?? this.loadingStatus,
    );
  }
}
