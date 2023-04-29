import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'constants.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Breezy Checks',
      theme: ThemeData(
        fontFamily: 'Poppins',
        brightness: Brightness.light,
        scaffoldBackgroundColor: accentGrey,
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: accentGrey,
          cursorColor: Colors.black,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black87,
            ),
          ),
        ),
        textButtonTheme: const TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStatePropertyAll(Colors.black),
          ),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: mainGrey,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: mainGrey),
      ),
      home: const HomePage(),
    );
  }
}
