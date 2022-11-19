part of 'img2img_cubit.dart';

class Img2imgState {
  final LoadingStatus? loadingStatus;
  final LoadingStatus? inferenceLoading;
  final File? selectedImage;
  final List<Color>? colorsUsed;
  final List<RawImageModel> outputImages;

  Img2imgState({
    this.selectedImage,
    this.loadingStatus,
    this.inferenceLoading,
    this.colorsUsed,
    this.outputImages = const [],
  });

  Img2imgState copyWith({
    LoadingStatus? loadingStatus,
    LoadingStatus? inferenceLoading,
    File? selectedImage,
    List<Color>? colorsUsed,
    List<RawImageModel>? outputImages,
  }) {
    return Img2imgState(
      inferenceLoading: inferenceLoading ?? this.inferenceLoading,
      outputImages: outputImages ?? this.outputImages,
      colorsUsed: colorsUsed ?? this.colorsUsed,
      loadingStatus: loadingStatus ?? this.loadingStatus,
      selectedImage: selectedImage ?? this.selectedImage,
    );
  }
}
