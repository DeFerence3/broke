import 'package:broke/database/DatabaseEntities.dart';
import 'package:broke/modules/PackDetails.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClusterList extends StatefulWidget {
  final Clusterr cluster;

  const ClusterList({Key? key, required this.cluster}) : super(key: key);

  @override
  _ClusterListState createState() => _ClusterListState();
}

class _ClusterListState extends State<ClusterList> {
  static const List<IconData> moreOptionsIcon = [
    Icons.delete_forever_rounded,
    Icons.info_rounded,
  ];

  static const List<String> moreOptionsItem = <String>[
    "Delete",
    "Info",
  ];

  int userId = 0;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return Card(
      color: Theme.of(context).colorScheme.surface,
      elevation: 20,
      margin: const EdgeInsets.only(left: 12, right: 12, top: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ClusterDetails(cluster: widget.cluster)),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      widget.cluster.cluster,
                      style: textTheme.headlineLarge,
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.topRight,
                    child: PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      itemBuilder: (context) {
                        return List.generate(moreOptionsItem.length, (index) {
                          return PopupMenuItem(
                              value: index,
                              child: Wrap(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Icon(
                                      moreOptionsIcon[index],
                                      color: Color(0xff6750a4),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Text(moreOptionsItem[index]))
                                ],
                              ));
                        });
                      },
                      onSelected: packOptionsHandler,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(dateFormater(widget.cluster.datetime),
                    style: textTheme.titleMedium),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String dateFormater(DateTime datetime) {
    return formatDate(datetime, [d, " ", M, " ", yyyy]);
  }

  void packOptionsHandler(int value) {
    userId = value;
    switch (userId) {
      case 0:
        showToast("not implemented");
      case 1:
        infoCard(context);
    }
  }

  void infoCard(BuildContext context) {
    showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(widget.cluster.cluster),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("info of ${widget.cluster.cluster}"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: popupPoper,
                        child: const Text('Dismiss'),
                      ),
                      TextButton(
                        onPressed: popupPoper,
                        child: const Text('Add'),
                      ),
                    ],
                  )
                ],
              ),
            ));
  }

  void popupPoper() {
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
}
