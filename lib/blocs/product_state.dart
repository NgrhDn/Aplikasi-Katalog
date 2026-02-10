import '../models/product.dart';

enum ProductStatus { loading, loaded, error }

class ProductState {
  final ProductStatus status;
  final List<Product> products;
  final List<Product> filteredProducts;
  final String keyword;
  final String errorMessage;

  const ProductState({
    this.status = ProductStatus.loading,
    this.products = const [],
    this.filteredProducts = const [],
    this.keyword = '',
    this.errorMessage = '',
  });

  ProductState copyWith({
    ProductStatus? status,
    List<Product>? products,
    List<Product>? filteredProducts,
    String? keyword,
    String? errorMessage,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      keyword: keyword ?? this.keyword,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
