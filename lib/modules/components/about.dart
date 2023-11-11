import 'dart:io';

import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {

  const AboutPage({super.key});

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: appbar(textTheme),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.onSecondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Text(
                  'Local Backup',
                  style: textTheme.headlineSmall,
                  selectionColor: colorScheme.onSecondary,
                  textAlign: TextAlign.left,
                ),
                Text(Platform.version)
              ],
            ),
          ),
        ],
      ),
    );
  }

  appbar(TextTheme textTheme) {
    return AppBar(
      leading: const BackButton(),
      title: Text(
        "Broke ",
        style: textTheme.headlineMedium,
      ),
    );
  }
}
