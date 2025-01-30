import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/products.dart';

class ProductService {
  static const String baseUrl = 'http://10.0.2.2:5192/api'; // Replace with your actual API URL

  Future<List<Products>> getProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/Products'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Products.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}
