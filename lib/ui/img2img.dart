import 'dart:io';

import 'package:bitmap/bitmap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_painter/image_painter.dart';
import 'package:luciddreams/bloc/img2img/img2img_cubit.dart';
import 'package:luciddreams/common/loading_status.dart';
import 'package:luciddreams/ui/image_detail.dart';
import 'package:luciddreams/ui/prompt_creation_guide.dart';
import 'package:scidart/numdart.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../common/snackbar.dart';

// Select image from phone
// apply mask to image
// add text prompt
// send to server for inference
class Img2img extends StatefulWidget {
  const Img2img({super.key});
  @override
  State<Img2img> createState() => _Img2imgState();
}

class _Img2imgState extends State<Img2img> {
  final Img2imgCubit _img2imgCubit = Img2imgCubit();

  void _getImage() async {
    const pickerConfig = AssetPickerConfig(
      maxAssets: 1,
    );

    // Debug code for emulator
    final byteData = await rootBundle.load('assets/temp.jpg');
    File imageFile;
    try {
      imageFile = File('${(await getTemporaryDirectory()).path}/temp.jpg');
      imageFile.deleteSync();
      imageFile = File('${(await getTemporaryDirectory()).path}/temp.jpg');
    } catch (e) {
      print(e);
      imageFile = File('${(await getTemporaryDirectory()).path}/temp.jpg');
    }
    imageFile.writeAsBytesSync(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    // final File? imageFile =
    // await AssetPicker.pickAssets(context, pickerConfig: pickerConfig)
    // .then((images) async => await images![0].file);
    _img2imgCubit.selectImage(imageFile);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => _img2imgCubit,
        child: Scaffold(
          body: BlocConsumer<Img2imgCubit, Img2imgState>(
            listener: (context, state) {
              if (state.loadingStatus is LoadingFailed) {
                showSnackBar(
                    context, state.loadingStatus!.exception.toString());
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      clipBehavior: Clip.hardEdge,
                      color: const Color.fromARGB(255, 226, 229, 231),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: state.selectedImage == null
                            ? MediaQuery.of(context).size.height * 0.35
                            : null,
                        child: InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: () async {
                            _getImage();
                          },
                          child: Center(
                            child: state.selectedImage == null
                                // Display placeholder if no image selected
                                ? const Icon(
                                    Icons.photo,
                                    color: Color.fromARGB(255, 119, 143, 155),
                                    size: 100,
                                  )
                                // Display image if selected
                                : Image.file(state.selectedImage!),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          bottomSheet: KeyboardVisibilityBuilder(
            builder: (context, isKeyboardVisible) {
              return BlocBuilder<Img2imgCubit, Img2imgState>(
                builder: (context, state) => Padding(
                  padding: isKeyboardVisible
                      ? const EdgeInsets.only(bottom: 0)
                      : const EdgeInsets.only(bottom: 60),
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImageEditor(
                              selectedImage: state.selectedImage,
                            ),
                          ),
                        );
                      },
                      child: const Text('Next'),
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }
}

class ImageEditor extends StatefulWidget {
  // Paint over image with finger
  // Convert painted regions to white
  // Convert non painted regions to black
  // Dispatch prompt mask and image
  const ImageEditor({super.key, this.selectedImage});
  final File? selectedImage;

  @override
  State<ImageEditor> createState() => _ImageEditorState();
}

class _ImageEditorState extends State<ImageEditor> {
  final _imageKey = GlobalKey<ImagePainterState>();
  final _key = GlobalKey<ScaffoldState>();
  final Img2imgCubit _img2imgCubit = Img2imgCubit();
  final TextEditingController _promptController = TextEditingController();
  final FocusNode _promptFocusNode = FocusNode();

  @override
  void initState() {
    _img2imgCubit.createOrUpdateImage(widget.selectedImage);
    super.initState();
  }

  void img2imgInference() async {
    final image = await _imageKey.currentState?.exportImage();
    final orgImage = await decodeImageFromList(image!.buffer.asUint8List());
    var blankImage =
        await Bitmap.blank(orgImage.width, orgImage.height).buildImage();
    final maskedImageBytes =
        await _imageKey.currentState?.exportPaintHistory(blankImage);
    _img2imgCubit.img2imgInference(
      await widget.selectedImage?.readAsBytes(),
      maskedImageBytes!,
      _promptController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _img2imgCubit,
      child: BlocConsumer<Img2imgCubit, Img2imgState>(
        listener: (context, state) => {
          if (state.loadingStatus is LoadingFailed)
            {showSnackBar(context, state.loadingStatus?.exception)}
          else if (state.inferenceLoading is LoadingFailed)
            {showSnackBar(context, state.inferenceLoading?.exception)}
          else if (state.inferenceLoading is LoadingSuccess)
            {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RawImageDetail(rawImages: state.outputImages),
                  ))
            }
        },
        builder: ((context, state) {
          Widget bodyValue;
          if (state.loadingStatus is LoadingInProgress ||
              state.inferenceLoading is LoadingInProgress) {
            bodyValue = const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            bodyValue = SingleChildScrollView(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                  child: TextField(
                    focusNode: _promptFocusNode,
                    controller: _promptController,
                    decoration: const InputDecoration(
                      labelText: 'Input Text Prompt..',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.green,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.purple,
                          width: 2.0,
                        ),
                      ),
                    ),
                    minLines:
                        6, // any number you need (It works as the rows for the textarea)
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                ),
                ImagePainter.file(
                  height: MediaQuery.of(context).size.height,
                  state.selectedImage!,
                  key: _imageKey,
                  scalable: true,
                  initialStrokeWidth: 40,
                  colors: [Color.fromARGB(255, 125, 255, 0)],
                  initialColor: Color.fromARGB(255, 125, 255, 0),
                  initialPaintMode: PaintMode.freeStyle,
                ),
              ]),
            );
          }

          return Scaffold(
            key: _key,
            appBar: AppBar(
              title: const Text('Mask Creator'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                // IconButton(
                //   icon: const Icon(Icons.save_alt),
                //   onPressed: saveImage,
                // )
              ],
            ),
            body: bodyValue,
            // Loading In Progress or failed
            bottomSheet: KeyboardVisibilityBuilder(
              builder: (context, isKeyboardVisible) {
                if (state.inferenceLoading is LoadingInProgress) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Padding(
                    padding: isKeyboardVisible
                        ? const EdgeInsets.only(bottom: 0)
                        : const EdgeInsets.only(bottom: 60),
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(),
                        onPressed: () async {
                          if (_promptController.text == '') {
                            FocusScope.of(context)
                                .requestFocus(_promptFocusNode);
                            showSnackBar(context,
                                'Please enter text, to specify image edits');
                          } else {
                            img2imgInference();
                          }
                        },
                        child: const Text('Edit Image'),
                      ),
                    ),
                  );
                }
              },
            ),
          );
        }),
      ),
    );
  }
}


// PICK UP POINT
// Extract mask from saved image
// Send post request to server