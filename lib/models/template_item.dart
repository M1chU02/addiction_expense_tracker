class TemplateItem {
  final int? id;
  final String name;
  final double price;

  TemplateItem({
    this.id,
    required this.name,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }

  factory TemplateItem.fromMap(Map<String, dynamic> map) {
    return TemplateItem(
      id: map['id'],
      name: map['name'],
      price: map['price'],
    );
  }
}
