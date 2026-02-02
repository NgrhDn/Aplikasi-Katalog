import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductSearchBar extends StatelessWidget {
  final List<Product> products;
  final Function(String) onSearch;

  const ProductSearchBar({
    super.key,
    required this.products,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    SearchController searchController = SearchController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SearchAnchor(
        searchController: searchController,
        builder: (BuildContext context, SearchController controller) {
          return SearchBar(
            controller: controller,
            padding: const WidgetStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 16.0),
            ),
            onTap: () {
              controller.openView();
            },
            onChanged: (String value) {
              controller.openView();
            },
            hintText: 'Cari produk...',
          );
        },
        suggestionsBuilder:
            (BuildContext context, SearchController controller) {
              String keyword = controller.text;

              if (keyword.isEmpty) {
                return [];
              }

              List<Widget> suggestions = [];
              String keywordLower = keyword.toLowerCase();

              for (int i = 0; i < products.length; i++) {
                Product product = products[i];
                String productNameLower = product.namaProduct.toLowerCase();

                if (productNameLower.contains(keywordLower)) {
                  ListTile tile = ListTile(
                    leading: const Icon(Icons.shopping_bag),
                    title: Text(product.namaProduct),
                    subtitle: Text(product.getDeskripsi()),
                    onTap: () {
                      controller.closeView(product.namaProduct);
                      onSearch(product.namaProduct);
                    },
                  );
                  suggestions.add(tile);
                }
              }

              if (suggestions.isEmpty) {
                Widget noResult = ListTile(
                  title: Text('Tidak ada hasil untuk "$keyword"'),
                );
                suggestions.add(noResult);
              }

              return suggestions;
            },
      ),
    );
  }
}
