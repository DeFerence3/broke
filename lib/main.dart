import 'package:broke/database/objectbox.dart';
import 'package:broke/database/objectboxprovider.dart';
import 'package:broke/modules/HomePage.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

late ObjectBox objectBox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectBox = await ObjectBox.create();

  runApp(ObjectBoxProvider(
    objectBox: objectBox,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  static final _defaultLightColorScheme =
      ColorScheme.fromSwatch(primarySwatch: Colors.teal);

  static final _defaultDarkColorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.teal, brightness: Brightness.dark);

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Broken",
        theme: ThemeData(
          fontFamily: DefaultTextStyle.of(context).style.fontFamily,
          colorScheme: lightColorScheme ?? _defaultLightColorScheme,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          fontFamily: DefaultTextStyle.of(context).style.fontFamily,
          colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
          useMaterial3: true,
        ),
        home: const HomePage(),
      );
    });
  }
}