import 'package:flutter/material.dart';
import '../blocs/product_bloc.dart';
import '../blocs/product_event.dart';
import '../models/product.dart';

class EditProductPage extends StatefulWidget {
  final ProductBloc bloc;
  final Product product;

  const EditProductPage({super.key, required this.bloc, required this.product});

  @override
  State<EditProductPage> createState() => EditProductPageState();
}

class EditProductPageState extends State<EditProductPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();
  bool isValid = false;
  bool showErrors = false;

  void showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    super.initState();
    nameController.text = widget.product.namaProduct;
    imageController.text = widget.product.fotoUrl;
    deskripsiController.text = widget.product.deskripsi;
    validate();
  }

  void validate() {
    bool nameNotEmpty = nameController.text.trim().isNotEmpty;
    bool imageNotEmpty = imageController.text.trim().isNotEmpty;
    bool deskripsiNotEmpty = deskripsiController.text.trim().isNotEmpty;

    setState(() {
      isValid = nameNotEmpty && imageNotEmpty && deskripsiNotEmpty;
    });
  }

  void submit() {
    validate();
    if (!isValid) {
      setState(() {
        showErrors = true;
      });
      showMessage('Lengkapi semua data dulu');
      return;
    }

    widget.bloc.add(
      EditProductEvent(
        id: widget.product.id,
        namaProduct: nameController.text,
        fotoUrl: imageController.text,
        deskripsi: deskripsiController.text,
      ),
    );
    showMessage('Produk berhasil disimpan');
    Navigator.pop(context);
  }

  void showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Produk'),
          content: const Text('Apakah Anda yakin ingin menghapus produk ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                widget.bloc.add(DeleteProductEvent(widget.product.id));
                showMessage('Produk berhasil dihapus');
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

  Widget buildInputField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      onChanged: (String value) {
        validate();
      },
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        errorText: showErrors && controller.text.trim().isEmpty
            ? 'Wajib diisi'
            : null,
      ),
    );
  }

  Widget buildSaveButton() {
    return ElevatedButton(
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
        child: Column(
          children: [
            buildInputField(nameController, 'Nama Produk'),
            const SizedBox(height: 16),
            buildInputField(imageController, 'URL Foto'),
            const SizedBox(height: 16),
            buildInputField(deskripsiController, 'Deskripsi', maxLines: 3),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: buildSaveButton()),
                const SizedBox(width: 8),
                Expanded(child: buildDeleteButton()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    imageController.dispose();
    deskripsiController.dispose();
    super.dispose();
  }
}
