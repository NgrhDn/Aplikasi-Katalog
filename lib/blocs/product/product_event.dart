import '../../models/product.dart';

// Kelas dasar untuk semua produk
abstract class ProductEvent {
  const ProductEvent();
}

// Event mencari produk berdasarkan kata kunci
class SearchProductsEvent extends ProductEvent {
  // Kata kunci yang diketik pengguna disimpan di keyword
  final String keyword;
  const SearchProductsEvent(this.keyword);
}

// Event menambah produk baru.
class AddProductEvent extends ProductEvent {
  final String namaProduct;
  final String fotoUrl;
  final String deskripsi;
  final int harga;

  const AddProductEvent({
    required this.namaProduct,
    required this.fotoUrl,
    required this.deskripsi,
    required this.harga,
  });
}

// Event mengubah data produk
class EditProductEvent extends ProductEvent {
  // Id produk yang akan diubah
  final String id;
  final String namaProduct;
  final String fotoUrl;
  final String deskripsi;
  final int harga;

  const EditProductEvent({
    required this.id,
    required this.namaProduct,
    required this.fotoUrl,
    required this.deskripsi,
    required this.harga,
  });
}

// Event menghapus produk berdasarkan id
class DeleteProductEvent extends ProductEvent {
  final String id;
  const DeleteProductEvent(this.id);
}

// Event mengisi daftar produk pertama kali saat aplikasi dibuka
class InitializeProductsEvent extends ProductEvent {
  final List<Product> products;
  const InitializeProductsEvent(this.products);
}
