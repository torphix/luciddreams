import 'dart:convert';

import 'package:flutter/foundation.dart';

class RawImageModel {
  Uint8List? bytes;
  RawImageModel({this.bytes});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bytes'] = base64Encode(bytes!);
    return data;
  }
}

class ImageModel {
  String? id;
  String? gallery;
  String? src;
  String? srcSmall;
  String? prompt;
  int? width;
  int? height;
  String? seed;
  bool? grid;
  String? model;
  int? guidance;
  String? promptid;
  bool? nsfw;

  ImageModel({
    required this.id,
    required this.gallery,
    required this.src,
    required this.srcSmall,
    required this.prompt,
    required this.width,
    required this.height,
    required this.seed,
    required this.grid,
    required this.model,
    required this.guidance,
    required this.promptid,
    required this.nsfw,
  });

  ImageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    gallery = json['gallery'];
    src = json['src'];
    srcSmall = json['srcSmall'];
    prompt = json['prompt'];
    width = json['width'];
    height = json['height'];
    seed = json['seed'];
    grid = json['grid'];
    model = json['model'];
    guidance = json['guidance'];
    promptid = json['promptid'];
    nsfw = json['nsfw'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['gallery'] = gallery;
    data['src'] = src;
    data['srcSmall'] = srcSmall;
    data['prompt'] = prompt;
    data['width'] = width;
    data['height'] = height;
    data['seed'] = seed;
    data['grid'] = grid;
    data['model'] = model;
    data['guidance'] = guidance;
    data['promptid'] = promptid;
    data['nsfw'] = nsfw;
    return data;
  }
}
