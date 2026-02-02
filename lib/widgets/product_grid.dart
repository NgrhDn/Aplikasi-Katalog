import 'package:flutter/material.dart';
import '../models/product.dart';
import '../controllers/product_controller.dart';
import 'product_card.dart';

class ProductGrid extends StatefulWidget {
  final List<Product> products;

  const ProductGrid({super.key, required this.products});

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  late ProductController controller;

  @override
  void initState() {
    super.initState();
    controller = ProductController(widget.products);
  }

  @override
  Widget build(BuildContext context) {
    List<Product> currentProducts = controller.getCurrentProducts();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            'Total ${currentProducts.length} produk',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, size) {
              int column = 2;
              if (size.maxWidth >= 600) column = 3;
              if (size.maxWidth >= 900) column = 4;

              return GridView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: currentProducts.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: column,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  return ProductCard(product: currentProducts[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
