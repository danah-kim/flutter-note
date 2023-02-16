class TransactionModel {
  final String id, title;
  final double amount;
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
  });
}
