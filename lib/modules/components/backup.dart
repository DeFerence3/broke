import 'dart:io';

import 'package:broke/database/objectbox.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BackupPage extends StatefulWidget {
  final ObjectBox objectbox;

  const BackupPage(this.objectbox, {super.key});

  @override
  _BackupPageState createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Local Backup',
                  style: textTheme.headlineSmall,
                  selectionColor: colorScheme.onSecondary,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Backup your Expense, Income, Savings databases to local storage',
                  style: textTheme.bodyLarge,
                  selectionColor: colorScheme.onSecondary,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        permissionCheckerAndPathSelector(true);
                      },
                      child: const Text('Backup'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        permissionCheckerAndPathSelector(false);
                      },
                      child: const Text('Restore'),
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.onSecondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cloud Backup',
                  style: textTheme.headlineSmall,
                  selectionColor: colorScheme.onSecondary,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Backup your Expense, Income, Savings databases to Google Drive',
                  style: textTheme.bodyLarge,
                  selectionColor: colorScheme.onSecondary,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showToast("not implemented");
                      },
                      child: const Text('Backup'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showToast("not implemented");
                      },
                      child: const Text('Restore'),
                    )
                  ],
                ),
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

  void showToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  permissionCheckerAndPathSelector(bool mode) async {
    String? selectedDirectory;
    FilePickerResult? result;
    File file, fi;
    mode
        ? {
            selectedDirectory = await FilePicker.platform.getDirectoryPath(),
            if (selectedDirectory != null)
              {
                fi = File("$selectedDirectory/bacup.zip"),
                fi.existsSync() ? fi.deleteSync() : null,
                widget.objectbox.backupRestoreObjectBox(selectedDirectory, mode)
              }
          }
        : {
            result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['zip'],
            ),
            if (result != null)
              {
                widget.objectbox.backupRestoreObjectBox(
                    result.files.single.path as String, mode),
              }
          };
  }
}
