import 'package:broke/expenseview.dart';
import 'package:broke/main.dart';
import 'package:broke/objectbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:broke/DatabaseEntities.dart';

class ClusterDetails extends StatefulWidget {
  final Clusterr cluster;

  const ClusterDetails({Key? key, required this.cluster}) : super(key: key);

  @override
  _ClusterDetailsState createState() => _ClusterDetailsState();

}

class _ClusterDetailsState extends State<ClusterDetails> {

  ExpenseList Function(BuildContext, int) _itemBuilder(List<Expenses> expense) {
    return (BuildContext context, int index) => ExpenseList(expenses: expense[index]);
  }

  late Expenses _expenses;
  late Clusterr clusterr;
  late Stream<List<Clusterr>> streamExpenses;
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
        title: Text(widget.cluster.cluster,
          style: textTheme.headlineLarge,),
      ),
      body: StreamBuilder<List<Expenses>>(
          stream: objectBox.getExpensesOfCluster(widget.cluster.id),
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
          label: const Text("Expense")
      ),
    );
  }

  final TextEditingController expenseNameController = TextEditingController();
  final TextEditingController expenseAmntController = TextEditingController();

  void openDialog(BuildContext context) {
    bool validate = false;
    showDialog<void>(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text("Add New Expanse on ${widget.cluster}"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: expenseNameController,
                  decoration: InputDecoration(
                    errorText: validate? "Empty" : null,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    hintText: 'Expense Category',
                  ),
                ),
                const SizedBox(height: 10,),
                TextField(
                  controller: expenseAmntController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    hintText: 'Amount',
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
                          expenseNameController.text.isEmpty? validate = true : validate = false;
                        });
                        if(!validate){
                          objectBox.insertExpense(expenseNameController.text,expenseAmntController.text,widget.cluster);
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
    expenseNameController.text = "";
    expenseAmntController.text = "";
    Navigator.of(context).pop();
  }

}
