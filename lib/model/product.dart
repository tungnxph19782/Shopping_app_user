class Product {
  final String id;
  final String name;
  final String brand;
  final String category;
  final String description;
  final String picture;
  final double price;
  final bool offer;
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.description,
    required this.picture,
    required this.price,
    required this.offer,
    this.quantity = 1,
  });

  factory Product.fromMap(Map<String, dynamic> data, String documentId) {
    return Product(
      id: documentId,
      name: data['name'] ?? '',
      brand: data['brand'] ?? '',
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      picture: data['picture'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      offer: data['offer'] ?? false,
      quantity: (data['quantity'] ?? 1),
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'brand': brand,
      'category': category,
      'description': description,
      'picture': picture,
      'price': price,
      'offer': offer,
      'quantity': quantity,
    };
  }
}
