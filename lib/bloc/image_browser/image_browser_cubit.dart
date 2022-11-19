import 'package:bloc/bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:luciddreams/api/image_browser.dart';
import 'package:luciddreams/common/loading_status.dart';
import 'package:luciddreams/models/images.dart';

part 'image_browser_state.dart';

class ImageBrowserCubit extends Cubit<ImageBrowserState> {
  ImageBrowserCubit() : super(ImageBrowserState());

  void getInitialImages({String? text}) async {
    emit(state.copyWith(prompt: text, loadingStatus: LoadingInProgress()));
    try {
      text ??= await ImageBrowserAPI.selectRandomPrompt();
      final images = await ImageBrowserAPI.lexicaTextSearch(query: text);
      emit(state.copyWith(prompt: text, lexicaImages: images));
      emit(state.copyWith(loadingStatus: LoadingSuccess()));
    } catch (e) {
      emit(state.copyWith(loadingStatus: LoadingFailed(e.toString())));
    }
  }
}
