import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constants.dart';
import 'validators.dart';

class StringUtils {
  static const _baseStyle = TextStyle(fontSize: 14, color: Colors.black87);

  static tryToLaunchUrl(String rawUrl,
      {Function(String)? onError, String? errorString}) async {
    final Uri url = Uri.parse(rawUrl);
    if (!await launchUrl(url)) {
      onError?.call(errorString ?? 'Could not launch $url');
      if (kDebugMode) print('Could not launch $url');
    }
  }

  static void _separate(
      String inputString, String lastString, Function(String, String) result) {
    if (inputString.endsWith('.') ||
        inputString.endsWith(',') ||
        inputString.endsWith('!') ||
        inputString.endsWith('?')) {
      final lastStr = inputString[inputString.length - 1];
      final cutStr = inputString.substring(0, inputString.length - 1);
      _separate(cutStr, '$lastString$lastStr', result);
    } else {
      result(inputString, lastString);
    }
  }

  static Widget convertToRichText(String inputText,
      {TextStyle? customBaseTextStyle, Function(String)? onEmail}) {
    final baseTextStyle = customBaseTextStyle ?? _baseStyle;
    List<String> paragraphs = inputText.split('\n');
    List<TextSpan> textSpans = [];
    for (var paragraph in paragraphs) {
      List<String> words = paragraph.split(' ');
      for (var word in words) {
        String lastChar = '';
        _separate(word, lastChar, (p0, p1) {
          word = p0;
          lastChar = p1;
          if (EmailValidator(errorText: 'not email').isValid(word)) {
            textSpans.add(
              TextSpan(
                text: word,
                style: baseTextStyle.copyWith(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Pasteboard.writeText(word);
                    onEmail?.call(word);
                  },
              ),
            );
            textSpans.add(
              TextSpan(
                text: lastChar.isNotEmpty ? '$lastChar ' : ' ',
                style: baseTextStyle,
              ),
            );
          } else if (word.startsWith('http://') ||
              word.startsWith('https://')) {
            textSpans.add(
              TextSpan(
                text: word,
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
            textSpans.add(
              TextSpan(
                text: lastChar.isNotEmpty ? '$lastChar ' : ' ',
                style: baseTextStyle,
              ),
            );
          } else if (word.startsWith('0') &&
              NumberOnlyValidator(errorText: '').isValid(word)) {
            textSpans.add(
              TextSpan(
                text: word,
                style: baseTextStyle.copyWith(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    tryToLaunchUrl(word);
                  },
              ),
            );
            textSpans.add(
              TextSpan(
                text: lastChar.isNotEmpty ? '$lastChar ' : ' ',
                style: baseTextStyle,
              ),
            );
          } else {
            textSpans
                .add(TextSpan(text: '$word$lastChar ', style: baseTextStyle));
          }
        });
      }
      // add the break line character at the end of the paragraph
      textSpans.add(const TextSpan(text: '\n'));
    }
    return RichText(text: TextSpan(children: textSpans));
  }

  static String removeDiacritics(String inputString) {
    final diacriticsMap = {};
    final diacriticsRegExp = RegExp('[^\u0000-\u007E]', multiLine: true);
    if (diacriticsMap.isEmpty) {
      for (var i = 0; i < defaultDiacriticsRemovalap.length; i++) {
        var letters = defaultDiacriticsRemovalap[i]['letters'];
        for (var j = 0; j < letters!.length; j++) {
          diacriticsMap[letters[j]] = defaultDiacriticsRemovalap[i]['base'];
        }
      }
    }
    return inputString.replaceAllMapped(diacriticsRegExp, (a) {
      return diacriticsMap[a.group(0)] ?? a.group(0);
    });
  }

  static String? convertToCurrencyString(dynamic number, {NumberFormat? oCcy}) {
    if (number is num) {
      return (oCcy ?? NumberFormat("#,##0", "en_US")).format(number);
    } else if (number is String) {
      return (oCcy ?? NumberFormat("#,##0", "en_US"))
          .format(num.tryParse(number));
    } else {
      return null;
    }
  }
}
