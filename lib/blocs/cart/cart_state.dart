import '../../models/cart_item.dart';

class CartState {
  // Daftar item
  final List<CartItem> items;

  // default keranjang kosong
  const CartState({this.items = const []});

  // tandai keranjang belum berisi
  bool get isEmpty {
    return items.isEmpty;
  }

  // hitung jumlah barang di keranjang
  int get totalItems {
    int total = 0;
    for (final item in items) {
      total += item.quantity;
    }
    return total;
  }

  // hitung total harga dari semua item di keranjang.
  int get totalHarga {
    int total = 0;
    for (final item in items) {
      total += item.product.harga * item.quantity;
    }
    return total;
  }

  // Membuat salinan state dengan nilai baru
  CartState copyWith({List<CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }
}
