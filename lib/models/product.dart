import 'package:intl/intl.dart';

class Product {
  final int id;
  final String namaProduct;
  final String fotoUrl;

  const Product({
    required this.id,
    required this.namaProduct,
    required this.fotoUrl,
  });

  int get harga => 15000 + (id - 1) * 2500;
  String get hargaText {
    final formatter = NumberFormat.decimalPattern('id');
    return 'Rp ${formatter.format(harga)}';
  }
}
