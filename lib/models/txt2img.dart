// The Various Key optoins
class Txt2imgResponse {
  String? uri;

  Txt2imgResponse({
    required this.uri,
  });

  Txt2imgResponse.fromJson(Map<String, dynamic> json) {
    uri = json['uri'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uri'] = uri;
    return data;
  }
}

// The Various Key optoins
class Txt2imgOptions {
  String? id;

  Txt2imgOptions({
    required this.id,
  });

  Txt2imgOptions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    return data;
  }
}
