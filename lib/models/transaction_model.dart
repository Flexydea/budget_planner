import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

//transaction model for hive

@HiveType(typeId: 1)
class TransactionModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String description;

  @HiveField(2)
  String category;

  @HiveField(3)
  double amount;

  @HiveField(4)
  String type;

  @HiveField(5)
  DateTime date;

  TransactionModel({
    required this.id,
    required this.description,
    required this.category,
    required this.amount,
    required this.type,
    required this.date,
  });
}
