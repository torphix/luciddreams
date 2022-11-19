import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:luciddreams/models/images.dart';
import '../settings.dart';

class Img2imgAPI {
  static Future<List<RawImageModel>> img2imgInference(
      Uint8List originalImage, Uint8List maskedImage, String prompt) async {
    Response response = await http.post(
      Uri.parse('${Settings.rootUrl}/ml_models/inference/'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'model_name': 'torphix/stability-img2img',
        'input_data': {
          'org_img': base64Encode(originalImage),
          'mask_img': base64Encode(maskedImage),
          'prompt': prompt,
        },
      }),
    );
    // Decode response
    final outputJson = jsonDecode(response.body)['output_data'];
    List<RawImageModel> outputImages = List<RawImageModel>.from(outputJson.map((image) => RawImageModel(bytes: base64Decode(image))).toList());
    return outputImages;
  }
}
