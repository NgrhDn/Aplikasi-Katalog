import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/product.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(const ProductState()) {
    on<InitializeProductsEvent>(_onInitializeProducts);
    on<SearchProductsEvent>(_onSearchProducts);
    on<AddProductEvent>(_onAddProduct);
    on<EditProductEvent>(_onEditProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
  }

  void _onInitializeProducts(
    InitializeProductsEvent event,
    Emitter<ProductState> emit,
  ) {
    _emitProducts(emit, event.products, keyword: '');
  }

  void _onSearchProducts(
    SearchProductsEvent event,
    Emitter<ProductState> emit,
  ) {
    _emitProducts(emit, state.products, keyword: event.keyword);
  }

  void _onAddProduct(AddProductEvent event, Emitter<ProductState> emit) {
    final newProduct = Product(
      id: _generateUniqueId(),
      namaProduct: event.namaProduct,
      fotoUrl: event.fotoUrl,
      deskripsi: event.deskripsi,
    );

    final updatedProducts = [...state.products, newProduct];
    _emitProducts(emit, updatedProducts);
  }

  void _onEditProduct(EditProductEvent event, Emitter<ProductState> emit) {
    final updatedProducts = state.products.map((product) {
      if (product.id == event.id) {
        return Product(
          id: product.id,
          namaProduct: event.namaProduct,
          fotoUrl: event.fotoUrl,
          deskripsi: event.deskripsi,
        );
      }
      return product;
    }).toList();
    _emitProducts(emit, updatedProducts);
  }

  void _onDeleteProduct(DeleteProductEvent event, Emitter<ProductState> emit) {
    final updatedProducts = state.products
        .where((product) => product.id != event.id)
        .toList();
    _emitProducts(emit, updatedProducts);
  }

  void _emitProducts(
    Emitter<ProductState> emit,
    List<Product> products, {
    String? keyword,
  }) {
    final activeKeyword = keyword ?? state.keyword;
    emit(
      state.copyWith(
        products: products,
        filteredProducts: _filterProducts(products, activeKeyword),
        keyword: activeKeyword,
      ),
    );
  }

  List<Product> _filterProducts(List<Product> products, String keyword) {
    if (keyword.isEmpty) {
      return List<Product>.from(products);
    }

    final keywordLower = keyword.toLowerCase();
    return products
        .where(
          (product) => product.namaProduct.toLowerCase().contains(keywordLower),
        )
        .toList();
  }

  String _generateUniqueId() {
    return 'PRD-${DateTime.now().millisecondsSinceEpoch}';
  }
}
