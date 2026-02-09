class Product {
  final String id;
  final String namaProduct;
  final String fotoUrl;
  final String deskripsi;

  const Product({
    required this.id,
    required this.namaProduct,
    required this.fotoUrl,
    this.deskripsi = '',
  });

  String getDeskripsi() =>
      deskripsi.isEmpty ? 'Deskripsi belum tersedia' : deskripsi;
}
