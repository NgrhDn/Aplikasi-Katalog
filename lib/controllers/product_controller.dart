import '../models/product.dart';

class ProductController {
  final List<Product> allProducts;

  ProductController(this.allProducts);

  List<Product> getCurrentProducts() {
    return allProducts;
  }
}
