part of 'register_cubit.dart';

class RegisterState {
  final String email;
  final String password;
  final LoadingStatus? loadingStatus;

  bool get isValidEmail => email.contains('@');
  bool get isValidPassword => password.length > 6;

  RegisterState({
    this.email = '',
    this.password = '',
    this.loadingStatus,
  });

  RegisterState copyWith({
    String? email,
    String? password,
    LoadingStatus? loadingStatus,
  }) {
    return RegisterState(
      email: email ?? this.email,
      password: password ?? this.password,
      loadingStatus: loadingStatus ?? this.loadingStatus,
    );
  }
}
