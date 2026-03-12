import 'package:flutter/material.dart';
import '../../models/product.dart';
import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final ValueChanged<Product>? onProductTap;
  final ValueChanged<Product>? onAddToCart;

  const ProductGrid({
    super.key,
    required this.products,
    this.onProductTap,
    this.onAddToCart,
  });

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
                padding: const EdgeInsets.all(12), // memberi jarak 12 pixel
                itemCount: products.length, // jumlah produk
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( // mengatur jumlah kolom
                  crossAxisCount: column,
                  crossAxisSpacing: 12, // memberi jarak antar kolom 12 pixel kebawah
                  mainAxisSpacing: 12, // memberi jarak antar baris 12 pixel ke kanan
                  childAspectRatio: 0.7, // mengatur rasio lebar dan tinggi
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(
                    product: product,
                    onTap: onProductTap == null ? null : () => onProductTap!(product), 
                    onAddToCart: onAddToCart == null ? null : () => onAddToCart!(product),
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
