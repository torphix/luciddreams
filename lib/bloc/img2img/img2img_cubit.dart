import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_painter/image_painter.dart';
import 'package:luciddreams/api/img2img.dart';
import 'package:luciddreams/models/images.dart';
import 'package:meta/meta.dart';
import 'package:scidart/numdart.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../common/loading_status.dart';
import 'package:bitmap/bitmap.dart';

part 'img2img_state.dart';

class Img2imgCubit extends Cubit<Img2imgState> {
  Img2imgCubit() : super(Img2imgState());

  void selectImage(File? image) {
    if (image == null) {
      emit(
          state.copyWith(loadingStatus: LoadingFailed('Failed To Load Image')));
    } else {
      emit(state.copyWith(selectedImage: image));
    }
  }

  void createOrUpdateImage(File? image) {
    emit(state.copyWith(loadingStatus: LoadingSuccess(), selectedImage: image));
  }

  void img2imgInference(
    Uint8List? originalImageBytes,
    Uint8List? maskImageBytes,
    String prompt,
  ) async {
    emit(state.copyWith(inferenceLoading: LoadingInProgress()));
    try {
      if (originalImageBytes == null) {
        throw ('Missing Original Image');
      } else if (maskImageBytes == null) {
        throw ('Missing Masked Image');
      }
      List<RawImageModel> output = await Img2imgAPI.img2imgInference(
        originalImageBytes,
        maskImageBytes,
        prompt,
      );
      emit(state.copyWith(inferenceLoading: LoadingSuccess(), outputImages: output));
    } catch (e) {
      emit(state.copyWith(inferenceLoading: LoadingFailed(e.toString())));
    }
  }
}
