import 'package:broke/database/DatabaseEntities.dart';
import 'package:broke/main.dart';
import 'package:broke/modules/components/expenseview.dart';
import 'package:flutter/material.dart';

class ClusterDetails extends StatefulWidget {
  final Clusterr cluster;

  const ClusterDetails({Key? key, required this.cluster}) : super(key: key);

  @override
  _ClusterDetailsState createState() => _ClusterDetailsState();

}

class _ClusterDetailsState extends State<ClusterDetails> {
  final TextEditingController expenseNameController = TextEditingController();
  final TextEditingController expenseAmntController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late Clusterr clusterr;
  late Stream<List<Clusterr>> streamExpenses;

  ExpenseList Function(BuildContext, int) _itemBuilder(List<Expenses> expense) {
    return (BuildContext context, int index) =>
        ExpenseList(expenses: expense[index]);
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
            addNewExpenseDialogue(context);
          },
          icon: const Icon(Icons.add),
          label: const Text("Expense")
      ),
    );
  }

  void addNewExpenseDialogue(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("New Expense in ${widget.cluster.cluster}"),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: expenseNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  hintText: 'Expense Category',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Empty Category';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: expenseAmntController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  hintText: 'Amount',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Empty Amount';
                  }
                  return null;
                },
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
                        objectBox.insertExpense(expenseNameController.text,
                            expenseAmntController.text, widget.cluster);
                        popupPoper();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
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
