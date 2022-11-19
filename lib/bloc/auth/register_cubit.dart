import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../api/auth.dart';
import '../../common/loading_status.dart';
import '../../models/user.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterState());

  void emailChanged(String email) async {
    emit(state.copyWith(email: email));
  }

  void passwordChanged(String password) async {
    emit(state.copyWith(password: password));
  }

  void register() async {
    emit(state.copyWith(loadingStatus: LoadingInProgress()));
    try {
      await AuthAPI.emailRegisterUser(state.email, state.password);
      emit(state.copyWith(loadingStatus: LoadingSuccess()));
    } catch (e) {
      emit(state.copyWith(loadingStatus: LoadingFailed(e.toString())));
      emit(state.copyWith(loadingStatus: const InitialLoadingStatus()));

    }
  }
}
