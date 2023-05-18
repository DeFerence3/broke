import 'package:broke/mainpage.dart';
import 'package:broke/objectbox.dart';
import 'package:broke/objectboxprovider.dart';
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

late ThemeData themeData;

ThemeData updateThemes(bool useMaterial3) {
  return ThemeData(
      colorSchemeSeed: Colors.teal,
      useMaterial3: useMaterial3,
      brightness: Brightness.dark
  ); //useLightMode ? Brightness.light :
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context){

    themeData = updateThemes(true);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Broken",
      theme: themeData,
      home: HomePage(),
    );
  }
}