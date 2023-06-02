<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

Convert a normal Text widget to RichText widget, change the color of links, email addresses, phone numbers to blue and add a tap gesture to them.

## Usage

Add package to `pubspec.yaml` file.

```dart
dependencies:
  flutter_linkable_text: ^latest
```

Import package to code file.

```dart
import 'package:flutter_linkable_text/flutter_linkable_text.dart';
```

## Example
Use as a normal widget:

```dart
Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: FLTTextFunctions.convertToRichText(inputText),
)
```
