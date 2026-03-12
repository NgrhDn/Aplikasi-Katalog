import 'product.dart';

// Model satu baris item keranjang
class CartItem {
  // Data produk yang dimasukkan ke keranjang
  final Product product;
  // Jumlah produk yang dipesan
  final int quantity;

  // Nilai awal quantity adalah 1
  const CartItem({required this.product, this.quantity = 1});

  // Membuat salinan item
  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}
