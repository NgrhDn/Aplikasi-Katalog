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
}
