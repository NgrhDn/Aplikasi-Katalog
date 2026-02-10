import 'package:flutter/material.dart';
import '../models/product.dart';
import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final Function(Product)? onProductTap;

  const ProductGrid({super.key, required this.products, this.onProductTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            'Total ${products.length} produk',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, size) {
              int column = getColumnCount(size.maxWidth);

              return GridView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: column,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  Product product = products[index];
                  return ProductCard(
                    product: product,
                    onTap: onProductTap != null
                        ? () {
                            onProductTap!(product);
                          }
                        : null,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  int getColumnCount(double width) {
    int column = 2;
    if (width >= 600) {
      column = 3;
    }
    if (width >= 900) {
      column = 4;
    }
    return column;
  }
}
