import 'dart:ffi';
import 'dart:io';
import 'package:broke/clusterlist.dart';
import 'package:broke/DatabaseEntities.dart';
import 'package:broke/main.dart';
import 'package:broke/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';


/// Provides access to the ObjectBox Store throughout the app.
///
/// Create this in the apps main function.
class ObjectBox {
  /// The Store of this app.
  late final Store _store;

  // Keeping reference to avoid Admin getting closed.
  // ignore: unused_field
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

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store = await openStore();
    return ObjectBox._create(store);
  }


  //ClusterS#its

  Stream<List<Clusterr>> getClusters(){
    final builder = _clusterBox.query();

    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }

  void insertCluster(String cluster,String? initbud) {
    Clusterr newCluster = Clusterr(cluster: cluster, initbud: initbud);

    _clusterBox.put(newCluster);
  }

  //ExpenseS#its

  void insertExpense(String exp,String amnt,Clusterr clusterr) {
    Expenses newExp = Expenses(expense: exp, amnt: amnt);
    
    Clusterr updatedCluster = clusterr;
    updatedCluster.expenses.add(newExp);
    newExp.clusterr.target = updatedCluster;
    
    _clusterBox.put(updatedCluster);
    
  }

  Stream<List<Expenses>> getExpensesOfCluster(int clusterid){
    final builder = _expenseBox.query()..order(Expenses_.id,flags: Order.descending);
    builder.link(Expenses_.clusterr,Clusterr_.id.equals(clusterid));
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }
}


/*class ObjectBox {
  late final Box<Clusterr> _clusterBox;
  late final Box<Expenses> _expenseBox;
  late final Store _store;

  ObjectBox(this._store) {
    _clusterBox = Box<Clusterr>(_store);
    _expenseBox = Box<Expenses>(_store);
  }

  static Future<ObjectBox> init() async {

    late final Store _store;

    getApplicationDocumentsDirectory().then((dir) {
      _store = Store(
        getObjectBoxModel(),
        directory: join(dir.path,'objectbox'),
      ) ;
    });
    final store = await openStore();

    *//*if (Sync.isAvailable()) {
      /// Or use the ip address of your server
      //final ipSyncServer = '123.456.789.012';
      final ipSyncServer = Platform.isAndroid ? '10.0.2.2' : '127.0.0.1';
      final syncClient = Sync.client(
        store,
        'ws://$ipSyncServer:9999',
        SyncCredentials.none(),
      );
      syncClient.connectionEvents.listen(print);
      syncClient.start();
    }*//*

    return ObjectBox(store);
  }


  //Clusters

  Clusterr? getUser(int id) => _clusterBox.get(id);

  Stream<List<Clusterr>> getUsers() => _clusterBox
      .query()
      .watch(triggerImmediately: true)
      .map((query) => query.find());

  int insertUser(Clusterr cluster) => _clusterBox.put(cluster);

  *//*bool deleteUser(int id) => _clusterBox.remove(id);*//*

  //Expenses

  Expenses? getExp(int id) => _expenseBox.get(id);

  Stream<List<Expenses>> getExpenses() => _expenseBox
      .query()
      .watch(triggerImmediately: true)
      .map((query) => query.find());

  int insertExpense(Expenses cluster) {
    _expenseBox.Box<Expenses>.put(cluster);
    return 1;
  }

  bool deleteExpense(int id) => _expenseBox.remove(id);
}*/