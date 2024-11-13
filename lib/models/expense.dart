class Expense {
  int? id;
  String item;
  double price;
  DateTime date;

  Expense(
      {this.id, required this.item, required this.price, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'item': item,
      'price': price,
      'date': date.toIso8601String(),
    };
  }

  static Expense fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      item: map['item'],
      price: map['price'],
      date: DateTime.parse(map['date']),
    );
  }
}
