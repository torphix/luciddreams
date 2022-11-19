import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../models/images.dart';

class RawImageDetail extends StatefulWidget {
  final List<RawImageModel> rawImages;
  const RawImageDetail({super.key, required this.rawImages});

  @override
  State<RawImageDetail> createState() => _RawImageDetailState();
}

class _RawImageDetailState extends State<RawImageDetail> {
  @override
  Widget build(BuildContext context) {
    List<Widget> images = widget.rawImages
        .map(
          (img) => InteractiveViewer(
            panEnabled: false, // Set it to false
            boundaryMargin: const EdgeInsets.all(100),
            maxScale: 10,
            minScale: 1,
            child: Center(child: Image.memory(img.bytes!)),
          ),
        )
        .toList();
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        )),
        body: SingleChildScrollView(
          child: Column(children: images),
        ));
  }
}
