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
    setStateData(emit, event.products);
  }

  void onSearchProducts(SearchProductsEvent event, Emitter<ProductState> emit) {
    setStateData(emit, state.products, keyword: event.keyword);
  }

  void onAddProduct(AddProductEvent event, Emitter<ProductState> emit) {
    if (event.namaProduct.trim().isEmpty) {
      setStateData(
        emit,
        state.products,
        status: ProductStatus.error,
        keyword: state.keyword,
        errorMessage: 'Nama produk tidak boleh kosong',
      );
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
    setStateData(emit, updatedProducts, keyword: state.keyword);
  }

  void onEditProduct(EditProductEvent event, Emitter<ProductState> emit) {
    if (event.namaProduct.trim().isEmpty) {
      setStateData(
        emit,
        state.products,
        status: ProductStatus.error,
        keyword: state.keyword,
        errorMessage: 'Nama produk tidak boleh kosong',
      );
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
    setStateData(emit, updatedProducts, keyword: state.keyword);
  }

  void onDeleteProduct(DeleteProductEvent event, Emitter<ProductState> emit) {
    if (event.id.trim().isEmpty) {
      setStateData(
        emit,
        state.products,
        status: ProductStatus.error,
        keyword: state.keyword,
        errorMessage: 'ID produk tidak valid',
      );
      return;
    }

    final updatedProducts = <Product>[];
    for (final product in state.products) {
      if (product.id != event.id) {
        updatedProducts.add(product);
      }
    }
    setStateData(emit, updatedProducts, keyword: state.keyword);
  }

  void setStateData(
    Emitter<ProductState> emit,
    List<Product> products, {
    ProductStatus status = ProductStatus.loaded,
    String keyword = '',
    String errorMessage = '',
  }) {
    emit(
      ProductState(
        status: status,
        products: products,
        filteredProducts: filterProducts(products, keyword),
        keyword: keyword,
        errorMessage: errorMessage,
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
