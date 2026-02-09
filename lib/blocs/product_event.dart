import '../models/product.dart';

abstract class ProductEvent {
  const ProductEvent();
}

class SearchProductsEvent extends ProductEvent {
  final String keyword;
  const SearchProductsEvent(this.keyword);
}

class AddProductEvent extends ProductEvent {
  final String namaProduct;
  final String fotoUrl;
  final String deskripsi;

  const AddProductEvent({
    required this.namaProduct,
    required this.fotoUrl,
    required this.deskripsi,
  });
}

class EditProductEvent extends ProductEvent {
  final String id;
  final String namaProduct;
  final String fotoUrl;
  final String deskripsi;

  const EditProductEvent({
    required this.id,
    required this.namaProduct,
    required this.fotoUrl,
    required this.deskripsi,
  });
}

class DeleteProductEvent extends ProductEvent {
  final String id;
  const DeleteProductEvent(this.id);
}

class InitializeProductsEvent extends ProductEvent {
  final List<Product> products;
  const InitializeProductsEvent(this.products);
}
