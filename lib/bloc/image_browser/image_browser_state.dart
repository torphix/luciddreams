part of 'image_browser_cubit.dart';

class ImageBrowserState {
  final List<ImageModel> lexicaImages;
  final String prompt;
  final LoadingStatus loadingStatus;

  ImageBrowserState({
    this.prompt = '',
    this.lexicaImages = const [],
    this.loadingStatus = const InitialLoadingStatus(),
  });

  ImageBrowserState copyWith({
    String? prompt,
    List<ImageModel>? lexicaImages,
    List<ImageModel>? cachedLexicaImages,
    LoadingStatus? loadingStatus,
  }) {
    return ImageBrowserState(
      prompt: prompt ?? this.prompt,
      lexicaImages: lexicaImages ?? this.lexicaImages,
      loadingStatus: loadingStatus ?? this.loadingStatus,
    );
  }
}
