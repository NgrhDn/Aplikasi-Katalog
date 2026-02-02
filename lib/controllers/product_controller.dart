import '../models/product.dart';

class ProductController {
  final List<Product> allProducts;
  List<Product> filteredProducts = [];

  ProductController(this.allProducts) {
    filteredProducts = List.from(allProducts);
  }

  List<Product> getCurrentProducts() {
    return filteredProducts;
  }

  void searchProducts(String keyword) {
    if (keyword.isEmpty) {
      filteredProducts = List.from(allProducts);
      return;
    }

    List<Product> results = [];
    String keywordLower = keyword.toLowerCase();

    for (int i = 0; i < allProducts.length; i++) {
      Product product = allProducts[i];
      String productNameLower = product.namaProduct.toLowerCase();

      if (productNameLower.contains(keywordLower)) {
        results.add(product);
      }
    }

    filteredProducts = results;
  }

  String generateUniqueId() {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'PRD-$timestamp';
  }

  void addProduct({
    required String namaProduct,
    required String fotoUrl,
    required String deskripsi,
  }) {
    String newId = generateUniqueId();
    Product newProduct = Product(
      id: newId,
      namaProduct: namaProduct,
      fotoUrl: fotoUrl,
      deskripsi: deskripsi,
    );
    allProducts.add(newProduct);
    filteredProducts = List.from(allProducts);
  }

  void editProduct({
    required String id,
    required String namaProduct,
    required String fotoUrl,
    required String deskripsi,
  }) {
    for (int i = 0; i < allProducts.length; i++) {
      if (allProducts[i].id == id) {
        allProducts[i].namaProduct = namaProduct;
        allProducts[i].fotoUrl = fotoUrl;
        allProducts[i].deskripsi = deskripsi;
        break;
      }
    }
    filteredProducts = List.from(allProducts);
  }

  void deleteProduct(String id) {
    allProducts.removeWhere((product) => product.id == id);
    filteredProducts = List.from(allProducts);
  }

  Product? getProductById(String id) {
    for (int i = 0; i < allProducts.length; i++) {
      if (allProducts[i].id == id) {
        return allProducts[i];
      }
    }
    return null;
  }
}
