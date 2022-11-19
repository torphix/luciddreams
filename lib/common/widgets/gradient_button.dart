import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback onPressed;
  final Text text;
  final Icon? icon;
  final Color? colorOne;
  final Color? colorTwo;

  const GradientButton(
      {Key? key,
      required this.width,
      required this.height,
      required this.onPressed,
      required this.text,
      this.icon,
      this.colorOne = const Color(0xffffae88),
      this.colorTwo = const Color(0xff8f93ea)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(80),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [colorOne!, colorTwo!],
        ),
      ),
      child: MaterialButton(
          onPressed: onPressed,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: const StadiumBorder(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                text,
                icon == null ? const Text('') : icon!,
              ],
            ),
          )),
    );
  }
}