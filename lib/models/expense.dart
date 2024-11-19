class Expense {
  final int? id;
  final String item;
  final double price;
  final String date;
  final int quantity;

  Expense({
    this.id,
    required this.item,
    required this.price,
    required this.date,
    this.quantity = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'item': item,
      'price': price,
      'date': date,
      'quantity': quantity,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      item: map['item'],
      price: map['price'],
      date: map['date'],
      quantity: map['quantity'] ?? 1,
    );
  }
}
