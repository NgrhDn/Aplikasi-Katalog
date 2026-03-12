import '../../models/product.dart';

// Status kemungkinan memuat data produk
enum ProductStatus { loading, loaded, error }

// Menyimpan kondisi data produk
class ProductState {
  final ProductStatus status;
  // Semua produk yang tersimpan
  final List<Product> products;
  final List<Product> filteredProducts;
  // Kata kunci pencarian
  final String keyword;
  // Pesan error
  final String errorMessage;

  // Nilai awal state BLoC
  const ProductState({
    this.status = ProductStatus.loading,
    this.products = const [],
    this.filteredProducts = const [],
    this.keyword = '',
    this.errorMessage = '',
  });

  // Membuat salinan state
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
