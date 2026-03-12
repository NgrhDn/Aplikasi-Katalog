import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/cart_item.dart';
import 'cart_event.dart';
import 'cart_state.dart';

// BLoC logika keranjang
class CartBloc extends Bloc<CartEvent, CartState> {
  // Mendaftarkan semua event keranjang
  CartBloc() : super(const CartState()) {
    on<AddToCartEvent>(onAddToCart);
    on<RemoveFromCartEvent>(onRemoveFromCart);
    on<ClearCartEvent>(onClearCart);
  }

  // Menambahkan produk ke keranjang
  void onAddToCart(AddToCartEvent event, Emitter<CartState> emit) {
    // Salin item agar perubahan tidak mengubah state lama
    final cartItems = List<CartItem>.from(state.items);
    final itemIndex = cartItems.indexWhere(
      (item) => item.product.id == event.product.id,
    );

    // Jika produk belum ada, tambah sebagai item baru.
    if (itemIndex == -1) {
      cartItems.add(CartItem(product: event.product, quantity: 1));
    } else {
      // Jika sudah ada, naikkan jumlahnya 1.
      final currentItem = cartItems[itemIndex];
      final newQuantity = currentItem.quantity + 1;
      cartItems[itemIndex] = currentItem.copyWith(quantity: newQuantity);
    }

    // Kirim state terbaru ke UI.
    emit(state.copyWith(items: cartItems));
  }

  // Mengurangi jumlah item, atau menghapus jika jumlahnya tinggal 1.
  void onRemoveFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) {
    final cartItems = List<CartItem>.from(state.items);
    final itemIndex = cartItems.indexWhere(
      (item) => item.product.id == event.productId,
    );

    // Jika item tidak ditemukan, tidak ada perubahan state.
    if (itemIndex == -1) {
      return;
    }

    final currentItem = cartItems[itemIndex];

    // Jika sisa 1, item dihapus dari keranjang.
    if (currentItem.quantity == 1) {
      cartItems.removeAt(itemIndex);
    } else {
      // Jika lebih dari 1, kurangi jumlahnya.
      final newQuantity = currentItem.quantity - 1;
      cartItems[itemIndex] = currentItem.copyWith(quantity: newQuantity);
    }

    emit(state.copyWith(items: cartItems));
  }

  // Mengosongkan seluruh isi keranjang.
  void onClearCart(ClearCartEvent event, Emitter<CartState> emit) {
    emit(const CartState(items: []));
  }
}
