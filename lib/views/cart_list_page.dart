import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../blocs/cart/cart_state.dart';
import '../widgets/cart/cart_item_widget.dart';

// Halaman untuk menampilkan isi keranjang
class CartListPage extends StatelessWidget {
  const CartListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart List'),
        actions: [
          IconButton(
            // Tombol untuk mengosongkan semua isi
            onPressed: () {
              context.read<CartBloc>().add(const ClearCartEvent());
            },
            icon: const Icon(Icons.delete_sweep_outlined),
          ),
        ],
      ),
      // UI akan ikut berubah setiap state keranjang berubah
      body: BlocBuilder<CartBloc, CartState>(
        builder: (BuildContext context, CartState state) {
          if (state.isEmpty) {
            // Tampil jika belum ada produk
            return const Center(
              child: Text('Cart masih kosong'),
            );
          }

          return Column(
            children: [
              Expanded(
                // item yang ada di keranjang
                child: ListView.separated(
                  itemCount: state.items.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(height: 1);
                  },
                  itemBuilder: (BuildContext context, int index) {
                    final item = state.items[index];

                    return CartItemWidget(
                      item: item,
                      onRemoveOne: () {
                        // Kurangi 1 jumlah item di keranjang
                        context.read<CartBloc>().add( 
                          RemoveFromCartEvent(item.product.id), // event removefromcart
                        );
                      },
                      onAddOne: () {
                        // Tambah 1 jumlah item di keranjang
                        context.read<CartBloc>().add(
                          AddToCartEvent(item.product), //  event addtocart
                        );
                      },
                    );
                  },
                ),
              ),
              // membuat kotak
              Container(
                width: double.infinity,// membuat lebar penuh layar
                padding: const EdgeInsets.all(16), // memberi jarak dalam kotak 16 pixel
                color: Colors.black12,
                // jumlah item dan total harga
                child: Text(
                  'Total item: ${state.totalItems} | Total harga: Rp ${state.totalHarga}',
                  style: const TextStyle(fontWeight: FontWeight.bold), // membuat teks tebal
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
