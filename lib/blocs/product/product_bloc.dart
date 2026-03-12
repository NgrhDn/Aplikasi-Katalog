import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/product.dart';
import 'product_event.dart';
import 'product_state.dart';

// BLoC logika data produk
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  // daftarkan event produk ke penanganannya
  ProductBloc() : super(const ProductState(status: ProductStatus.loading)) {
    on<InitializeProductsEvent>(onInitializeProducts);
    on<SearchProductsEvent>(onSearchProducts);
    on<AddProductEvent>(onAddProduct);
    on<EditProductEvent>(onEditProduct);
    on<DeleteProductEvent>(onDeleteProduct);
  }
   // isi data awal dan mengubah status
  void onInitializeProducts(
    InitializeProductsEvent event,
    Emitter<ProductState> emit,
  ) {
    // Isi state awal data produk pertama
    emit(
      state.copyWith(
        status: ProductStatus.loaded,
        products: event.products,
        filteredProducts: List<Product>.from(event.products),
        // Reset pencarian dan pesan error
        keyword: '',
        errorMessage: '',
      ),
    );
  }

  void onSearchProducts(SearchProductsEvent event, Emitter<ProductState> emit) {
    // Update daftar tampil sesuai kata kunci pencarian
    emit(
      state.copyWith(
        status: ProductStatus.loaded,
        filteredProducts: filterProducts(state.products, event.keyword),
        keyword: event.keyword,
        errorMessage: '',
      ),
    );
  }

  void onAddProduct(AddProductEvent event, Emitter<ProductState> emit) {
    // Validasi nama tidak boleh kosong
    if (event.namaProduct.trim().isEmpty) { //menghapus spasi awal dan akhir dan cek kosong
      emit(
        state.copyWith(
          status: ProductStatus.error,
          errorMessage: 'Nama produk tidak boleh kosong',
        ),
      );
      return;
    }

    // Buat objek produk baru dari input pengguna
    final newProduct = Product(
      id: generateUniqueId(),
      namaProduct: event.namaProduct,
      fotoUrl: event.fotoUrl,
      deskripsi: event.deskripsi,
      harga: event.harga,
    );

    // Tambahkan lalu perbarui hasil filter saat ini
    final updatedProducts = List<Product>.from(state.products);
    updatedProducts.add(newProduct);
    emit(
      state.copyWith(
        status: ProductStatus.loaded,
        products: updatedProducts,
        filteredProducts: filterProducts(updatedProducts, state.keyword),
        errorMessage: '',
      ),
    );
  }

  void onEditProduct(EditProductEvent event, Emitter<ProductState> emit) {
    // Validasi edit nama tidak boleh kosong.
    if (event.namaProduct.trim().isEmpty) {
      emit(
        state.copyWith(
          status: ProductStatus.error,
          errorMessage: 'Nama produk tidak boleh kosong',
        ),
      );
      return;
    }

    // Ganti data produk yang id-nya sama, sisanya tetap
    final updatedProducts = <Product>[];
    for (final product in state.products) {
      if (product.id == event.id) {
        updatedProducts.add(
          Product(
            id: product.id,
            namaProduct: event.namaProduct,
            fotoUrl: event.fotoUrl,
            deskripsi: event.deskripsi,
            harga: event.harga,
          ),
        );
      } else {
        updatedProducts.add(product);
      }
    }
    emit(
      state.copyWith(
        status: ProductStatus.loaded,
        products: updatedProducts,
        filteredProducts: filterProducts(updatedProducts, state.keyword),
        errorMessage: '',
      ),
    );
  }

  void onDeleteProduct(DeleteProductEvent event, Emitter<ProductState> emit) {
    // Hapus produk berdasarkan id.
    final updatedProducts = <Product>[];
    for (final product in state.products) {
      if (product.id != event.id) {
        updatedProducts.add(product);
      }
    }
    emit(
      state.copyWith(
        status: ProductStatus.loaded,
        products: updatedProducts,
        filteredProducts: filterProducts(updatedProducts, state.keyword),
        errorMessage: '',
      ),
    );
  }

  // Menyaring produk berdasarkan nama dan kata kunci.
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

  // Membuat id unik dari waktu saat ini
  String generateUniqueId() {
    return 'PRD-${DateTime.now().millisecondsSinceEpoch}';
  }
}
