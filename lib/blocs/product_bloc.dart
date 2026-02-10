import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/product.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(const ProductState(status: ProductStatus.loading)) {
    on<InitializeProductsEvent>(onInitializeProducts);
    on<SearchProductsEvent>(onSearchProducts);
    on<AddProductEvent>(onAddProduct);
    on<EditProductEvent>(onEditProduct);
    on<DeleteProductEvent>(onDeleteProduct);
  }

  void onInitializeProducts(
    InitializeProductsEvent event,
    Emitter<ProductState> emit,
  ) {
    setProducts(
      emit,
      event.products,
      keyword: '',
      status: ProductStatus.loaded,
    );
  }

  void onSearchProducts(SearchProductsEvent event, Emitter<ProductState> emit) {
    setProducts(emit, state.products, keyword: event.keyword);
  }

  void onAddProduct(AddProductEvent event, Emitter<ProductState> emit) {
    if (event.namaProduct.trim().isEmpty) {
      setError(emit, 'Nama produk tidak boleh kosong');
      return;
    }

    final newProduct = Product(
      id: generateUniqueId(),
      namaProduct: event.namaProduct,
      fotoUrl: event.fotoUrl,
      deskripsi: event.deskripsi,
    );

    final updatedProducts = List<Product>.from(state.products);
    updatedProducts.add(newProduct);
    setProducts(emit, updatedProducts);
  }

  void onEditProduct(EditProductEvent event, Emitter<ProductState> emit) {
    if (event.namaProduct.trim().isEmpty) {
      setError(emit, 'Nama produk tidak boleh kosong');
      return;
    }

    final updatedProducts = <Product>[];
    for (final product in state.products) {
      if (product.id == event.id) {
        updatedProducts.add(
          Product(
            id: product.id,
            namaProduct: event.namaProduct,
            fotoUrl: event.fotoUrl,
            deskripsi: event.deskripsi,
          ),
        );
      } else {
        updatedProducts.add(product);
      }
    }
    setProducts(emit, updatedProducts);
  }

  void onDeleteProduct(DeleteProductEvent event, Emitter<ProductState> emit) {
    if (event.id.trim().isEmpty) {
      setError(emit, 'ID produk tidak valid');
      return;
    }

    final updatedProducts = <Product>[];
    for (final product in state.products) {
      if (product.id != event.id) {
        updatedProducts.add(product);
      }
    }
    setProducts(emit, updatedProducts);
  }

  void setProducts(
    Emitter<ProductState> emit,
    List<Product> products, {
    String? keyword,
    ProductStatus status = ProductStatus.loaded,
  }) {
    final activeKeyword = keyword ?? state.keyword;
    emit(
      ProductState(
        status: status,
        products: products,
        filteredProducts: filterProducts(products, activeKeyword),
        keyword: activeKeyword,
        errorMessage: '',
      ),
    );
  }

  void setError(Emitter<ProductState> emit, String message) {
    emit(
      ProductState(
        status: ProductStatus.error,
        products: state.products,
        filteredProducts: state.filteredProducts,
        keyword: state.keyword,
        errorMessage: message,
      ),
    );
  }

  List<Product> filterProducts(List<Product> products, String keyword) {
    if (keyword.isEmpty) {
      return List<Product>.from(products);
    }

    final keywordLower = keyword.toLowerCase();
    final results = <Product>[];
    for (final product in products) {
      final nameLower = product.namaProduct.toLowerCase();
      if (nameLower.contains(keywordLower)) {
        results.add(product);
      }
    }
    return results;
  }

  String generateUniqueId() {
    return 'PRD-${DateTime.now().millisecondsSinceEpoch}';
  }
}
