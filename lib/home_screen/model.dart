class FoodItem {
  final String id;
  final String name;
  final double price;

  FoodItem({
    required this.id,
    required this.name,
    required this.price,
  });

  // Method to create a copy of the object with modified fields
  FoodItem copyWith({
    String? id,
    String? name,
    double? price,
  }) {
    return FoodItem(
      id: id ?? this.id, // If no new value is provided, retain the current value
      name: name ?? this.name,
      price: price ?? this.price,
    );
  }

  // Convert the object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }

  // You can also add a fromMap method if needed
  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
    );
  }
}
