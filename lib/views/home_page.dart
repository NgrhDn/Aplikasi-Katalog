import 'package:flutter/material.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/app_bottom_navigation.dart';
import '../widgets/product_grid.dart';
import '../widgets/product_search_bar.dart';
import '../models/product.dart';
import '../data/products_data.dart';
import '../controllers/home_controller.dart';
import '../controllers/product_controller.dart';
import 'add_product_simple_page.dart';
import 'edit_product_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController homeController = HomeController();
  late final ProductController productController;

  @override
  void initState() {
    super.initState();
    productController = ProductController(homeController.products);
  }

  @override
  Widget build(BuildContext context) {
    bool isProductTab = homeController.currentTabIndex == 0;
    return Scaffold(
      appBar: AppTopBar(title: isProductTab ? 'Produk' : 'Akun'),

      body: isProductTab
          ? Column(
              children: [
                ProductSearchBar(
                  products: homeController.products,
                  onSearch: (String keyword) {
                    setState(() {
                      productController.searchProducts(keyword);
                    });
                  },
                ),
                Expanded(
                  child: ProductGrid(
                    products: productController.getCurrentProducts(),
                    controller: productController,
                    onProductTap: (Product product) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return EditProductPage(
                              controller: productController,
                              product: product,
                            );
                          },
                        ),
                      ).then((result) {
                        if (result == true) {
                          setState(() {});
                        }
                      });
                    },
                  ),
                ),
              ],
            )
          : Center(
              child: Text(
                'Halaman Kosong',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),

      floatingActionButton: isProductTab
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return AddProductSimplePage(
                        controller: productController,
                      );
                    },
                  ),
                ).then((result) {
                  if (result == true) {
                    setState(() {});
                  }
                });
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
    );
  }
}
