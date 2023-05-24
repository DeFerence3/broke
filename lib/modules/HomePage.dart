import 'package:broke/database/DatabaseEntities.dart';
import 'package:broke/main.dart';
import 'package:broke/modules/components/packlist.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController clusterNameController = TextEditingController();
  final TextEditingController initialBudgetController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int settingsId = 0;
  late Stream<List<Clusterr>> streamCluster;
  static const List<IconData> settingsIcons = [
    Icons.add_to_drive_rounded,
    Icons.settings_suggest_rounded,
    Icons.settings_suggest_rounded,
    Icons.settings_suggest_rounded,
    Icons.settings_suggest_rounded,
  ];

  static const List<String> settingsOptions = <String>[
    "Backup",
    "Option1",
    "Option2",
    "Option3",
    "Option4",
  ];

  ClusterList Function(BuildContext, int) _itemBuilder(List<Clusterr> cluster) {
    return (BuildContext context, int index) {
      return ClusterList(cluster: cluster[index]);
    };
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return Scaffold(
      appBar: appbar(textTheme),
      body: StreamBuilder<List<Clusterr>>(
          stream: objectBox.getClusters(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final clusters = snapshot.data!;
              return ListView.builder(
                  itemCount: clusters.length,
                  itemBuilder: _itemBuilder(snapshot.data ?? []));
            }
          }),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            addTaskDialog(context);
          },
          icon: const Icon(Icons.add),
          label: const Text("Pack")),
    );
  }

  appbar(TextTheme textTheme) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "You Broke ",
            style: textTheme.headlineMedium,
          ),
          Text(
            "Yeah, I know",
            style: textTheme.titleSmall,
          )
        ],
      ),
      actions: [
        PopupMenuButton(
          icon: const Icon(Icons.settings_rounded),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          itemBuilder: (context) {
            return List.generate(settingsOptions.length, (index) {
              return PopupMenuItem(
                  value: index,
                  child: Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Icon(
                          settingsIcons[index],
                          color: Color(0xff6750a4),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(settingsOptions[index]))
                    ],
                  ));
            });
          },
          onSelected: settingsOptionsSelectedHandler,
        )
      ],
    );
  }

  void settingsOptionsSelectedHandler(int value) {
    setState(() {
      settingsId = value;
      showToast("$settingsId not ready");
    });
  }

  void popupPoper() {
    clusterNameController.text = "";
    initialBudgetController.text = "";
    Navigator.of(context).pop();
  }

  void showToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void addTaskDialog(BuildContext context) {
    showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Add New Expanse Pack"),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: clusterNameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        hintText: 'Pack Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Empty Pack Name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: initialBudgetController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        hintText: 'Initial Budget',
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: const Text('Dismiss'),
                          onPressed: () {
                            popupPoper();
                          },
                        ),
                        TextButton(
                          child: const Text('Add'),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              objectBox.insertCluster(
                                  clusterNameController.text,
                                  initialBudgetController.text,
                                  currentdate());
                              popupPoper();
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ));
  }

  DateTime currentdate() {
    DateTime now = DateTime.now();
    DateTime curentdate = DateTime(now.year, now.month, now.day);
    return curentdate;
  }
}