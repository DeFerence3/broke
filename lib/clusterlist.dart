import 'dart:io';
import 'package:broke/clusterDetails.dart';
import 'package:broke/clusterlist.dart';
import 'package:broke/DatabaseEntities.dart';
import 'package:broke/main.dart';
import 'package:broke/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:broke/objectbox.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClusterList extends StatefulWidget {
  final Clusterr cluster;

  const ClusterList({Key? key,required this.cluster}):super(key: key);

  @override
  _ClusterListState createState() => _ClusterListState();
}

class _ClusterListState extends State<ClusterList> {

  static const List<IconData> moreOptionsIcon = [
    Icons.delete_forever_rounded,
    Icons.edit_attributes_rounded,
  ];

  static const List<String> moreOptionsItem = <String>[
    "Delete",
    "Edit",
  ];

  int userId = 0;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return Card(
      color: Theme.of(context).colorScheme.surfaceVariant,
      elevation: 20,
      child: InkWell(
        onTap: (){Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ClusterDetails(cluster: widget.cluster)),
        );},
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.cluster.cluster,
                  style: textTheme.headlineLarge,
                ),
              ),
               Align(
                alignment: Alignment.centerRight,
                child: PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                  onSelected: deleteSelectedUser,
                ),

              ),
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text("₹${widget.cluster.initbud}",
                    style: textTheme.titleLarge),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void deleteSelectedUser(int value) {
    setState(() {
      userId = value;
      switch(userId){
        case 0:

      }
    });
  }

  void showToast(){
    Fluttertoast.showToast(
        msg: "text",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  /*void openClusterDetails(String cluster,String initbud,int id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ClusterDetails(cluster,initbud,id)),
    );
  }*/
}