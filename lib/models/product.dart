import 'package:intl/intl.dart';

class Product {
  // final memastikan nilai hanya bisa di isi sekali dan tidak bisa diubah setelah objek dibuat
  final String id;
  final String namaProduct;
  final String fotoUrl;
  final String deskripsi;
  final int harga;

  const Product({
    // required berfungsi  nilai harus diisi dah this memastikan tujuan nilai
    required this.id,
    required this.namaProduct,
    required this.fotoUrl,
    required this.harga,
    this.deskripsi = '',
  });

// method mengambil deskripsi, jika tidak ada menampilkan default
  String getDeskripsi() =>
      deskripsi.isEmpty ? 'Deskripsi belum tersedia' : deskripsi;

  String getHargaRupiah() {
    final format = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return format.format(harga);
  }
}
