class ExpenseModel {
  final String id;
  final double amount;
  final String description;
  final DateTime date;
  final String category;

  ExpenseModel({
    required this.id,
    required this.amount,
    required this.description,
    required this.date,
    required this.category, // ✅ Fix: added here
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'description': description,
    'date': date.toIso8601String(),
    'category': category, // ✅ Fix: added here
  };

  factory ExpenseModel.fromJson(Map<String, dynamic> json) => ExpenseModel(
    id: json['id'],
    amount: json['amount'],
    description: json['description'],
    date: DateTime.parse(json['date']),
    category: json['category'], // ✅ Fix: added here
  );
}
