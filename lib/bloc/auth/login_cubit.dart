import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:luciddreams/common/loading_status.dart';

import '../../api/auth.dart';
import '../../models/user.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState());

    void emailChanged(String email) async {
    emit(state.copyWith(email: email));
  }

  void passwordChanged(String password) async {
    emit(state.copyWith(password: password));
  }

  void loginWithEmail() async {
    emit(state.copyWith(loadingStatus: LoadingInProgress()));
    try {
      User user = await AuthAPI.loginUserWithEmail(state.email, state.password);
      await AuthAPI.saveUserToLocalStorage(user);
      emit(state.copyWith(loadingStatus: LoadingSuccess()));
    } catch (e) {
      emit(state.copyWith(loadingStatus: LoadingFailed(e.toString())));
      emit(state.copyWith(loadingStatus: const InitialLoadingStatus()));
    }
  }
}

