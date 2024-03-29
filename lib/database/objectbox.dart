import 'dart:io';

import 'package:broke/database/DatabaseEntities.dart';
import 'package:broke/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Provides access to the ObjectBox Store throughout the app.
///
/// Create this in the apps main function.
class ObjectBox {
  /// The Store of this app.
  late final Store _store;
  late final Admin _admin;

  /// Two Boxes: one for CLuster, one for Expense.
  late final Box<Clusterr> _clusterBox;
  late final Box<Expenses> _expenseBox;

  ObjectBox._create(this._store) {
    // Optional: enable ObjectBox Admin on debug builds.
    // https://docs.objectbox.io/data-browser
    if (Admin.isAvailable()) {
      // Keep a reference until no longer needed or manually closed.
      _admin = Admin(_store);
    }
    _clusterBox = Box<Clusterr>(_store);
    _expenseBox = Box<Expenses>(_store);
  }

  static Future<ObjectBox> create() async {
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store = await openStore();
    return ObjectBox._create(store);
  }

  Stream<List<Clusterr>> getClusters() {
    final builder = _clusterBox.query();
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }

  void insertCluster(String cluster, String? initbud, DateTime datetime) {
    Clusterr newCluster =
    Clusterr(cluster: cluster, initbud: initbud, datetime: datetime);
    _clusterBox.put(newCluster);
  }

  void insertExpense(String exp, String amnt, Clusterr clusterr) {
    Expenses newExp = Expenses(expense: exp, amnt: amnt);

    Clusterr updatedCluster = clusterr;
    updatedCluster.expenses.add(newExp);
    newExp.clusterr.target = updatedCluster;

    _clusterBox.put(updatedCluster);
  }

  Stream<List<Expenses>> getExpensesOfCluster(int clusterid) {
    final builder = _expenseBox.query()
      ..order(Expenses_.id, flags: Order.descending);
    builder.link(Expenses_.clusterr, Clusterr_.id.equals(clusterid));
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }

  Future<void> backupRestoreObjectBox(String path, bool mode) async {
    File sourceFile, destinationFile;

    //Checks if it is a backup mode or restore mode
    mode
        ? {
            sourceFile = File("${_store.directoryPath}/data.mdb"),
            destinationFile = File("$path/backup.zip"),
            oldFileDeleter(destinationFile),
            await sourceFile.copy(destinationFile.path),
            showToast("Backup Successful")
          }
        : {
            sourceFile = File(path),
            destinationFile = File("${_store.directoryPath}/data.mdb"),

            await sourceFile.copy(destinationFile.path),
            showToast("Restore Successful")
          };
  }

  void showToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void oldFileDeleter(File destinationFile) async {
    if (destinationFile.existsSync()) {
      try {
        await destinationFile.delete();
        showToast("File deleted");
      } catch (error) {
        debugPrint(error.toString());
      }
    }
  }
}