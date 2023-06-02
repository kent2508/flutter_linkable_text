import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:url_launcher/url_launcher.dart';

import 'validators.dart';

class FLTTextFunctions {
  static const _baseStyle = TextStyle(fontSize: 14, color: Colors.black87);

  static tryToLaunchUrl(String rawUrl,
      {Function(String)? onError, String? errorString}) async {
    final Uri url = Uri.parse(rawUrl);
    if (!await launchUrl(url)) {
      onError?.call(errorString ?? 'Could not launch $url');
      if (kDebugMode) print('Could not launch $url');
    }
  }

  static Widget convertToRichText(BuildContext context, String inputText,
      {TextStyle? customBaseTextStyle}) {
    final baseTextStyle = customBaseTextStyle ?? _baseStyle;
    List<String> words = inputText.split(' ');
    List<TextSpan> textSpans = [];
    for (var word in words) {
      if (EmailValidator(errorText: 'not email').isValid(word)) {
        textSpans.add(
          TextSpan(
            text: '$word ',
            style: baseTextStyle.copyWith(color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Pasteboard.writeText(word);
              },
          ),
        );
        continue;
      }
      if (word.startsWith('http://') || word.startsWith('https://')) {
        textSpans.add(
          TextSpan(
            text: '$word ',
            style: baseTextStyle.copyWith(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                tryToLaunchUrl(word);
              },
          ),
        );
        continue;
      }
      if (word.startsWith('0') &&
          NumberOnlyValidator(errorText: '').isValid(word)) {
        textSpans.add(
          TextSpan(
            text: '$word ',
            style: baseTextStyle.copyWith(color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                tryToLaunchUrl(word);
              },
          ),
        );
        continue;
      }
      textSpans.add(TextSpan(text: '$word ', style: baseTextStyle));
    }
    return RichText(text: TextSpan(children: textSpans));
  }
}
