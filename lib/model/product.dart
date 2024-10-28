class Product {
  final String id;
  final String name;
  final String brand;
  final String category;
  final String description;
  final String picture;
  final double price;
  final bool offer;
  int quantity; // Thêm thuộc tính số lượng

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.description,
    required this.picture,
    required this.price,
    required this.offer,
    this.quantity = 1, // Khởi tạo số lượng mặc định là 1
  });

  // Phương thức để chuyển từ Map Firebase sang đối tượng Product
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
      quantity: (data['quantity'] ?? 1), // Lấy số lượng từ dữ liệu Firebase
    );
  }

  // Phương thức để chuyển đổi đối tượng Product thành Map (để lưu vào Firebase)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'brand': brand,
      'category': category,
      'description': description,
      'picture': picture,
      'price': price,
      'offer': offer,
      'quantity': quantity, // Thêm số lượng vào Map
    };
  }
}
