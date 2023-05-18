import 'package:broke/modules/components/clusterlist.dart';
import 'package:broke/database/DatabaseEntities.dart';
import 'package:broke/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ClusterList Function(BuildContext, int) _itemBuilder(List<Clusterr> cluster) =>
          (BuildContext context, int index) => ClusterList(cluster: cluster[index]);

  late Stream<List<Clusterr>> streamCluster;

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
      appBar: AppBar(
        title: Text(
          "Yeah, I know",
        style: textTheme.headlineMedium,
        ),
      ),
       body: StreamBuilder<List<Clusterr>>(
         stream: objectBox.getClusters(),
         builder: (context,snapshot){
           if(!snapshot.hasData){
             return const Center(
               child: CircularProgressIndicator(),
             );
           }else{
             final clusters = snapshot.data!;

             return ListView.builder(
                 itemCount: clusters.length,
                 itemBuilder: _itemBuilder(snapshot.data?? [])
             );
           }
         }
       ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            openDialog(context);
          },
          icon: const Icon(Icons.add),
          label: const Text("Pack")
      ),
    );
  }

  final TextEditingController clusterNameController = TextEditingController();
  final TextEditingController initialBudgetController = TextEditingController();

  void openDialog(BuildContext context) {
    bool validate = false;
    showDialog<void>(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text("Add New Expanse Pack"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: clusterNameController,
                  decoration: InputDecoration(
                    errorText: validate? "Empty Pack" : null,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    hintText: 'Pack Name',
                  ),
                ),
                const SizedBox(height: 10,),
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
                      child:  const Text('Add'),
                      onPressed: () {
                        setState(() {
                          clusterNameController.text.isEmpty? validate = true : validate = false;
                        });
                        if(!validate){
                          objectBox.insertCluster(clusterNameController.text, initialBudgetController.text);
                          popupPoper();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
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
        fontSize: 16.0
    );
  }
}