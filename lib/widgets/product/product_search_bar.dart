import 'package:flutter/material.dart';

class ProductSearchBar extends StatefulWidget {
  final String keyword;
  final Function(String) onSearch;

  const ProductSearchBar({
    super.key,
    required this.keyword,
    required this.onSearch,
  });

  @override
  State<ProductSearchBar> createState() => ProductSearchBarState();
}

class ProductSearchBarState extends State<ProductSearchBar> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.keyword);
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        controller: controller,
        onChanged: widget.onSearch,
        decoration: const InputDecoration(
          hintText: 'Cari produk...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
