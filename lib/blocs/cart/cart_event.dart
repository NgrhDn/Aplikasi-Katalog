import '../../models/product.dart';

// Kelas dasar untuk semua aksi
abstract class CartEvent {
  const CartEvent();
}

// menambahkan produk
class AddToCartEvent extends CartEvent {
  // Produk yang akan ditambahkan
  final Product product;

  const AddToCartEvent(this.product);
}

// menghapus produk dari keranjang
class RemoveFromCartEvent extends CartEvent {
  // Id produk yang dihapus
  final String productId;

  const RemoveFromCartEvent(this.productId);
}

// mengosongkan seluruh isi
class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}
