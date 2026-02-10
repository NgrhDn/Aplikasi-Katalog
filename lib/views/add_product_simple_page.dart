import 'package:flutter/material.dart';
import '../blocs/product_bloc.dart';
import '../blocs/product_event.dart';

class AddProductSimplePage extends StatefulWidget {
  final ProductBloc bloc;

  const AddProductSimplePage({super.key, required this.bloc});

  @override
  State<AddProductSimplePage> createState() => AddProductSimplePageState();
}

class AddProductSimplePageState extends State<AddProductSimplePage> {
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
      AddProductEvent(
        namaProduct: nameController.text,
        fotoUrl: imageController.text,
        deskripsi: deskripsiController.text,
      ),
    );
    showMessage('Produk berhasil disimpan');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Produk')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              onChanged: (String value) {
                validate();
              },
              decoration: InputDecoration(
                labelText: 'Nama Produk',
                border: OutlineInputBorder(),
                errorText: showErrors && nameController.text.trim().isEmpty
                    ? 'Wajib diisi'
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: imageController,
              onChanged: (String value) {
                validate();
              },
              decoration: InputDecoration(
                labelText: 'URL Foto',
                border: OutlineInputBorder(),
                errorText: showErrors && imageController.text.trim().isEmpty
                    ? 'Wajib diisi'
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: deskripsiController,
              maxLines: 3,
              onChanged: (String value) {
                validate();
              },
              decoration: InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
                errorText: showErrors && deskripsiController.text.trim().isEmpty
                    ? 'Wajib diisi'
                    : null,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Simpan'),
              ),
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
