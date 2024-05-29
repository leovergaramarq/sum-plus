import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sum_plus/ui/pages/auth/first_page.dart';

MaterialColor myPrimarySwatch = MaterialColor(0xFF997AC1, {
  50: Color(0xFFF5EEF7),
  100: Color(0xFFE4D6E5),
  200: Color(0xFFD3BED4),
  300: Color(0xFFC2A6C4),
  400: Color(0xFFB18EB3),
  500: Color(0xFF997AC1), // Este es el tono principal
  600: Color(0xFF8A6CB0),
  700: Color(0xFF7C5FA0),
  800: Color(0xFF6D5190),
  900: Color(0xFF5F4480),
});

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Summarizer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: myPrimarySwatch,
        primaryColor: Color(0xFF997AC1),
        fontFamily: 'Itim',
      ),
      home: const FirstPage(
        key: Key('FirstPage'),
      ),
    );
  }
}
