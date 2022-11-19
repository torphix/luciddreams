import 'package:flutter/material.dart';
import 'package:luciddreams/ui/img2img.dart';
import 'package:luciddreams/ui/txt2img.dart';

class Editor extends StatefulWidget {
  const Editor({super.key});

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.edit), text: 'Image Editor'),
              Tab(icon: Icon(Icons.draw), text: 'Image Creator'),
            ],
          ),
          centerTitle: true,
          title: const Text('Lucid Dreams'),
        ),
        body: const TabBarView(
          children: [
            Img2img(),
            Txt2img(),
          ],
        ),
      ),
    );
  }
}
