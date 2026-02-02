class Product {
  String id;
  String namaProduct;
  String fotoUrl;
  String deskripsi;

  Product({
    required this.id,
    required this.namaProduct,
    required this.fotoUrl,
    this.deskripsi = '',
  });

  String getDeskripsi() {
    if (deskripsi.isEmpty) {
      return 'Deskripsi belum tersedia';
    }
    return deskripsi;
  }
}
