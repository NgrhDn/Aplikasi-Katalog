import 'package:flutter/material.dart';
import '../blocs/product/product_bloc.dart';
import '../blocs/product/product_event.dart';
import '../models/product.dart';
import '../widgets/notification/app_notification.dart';

class EditProductPage extends StatefulWidget { // data bisa diubah
  // menerima data BLoC dari halaman sebelumnya.
  final ProductBloc bloc;
  final Product product;
// konstruktor menerima data
  const EditProductPage({super.key, required this.bloc, required this.product});

@override
State<EditProductPage> createState() {
  return EditProductPageState();
}
}

class EditProductPageState extends State<EditProductPage> {
  // Kunci untuk memeriksa valid atau tidaknya isian formulir.
  final formKey = GlobalKey<FormState>();
  // Penampung teks untuk setiap kolom isian.
  final TextEditingController nameController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Mengisi nilai awal formulir dari data produk yang sedang diedit.
    nameController.text = widget.product.namaProduct;
    imageController.text = widget.product.fotoUrl;
    deskripsiController.text = widget.product.deskripsi;
    hargaController.text = widget.product.harga.toString();
  }

  void submit() {
    // Simpan hanya jika semua isian sudah benar.
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) {
      showAppNotification(context, 'Lengkapi semua data dulu');
      return;
    }

    // Ubah harga dari teks ke angka, default 0 jika gagal dibaca.
    final harga = int.tryParse(hargaController.text.trim()) ?? 0;

    // Kirim perubahan produk ke BLoC.
    widget.bloc.add(
      EditProductEvent(
        id: widget.product.id,
        namaProduct: nameController.text.trim(),
        fotoUrl: imageController.text.trim(),
        deskripsi: deskripsiController.text.trim(),
        harga: harga,
      ),
    );
    // Tampilkan notifikasi lalu kembali ke halaman sebelumnya.
    showAppNotification(context, 'Produk berhasil disimpan');
    Navigator.pop(context);
  }

  void showDeleteDialog() {
    // Tampilkan konfirmasi agar tidak salah hapus produk.
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Produk'),
          content: const Text('Apakah Anda yakin ingin menghapus produk ini?'),
          actions: [
            TextButton(
              onPressed: () {
                // Tutup dialog tanpa menghapus data.
                Navigator.pop(dialogContext);
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                // Hapus produk, tutup dialog, lalu keluar dari halaman edit.
                widget.bloc.add(DeleteProductEvent(widget.product.id));
                showAppNotification(context, 'Produk berhasil dihapus');
                Navigator.pop(dialogContext);
                Navigator.pop(context);
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget buildInputField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    // Membuat kolom isian dengan tampilan yang sama.
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget buildSaveButton() {
    return ElevatedButton(
      // Tombol untuk menyimpan perubahan produk.
      onPressed: submit,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      child: const Text('Simpan'),
    );
  }

  Widget buildDeleteButton() {
    return ElevatedButton(
      // Tombol untuk menampilkan konfirmasi hapus.
      onPressed: showDeleteDialog,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      child: const Text('Hapus'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Produk')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          // Formulir berisi isian data produk serta aksi simpan dan hapus.
          child: Column(
            children: [
              buildInputField(
                controller: nameController,
                label: 'Nama Produk',
                // Nama produk wajib diisi.
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              buildInputField(
                controller: imageController,
                label: 'URL Foto',
                // Alamat foto wajib diisi.
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              buildInputField(
                controller: hargaController,
                label: 'Harga',
                keyboardType: TextInputType.number,
                // Harga harus angka dan lebih dari 0.
                validator: (value) {
                  final harga = int.tryParse(value?.trim() ?? '');
                  if (harga == null || harga <= 0) {
                    return 'Masukkan harga valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              buildInputField(
                controller: deskripsiController,
                label: 'Deskripsi',
                maxLines: 3,
                // Deskripsi wajib diisi.
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Row(
                // Dua aksi utama: simpan perubahan atau hapus produk.
                children: [
                  Expanded(child: buildSaveButton()),
                  const SizedBox(width: 8),
                  Expanded(child: buildDeleteButton()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Bersihkan penampung teks saat halaman ditutup.
    nameController.dispose();
    imageController.dispose();
    deskripsiController.dispose();
    hargaController.dispose();
    super.dispose();
  }
}
