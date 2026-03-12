import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/products_data.dart';
import '../models/product.dart';
import '../widgets/app/app_top_bar.dart';
import '../widgets/app/app_bottom_navigation.dart';
import '../widgets/notification/app_notification.dart';
import '../widgets/product/product_grid.dart';
import '../widgets/product/product_search_bar.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../blocs/cart/cart_state.dart';
import '../blocs/product/product_bloc.dart';
import '../blocs/product/product_event.dart';
import '../blocs/product/product_state.dart';
import 'add_product_simple_page.dart';
import 'cart_list_page.dart';
import 'account_page.dart';
import 'edit_product_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  // variabel untuk menyimpan tab aktif
  int currentTabIndex = 0;

  // BLoC data produk dan keranjang yang diisi nanti.
  late final ProductBloc productBloc;
  late final CartBloc cartBloc;

  @override
  void initState() {
    super.initState();

    //  membuat object dan mengirim event dan membuat produk awal.
    productBloc = ProductBloc();
    productBloc.add(InitializeProductsEvent(generateProducts()));

    // membuat cart kosong.
    cartBloc = CartBloc();
  }

  @override
  void dispose() {
    // Menutup BLoC agar stream tidak memakan memori.
    productBloc.close();
    cartBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // multibloc karena ada 2 bloc untuk seluruh isi halaman.
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: productBloc),

        BlocProvider.value(value: cartBloc),
      ],

      child: Builder(
        builder: (BuildContext context) {
          // Tab 0 menampilkan produk
          bool isProductTab = currentTabIndex == 0;

          return Scaffold(
            appBar: AppTopBar(
              title: isProductTab ? 'Produk' : 'Akun',
              actions: [
                BlocBuilder<CartBloc, CartState>(
                  builder: (BuildContext context, CartState cartState) {
                    return IconButton(
                      // bagian untuk membuka halaman daftar cart.
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return BlocProvider.value(
                                value: cartBloc,
                                child: const CartListPage(),
                              );
                            },
                          ),
                        );
                      },

                      icon: Badge(
                        label: Text('${cartState.totalItems}'),
                        // hide badge kalau item di cart kosong.
                        isLabelVisible: cartState.totalItems > 0,
                        child: const Icon(Icons.shopping_cart_outlined),
                      ),
                    );
                  },
                ),
              ],
            ),
            // Isi utama halaman tergantung tab yang aktif.
            body: isProductTab ? buildProductTab(context) : const EmptyPage(),
            // floating cuma muncul di tab  produk
            floatingActionButton: isProductTab
                ? FloatingActionButton(
                    // Membuka halaman tambah produk.
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return AddProductSimplePage(bloc: productBloc);
                          },
                        ),
                      );
                    },
                    child: const Icon(Icons.add),
                  )
                : null,
            // navigasi bawah produk dan akun.
            bottomNavigationBar: AppBottomNavigation(
              // tab mana yang aktif?
              currentIndex: currentTabIndex,
              onChanged: (int index) {
                setState(() { // data harus diupdate
                  currentTabIndex = index;
                });
              },
            ),
          );
        },
      ),
    );
  }

  // akan membuat halaman produk, search bar dan grid produk
  Widget buildProductTab(BuildContext context) {
    // loading memuai data, error menampilkan pesan
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (BuildContext context, ProductState state) {
        if (state.status == ProductStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == ProductStatus.error) {
          String message;
          if (state.errorMessage.isEmpty) {
            message = 'Terjadi error';
          } else {
            message = state.errorMessage;
          }
          return Center(child: Text(message));
        }
        return Column(// vertial atas bawah
          children: [
            ProductSearchBar(
              keyword: state.keyword,
              // Mengirim event pencarian saat keyword berubah.
              onSearch: (String keyword) {
                productBloc.add(SearchProductsEvent(keyword));
              },
            ),

            Expanded( // grid memenuhi sisa ruang
              child: ProductGrid(
                products: state.filteredProducts,
                // Membuka edit saat item produk dipilih.
                onProductTap: (Product product) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return EditProductPage(
                          bloc: productBloc,
                          product: product,
                        );
                      },
                    ),
                  );
                },
                // Menambahkan produk ke cart lalu menampilkan notifikasi.
                onAddToCart: (Product product) {
                  cartBloc.add(AddToCartEvent(product));
                  showAppNotification(
                    context,
                    '${product.namaProduct} ditambahkan ke cart',
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
