// Annotate a Dart class to create a box
import 'package:objectbox/objectbox.dart';

@Entity()
class Clusterr {
  @Id()
  int id;
  String cluster;
  String? initbud;
  DateTime datetime;

  @Backlink()
  final expenses = ToMany<Expenses>();

  Clusterr(
      {this.id = 0,
      required this.cluster,
      this.initbud,
      required this.datetime});
}

@Entity()
class Expenses {
  @Id()
  int id;
  String expense;
  String amnt;

  final clusterr = ToOne<Clusterr>();

  Expenses({this.id = 0, required this.expense,required this.amnt});
}