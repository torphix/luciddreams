import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luciddreams/common/loading_status.dart';
import 'package:luciddreams/common/snackbar.dart';
import 'package:luciddreams/bloc/image_browser/image_browser_cubit.dart';
import 'package:luciddreams/common/searchbar.dart';
import 'package:luciddreams/models/images.dart';
import 'package:transparent_image/transparent_image.dart';


class ImageBrowser extends StatefulWidget {
  const ImageBrowser({super.key});

  @override
  State<ImageBrowser> createState() => _ImageBrowserState();
}

class _ImageBrowserState extends State<ImageBrowser> {
  late TextEditingController _textEditingController;
  late ImageBrowserCubit _imageGalleryCubit;
  final FocusNode focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _imageGalleryCubit = ImageBrowserCubit()..getInitialImages();
    _textEditingController =
        TextEditingController(text: _imageGalleryCubit.state.prompt);
  }

  @override
  void dispose() {
    super.dispose();
    _imageGalleryCubit.close();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Browser'), actions: <Widget>[
        IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ImageSearchDelegate(
                    searchCallback: _imageGalleryCubit.getInitialImages),
              );
            })
      ]),
      body: BlocProvider(
        create: (context) => _imageGalleryCubit,
        child: BlocConsumer<ImageBrowserCubit, ImageBrowserState>(
          listener: (context, state) {
            if (state.loadingStatus is LoadingFailed) {
              showSnackBar(context, state.loadingStatus.exception);
            }
          },
          builder: (context, state) {
            if (state.loadingStatus is LoadingInProgress) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.loadingStatus is LoadingSuccess) {
              final images = state.lexicaImages
                  .map((image) => Padding(
                      padding: const EdgeInsets.all(4),
                      child: GestureDetector(
                          onTap: (() => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          _imageDetailScreen(context, image)),
                                )
                              }),
                          child: Image.network(image.src!))))
                  .toList();
              return SingleChildScrollView(
                  child: Column(children: [
                ...images,
              ]));
            }
            return Column(
              children: const [Text('Connection Error')],
            );
          },
        ),
      ),
    );
  }
}

Widget _imageDetailScreen(BuildContext context, ImageModel lexicaImage) {
  return Scaffold(
      appBar: AppBar(
          leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      )),
      body: SingleChildScrollView(
        child: Column(children: [
          InteractiveViewer(
              panEnabled: false, // Set it to false
              boundaryMargin: const EdgeInsets.all(100),
              maxScale: 10,
              minScale: 1,
              child:
            Center(
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image:   lexicaImage.src!,
              ),
            ),
              
             ),
          Padding(padding:const EdgeInsets.all(15), child: Text(lexicaImage.prompt!, style:const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))
        ]),
      ));
}

class ImageSearchDelegate extends SearchDelegate {
  final Function searchCallback;

  ImageSearchDelegate({
    required this.searchCallback,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
// this will show clear query button
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
// adding a back button to close the search
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    close(context, 'result');
    searchCallback(text: query);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column();
    // return Column(children: [
    //   CheckboxListTile(
    //     value: false,
    //     title: Text('NSFW'),
    //     onChanged: (i) {},
    //   ),
    //   CheckboxListTile(
    //     value: false,
    //     title: Text('Auto beautify prompts'),
    //     onChanged: (i) {},
    //   ),
    // ]);
// I will add this step as an optional step later
  }
}
