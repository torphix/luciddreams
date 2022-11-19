import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:luciddreams/api/image_browser.dart';
import 'package:luciddreams/models/txt2img.dart';
import 'package:luciddreams/settings.dart';

class Txt2imgAPI {
  // Returns the various options and associated changes in token cost
  static Future<Map<String, dynamic>> getOptionTokenCosts() async {
// {
//     "numImages": {"2": 0.2, "3": 0.4, "4": 0.6, "5": 0.8},
//     "height": {"640": 0.7, "768": 1.4},
//     "width": {"640": 0.7, "768": 1.4},
//     "numSteps": {"60": 0.2, "70": 0.4, "80": 0.6, "100": 0.8, "120": 1.0}
// }
    try {
      var url = Uri.parse(
          '${Settings.rootUrl}/ml_models/spend_opts/stability-txt2img/');
      final response = await http
          .get(url)
          .then((value) => jsonDecode(value.body)['token_options']);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> generateImages(
    String prompt,
    int numImages,
    int height,
    int width,
    int numSteps,
    int cfg,
    bool searchdb,
    bool nsfw,
  ) async {
    try {
      final requestBody = {
        'model_name': 'torphix/stability-txt2img',
        'input_data': {'text': prompt},
        'token_options': {
          'numImages': numImages,
          'height': height,
          'width': width,
          'numSteps': numSteps,
          'cfg': cfg,
          'nsfw': nsfw,
          'searchdb': searchdb,
        },
      };
      var url = Uri.parse('${Settings.rootUrl}/ml_models/inference/');
      final response =
          await http.post(url, body: requestBody).then((res) => res.body);

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
