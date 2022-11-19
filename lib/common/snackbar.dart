import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: KeyboardVisibilityBuilder(
          builder: (p0, isKeyboardVisible) => Padding(
            padding: isKeyboardVisible
                ? const EdgeInsets.only(bottom: 0)
                : const EdgeInsets.only(bottom: 60),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      message,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Icon(
                    Icons.error,
                    color: Colors.amber,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
}
