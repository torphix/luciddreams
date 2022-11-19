part of 'txt2img_cubit.dart';

class Txt2imgState {
  final String prompt;
  final bool nsfw;
  final LoadingStatus loadingStatus;
  final List<String> promptKeywords;
  final int numImages;
  final int height;
  final int width;
  final int numSteps; // num of diffusion steps
  final int cfg; // How closely to follow prompt
  final double numTokens;
  final Map<String, dynamic>? tokenSpendOpts;
  final bool? searchdb;
  final List<ImageModel> outImages;

  Txt2imgState({
    this.outImages = const [],
    this.searchdb = false,
    this.numImages = 1,
    this.height = 512,
    this.width = 512,
    this.numSteps = 51,
    this.cfg = 7,
    this.prompt = '',
    this.nsfw = false,
    this.numTokens = 1,
    this.promptKeywords = const [],
    this.loadingStatus = const InitialLoadingStatus(),
    this.tokenSpendOpts,
  });

  Txt2imgState copyWith({
    List<ImageModel>? outImages,
    List<String>? promptKeywords,
    String? prompt,
    bool? nsfw,
    LoadingStatus? loadingStatus,
    int? numImages,
    int? height,
    int? width,
    int? numSteps,
    int? cfg,
    double? numTokens,
    bool? searchdb,
    Map<String, dynamic>? tokenSpendOpts,
  }) {
    return Txt2imgState(
      outImages: outImages ?? this.outImages,
      searchdb: searchdb ?? this.searchdb,
      nsfw: nsfw ?? this.nsfw,
      prompt: prompt ?? this.prompt,
      loadingStatus: loadingStatus ?? this.loadingStatus,
      promptKeywords: promptKeywords ?? this.promptKeywords,
      // Advanced options
      numImages: numImages ?? this.numImages,
      height: height ?? this.height,
      width: width ?? this.width,
      numSteps: numSteps ?? this.numSteps,
      cfg: cfg ?? this.cfg,
      tokenSpendOpts: tokenSpendOpts ?? this.tokenSpendOpts,
      numTokens: numTokens ?? this.numTokens,
    );
  }

  double updateTokenAmount(String optName, String optValue) {
    double baseTokens = numTokens;
    baseTokens += tokenSpendOpts![optName]![optValue]!;
    return baseTokens;
  }
}
