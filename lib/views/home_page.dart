import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/product.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/app_bottom_navigation.dart';
import '../widgets/product_grid.dart';
import '../widgets/product_search_bar.dart';
import '../controllers/home_controller.dart';
import '../blocs/product_bloc.dart';
import '../blocs/product_event.dart';
import '../blocs/product_state.dart';
import 'add_product_simple_page.dart';
import 'edit_product_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final HomeController homeController = HomeController();
  late final ProductBloc productBloc;

  @override
  void initState() {
    super.initState();
    productBloc = ProductBloc()
      ..add(InitializeProductsEvent(homeController.products));
  }

  @override
  void dispose() {
    productBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: productBloc,
      child: Scaffold(
        appBar: AppTopBar(
          title: homeController.currentTabIndex == 0 ? 'Produk' : 'Akun',
        ),
        body: homeController.currentTabIndex == 0
            ? buildProductTab(context)
            : buildEmptyTab(),
        floatingActionButton: homeController.currentTabIndex == 0
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddProductSimplePage(bloc: productBloc),
                    ),
                  );
                },
                child: const Icon(Icons.add),
              )
            : null,
        bottomNavigationBar: AppBottomNavigation(
          currentIndex: homeController.currentTabIndex,
          onChanged: (int index) {
            setState(() {
              homeController.changeTab(index);
            });
          },
        ),
      ),
    );
  }

  Widget buildProductTab(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state.status == ProductStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == ProductStatus.error) {
          final message = state.errorMessage.isEmpty
              ? 'Terjadi error'
              : state.errorMessage;
          return Center(child: Text(message));
        }

        return Column(
          children: [
            ProductSearchBar(
              products: state.products,
              onSearch: (String keyword) {
                productBloc.add(SearchProductsEvent(keyword));
              },
            ),
            Expanded(
              child: ProductGrid(
                products: state.filteredProducts,
                onProductTap: (Product product) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditProductPage(bloc: productBloc, product: product),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildEmptyTab() {
    return Center(
      child: Text(
        'Halaman Kosong',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }
}
