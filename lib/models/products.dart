import 'dart:convert';

class Products {
  final int id;
  final String name;
  final String price;
  final String stock;
  final String productImage;
  final String description;


  Products({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.productImage,
    required this.description,
   
  });

  factory Products.fromJson(Map<String, dynamic> jsonData) {
    return Products(
      id: jsonData['id'],
      name: jsonData['name'] ?? 'No title available',
      price: jsonData['price'].toString(),

      /// تأكد من تحويل `price` إلى `String` إذا كان من نوع `double`
      stock: jsonData['stock']
          .toString(), // تأكد من تحويل `stock` إلى `String` إذا كان من نوع `int`
      productImage: jsonData['productImage'] ?? 'No photo available',
      description: jsonData['description'] ?? 'No description available',
    
    );
  }
}
