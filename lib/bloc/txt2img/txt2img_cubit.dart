import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:luciddreams/api/txt2img.dart';
import 'package:luciddreams/models/images.dart';
import 'package:meta/meta.dart';

import '../../common/loading_status.dart';

part 'txt2img_state.dart';

class Txt2imgCubit extends Cubit<Txt2imgState> {
  Txt2imgCubit() : super(Txt2imgState());

  void toggleNsfw() {
    emit(state.copyWith(nsfw: state.nsfw ? false : true));
  }

  void getKeywords() async {
    var allKeywords = await rootBundle
        .loadString('assets/prompt_keywords.txt')
        .then((words) => words.split("\n"));
    List<String> keywords = [];
    for (String word in allKeywords) {
      if (state.prompt.contains(word) == false) {
        keywords.add((word));
      }
      emit(state.copyWith(promptKeywords: keywords));
    }
  }

  void getTokenSpendOpts() async {
    try {
      final spendOpts = await Txt2imgAPI.getOptionTokenCosts();
      emit(state.copyWith(tokenSpendOpts: spendOpts));
    } catch (e) {
      emit(state.copyWith(loadingStatus: LoadingFailed(e.toString())));
    }
  }

  void changeNumImagesGenerated(int nImages) async {
    double tokenAmount = 1;
    if (nImages != 1) {
      tokenAmount = state.updateTokenAmount('numImages', nImages.toString());
    }
    emit(state.copyWith(numImages: nImages, numTokens: tokenAmount));
  }

  void searchdbToggle(bool? value) async {
    emit(state.copyWith(searchdb: value));
  }

  void generateImages() async {
    emit(state.copyWith(loadingStatus: LoadingInProgress()));
    final images = await Txt2imgAPI.generateImages(
      state.prompt,
      state.numImages,
      state.height,
      state.width,
      state.numSteps,
      state.cfg,
      state.searchdb!,
      state.nsfw,
    );
    emit(state.copyWith(outImages: images));
  }
}
