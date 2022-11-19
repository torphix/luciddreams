import 'package:bloc/bloc.dart';
import 'package:luciddreams/api/auth.dart';
import 'package:luciddreams/common/loading_status.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState());

  void autoLogin() async {
    if (state.loggedIn == false) {
      emit(state.copyWith(loadingStatus: LoadingInProgress()));
      try {
        final user = await AuthAPI.loadUserFromLocalStorage();
        if ((user.email != null || user.email != '') && (user.token != null || user.token != '')){
          emit(state.copyWith(loggedIn: true, loadingStatus: LoadingSuccess()));
        }
      } catch (e) {
        emit(state.copyWith(loadingStatus: LoadingFailed(e.toString())));
      }
    }
  }

  void setLoginState(bool loggedIn) async{
    emit(state.copyWith(loggedIn: loggedIn));
  }
}
