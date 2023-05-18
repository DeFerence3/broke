import 'package:broke/objectbox.dart';
import 'package:broke/objectbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ObjectBoxProvider extends StatelessWidget {
  final Widget child;
  final ObjectBox objectBox;

  const ObjectBoxProvider({
    Key? key,
    required this.child,
    required this.objectBox,
  }) : super(key: key);

  static ObjectBoxProvider of(BuildContext context) {
    return context.read<ObjectBoxProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<ObjectBoxProvider>.value(
      value: this,
      child: child,
    );
  }
}
