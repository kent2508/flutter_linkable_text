import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_string_utils/flutter_string_utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      builder: EasyLoading.init(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 16),
            const Text(
              'This text below has links, phone numbers and email addresses:',
            ),
            StringUtils.convertToRichText(
                'Hello, we come from https://luckystars.com, with hotline 02241554111. You got an award from our marketing campain. So, please send your information to email award_here@fakemail.com.\nGoodbye.',
                onEmail: (email) {
              EasyLoading.showToast(email);
            }),
            const SizedBox(height: 48),
            const Text(
              'Hôm nay trời đẹp quá',
            ),
            const Text(
              '=>',
            ),
            Text(
              'Hôm nay trời đẹp quá'.removeDiacritics,
            ),
            const SizedBox(height: 48),
            const Text(
              '2000000',
            ),
            const Text(
              '=>',
            ),
            Text(
              StringUtils.convertToCurrencyString('2000000') ?? '',
            ),
            const SizedBox(height: 48),
            Text(
              'Today: ${DateTime.now().toDateStringWithFormatDDMMYYYY}',
            ),
            const SizedBox(height: 8),
            Text(
              'Someday: ${'1989-09-07T00:00:00'.toDateStringWithFormatDDMMYYYY}',
            ),
          ],
        ),
      ),
    );
  }
}
