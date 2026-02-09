import '../models/product.dart';

class ProductState {
  final List<Product> products;
  final List<Product> filteredProducts;
  final String keyword;

  const ProductState({
    this.products = const [],
    this.filteredProducts = const [],
    this.keyword = '',
  });

  ProductState copyWith({
    List<Product>? products,
    List<Product>? filteredProducts,
    String? keyword,
  }) {
    return ProductState(
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      keyword: keyword ?? this.keyword,
    );
  }
}
