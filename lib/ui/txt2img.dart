import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_radio_slider/flutter_radio_slider.dart';
import 'package:http/http.dart';
import 'package:luciddreams/bloc/txt2img/txt2img_cubit.dart';
import 'package:luciddreams/common/loading_status.dart';
import 'package:luciddreams/common/snackbar.dart';
import 'package:luciddreams/ui/prompt_creation_guide.dart';

class Txt2img extends StatefulWidget {
  const Txt2img({super.key});

  @override
  State<Txt2img> createState() => _Txt2imgState();
}

class _Txt2imgState extends State<Txt2img> {
  late Txt2imgCubit _txt2imgCubit;
  final TextEditingController _promptController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _txt2imgCubit = Txt2imgCubit();
    _txt2imgCubit.getKeywords();
  }

  @override
  void dispose() {
    super.dispose();
    _txt2imgCubit.close();
  }

  void _addKeywordToPrompt(String keyword) {
    keyword = keyword.split('|')[0].trim();
    String outputPrompt = '';
    // Add nothing if already present
    if (_promptController.text.contains(keyword)) {
      return;
    }
    // If empty
    if (_promptController.text.isEmpty) {
      outputPrompt = keyword;
    } else {
      outputPrompt = '${_promptController.text}, $keyword';
      outputPrompt = outputPrompt.replaceAll(',,', ',').replaceAll(', ,', ',');
    }
    _promptController.text = outputPrompt;
  }

  void _removeKeywordWordFromPrompt(String keyword) {
    var outputText = _promptController.text;
    outputText = outputText.replaceAll('$keyword,', '');
    outputText = outputText.replaceAll(keyword, '');
    _promptController.text = outputText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
          create: (context) => _txt2imgCubit,
          child: BlocConsumer<Txt2imgCubit, Txt2imgState>(
            listener: (context, state) {
              // TODO: ADD error snackbar notifcation here
            },
            builder: (context, state) {
              return SingleChildScrollView(
                  child: Column(
                children: [
                  _txt2imgForm(),
                  _txt2imgOptions(),
                ],
              ));
            },
          ),
        ),
        bottomSheet:
            KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
          return Padding(
            padding: isKeyboardVisible
                ? const EdgeInsets.only(bottom: 0)
                : const EdgeInsets.only(bottom: 60),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50)),
              onPressed: () {
                if (_promptController.text == '') {
                  showSnackBar(context, 'Prompt cannot be empty!');
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Txt2imgAdvancedOptions(
                          prompt: _promptController.text),
                    ),
                  );
                }
              },
              child: const Text('Next'),
            ),
          );
        }));
  }

  Widget _txt2imgForm() {
    return BlocBuilder<Txt2imgCubit, Txt2imgState>(builder: (context, state) {
      return Padding(
          padding: const EdgeInsets.fromLTRB(8, 15, 8, 8),
          child: Column(
            children: [
              TextField(
                controller: _promptController,
                decoration: const InputDecoration(
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
            ],
          ));
    });
  }

  Widget _txt2imgOptions() {
    return BlocBuilder<Txt2imgCubit, Txt2imgState>(builder: (context, state) {
      List<CheckboxListTile> keywords = state.promptKeywords
          .map((keyword) => CheckboxListTile(
                title: Text(keyword),
                value: _promptController.text
                        .contains(keyword.split('|')[0].trim())
                    ? true
                    : false,
                onChanged: (keywordInPrompt) {
                  keyword = keyword.split('|')[0].trim();
                  if (_promptController.text.contains(keyword)) {
                    _removeKeywordWordFromPrompt(keyword);
                  } else {
                    _addKeywordToPrompt(keyword);
                  }
                  setState(() {});
                },
              ))
          .toList();
      return Column(
        children: [
          ListTile(
            title: const Text(
              'Prompt Creation Guide',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: const Icon(Icons.arrow_forward_sharp),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => promptCreationGuide(context)),
              );
            },
          ),
          CheckboxListTile(
              title: const Text(
                'Filter NSFW',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              value: state.nsfw,
              onChanged: (value) {
                context.read<Txt2imgCubit>().toggleNsfw();
              }),
          ExpansionTile(
            title: const Text(
              'Magic Keywords',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: const Text('Beautify your image in different ways'),
            children: keywords,
          ),
        ],
      );
    });
  }

  
}

class Txt2imgAdvancedOptions extends StatefulWidget {
  const Txt2imgAdvancedOptions({super.key, required this.prompt});
  final String prompt;

  @override
  State<Txt2imgAdvancedOptions> createState() => _Txt2imgAdvancedOptionsState();
}

class _Txt2imgAdvancedOptionsState extends State<Txt2imgAdvancedOptions> {
  final Txt2imgCubit _txt2imgCubit = Txt2imgCubit();

  @override
  void initState() {
    super.initState();
    _txt2imgCubit.getTokenSpendOpts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _txt2imgCubit,
      child: BlocConsumer<Txt2imgCubit, Txt2imgState>(
        listener: (context, state) => {
          if (state.loadingStatus is LoadingFailed)
            {showSnackBar(context, state.loadingStatus.exception)}
        },
        builder: ((context, state) => Scaffold(
              appBar: AppBar(
                  title: const Text('Advanced Options'),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  )),
              body: SingleChildScrollView(
                child: Column(children: [
                  // Num Images Options
                  Align(
                      alignment: Alignment.center,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 25, 0, 15),
                          child: Text(
                              'Number of Images to Generate ${state.numImages}',
                              style: TextStyle(fontWeight: FontWeight.w500)))),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                        trackHeight: 5,
                        overlayColor: Colors.lightGreen.withAlpha(32),
                        activeTickMarkColor: Colors.lightGreen,
                        activeTrackColor: Colors.grey[300],
                        inactiveTrackColor: Colors.grey[300],
                        inactiveTickMarkColor: Colors.grey[500]),
                    child: RadioSlider(
                      onChanged: (value) {
                        value += 1;
                        _txt2imgCubit.changeNumImagesGenerated(value);
                      },
                      value: 0,
                      divisions: 5,
                      outerCircle: true,
                    ),
                  ),
                  CheckboxListTile(
                      title: const Text('Search database first'),
                      value: state.searchdb,
                      onChanged: (value) =>
                          _txt2imgCubit.searchdbToggle(value)),
                  const ExpansionTile(
                    title: Text(
                      'Advanced Options',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text('Defaults are usually good'),
                    children: [],
                  ),
                ]),
              ),
              bottomSheet: Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50)),
                  onPressed: () {
                    _txt2imgCubit.generateImages();
                  },
                  child: Text('Create | Tokens: ${state.numTokens}'),
                ),
              ),
            )),
      ),
    );
  }
}
