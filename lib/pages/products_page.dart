import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/products.dart';
import '../services/product_service.dart';

/// صفحة عرض المنتجات
/// تقوم هذه الصفحة بعرض قائمة المنتجات من API في شكل شبكة
class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  /// مثيل من ProductService للتعامل مع طلبات API
  final ProductService _productService = ProductService();

  /// Future يحتوي على قائمة المنتجات
  /// يتم استخدامه مع FutureBuilder لعرض حالات التحميل المختلفة
  late Future<List<Products>> _productsFuture;

  @override
  void initState() {
    super.initState();
    // بدء تحميل المنتجات عند تهيئة الصفحة
    _productsFuture = _productService.getProducts();
  }

  /// دالة لتحديث قائمة المنتجات
  /// يتم استدعاؤها عند سحب الشاشة للأسفل للتحديث
  Future<void> _refreshProducts() async {
    setState(() {
      _productsFuture = _productService.getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المنتجات'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProducts,
        child: FutureBuilder<List<Products>>(
          future: _productsFuture,
          builder: (context, snapshot) {
            // عرض مؤشر التحميل أثناء جلب البيانات
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // عرض رسالة الخطأ في حالة وجود مشكلة
            if (snapshot.hasError) {
              return Center(child: Text('حدث خطأ: ${snapshot.error}'));
            }

            // عرض رسالة في حالة عدم وجود منتجات
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('لا توجد منتجات'));
            }

            final products = snapshot.data!;
            // عرض المنتجات في شكل شبكة
            return GridView.builder(
              padding: const EdgeInsets.all(8),
              // تكوين الشبكة: عمودين مع مسافات بينهما
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // عدد الأعمدة
                childAspectRatio: 0.7, // نسبة العرض إلى الارتفاع
                crossAxisSpacing: 10, // المسافة الأفقية بين العناصر
                mainAxisSpacing: 10, // المسافة الرأسية بين العناصر
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                // بطاقة المنتج
                return Card(
                  elevation: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // صورة المنتج
                      Expanded(
                        child: Image.memory(
                          base64Decode(product.productImage), // تحويل الصورة من Base64
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(child: Icon(Icons.error));
                          },
                        ),
                      ),
                      // تفاصيل المنتج
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // اسم المنتج
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            // سعر المنتج
                            Text(
                              '${product.price} ريال',
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // المخزون المتوفر
                            Text(
                              'المخزون: ${product.stock}',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
