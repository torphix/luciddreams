import 'package:flutter/material.dart';

Widget promptCreationGuide(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        )),
        body: SingleChildScrollView(
          child: Column(children: []),
        ));
  }