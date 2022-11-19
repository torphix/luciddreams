import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:luciddreams/models/images.dart';

class ImageBrowserAPI {
  static Future<String> selectRandomPrompt() async {
    List<String> prompts = await rootBundle
        .loadString('assets/prompts.txt')
        .then((prompts) => prompts.split("\n"));
    return prompts[Random().nextInt(prompts.length)];
  }

  static Future<List<ImageModel>> lexicaTextSearch(
      {required String query}) async {
    // Search lexica API using text input
    try {
      var url = Uri.parse('https://lexica.art/api/v1/search?q=$query');
      final response = await http.get(url).then((value) => jsonDecode(value.body)['images']);
      List<ImageModel> images = [];
      for (var element in response) {
        images.add(ImageModel.fromJson((element)));
      }
      return images;
    } catch (e) {
      rethrow;
    }
  }
}
