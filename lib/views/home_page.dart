import 'package:flutter/material.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/app_bottom_navigation.dart';
import '../widgets/product_grid.dart';
import '../models/product.dart';
import '../data/products_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Product> products = generateProducts();
  int currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Katalog Produk'),
      body: currentTabIndex == 0
          ? ProductGrid(products: products)
          : Center(
              child: Text(
                'Halaman Akun',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: currentTabIndex,
        onChanged: (index) {
          setState(() {
            currentTabIndex = index;
          });
        },
      ),
    );
  }
}
