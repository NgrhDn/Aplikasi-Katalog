import 'package:flutter/material.dart';
import '../controllers/product_controller.dart';

class AddProductSimplePage extends StatefulWidget {
  final ProductController controller;

  const AddProductSimplePage({super.key, required this.controller});

  @override
  State<AddProductSimplePage> createState() => _AddProductSimplePageState();
}

class _AddProductSimplePageState extends State<AddProductSimplePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();
  bool isValid = false;

  void validate() {
    bool nameNotEmpty = nameController.text.isNotEmpty;
    bool imageNotEmpty = imageController.text.isNotEmpty;

    setState(() {
      isValid = nameNotEmpty && imageNotEmpty;
    });
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
              decoration: const InputDecoration(
                labelText: 'Nama Produk',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: imageController,
              onChanged: (String value) {
                validate();
              },
              decoration: const InputDecoration(
                labelText: 'URL Foto',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: deskripsiController,
              maxLines: 3,
              onChanged: (String value) {
                validate();
              },
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isValid
                    ? () {
                        widget.controller.addProduct(
                          namaProduct: nameController.text,
                          fotoUrl: imageController.text,
                          deskripsi: deskripsiController.text,
                        );
                        Navigator.pop(context, true);
                      }
                    : null,
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
}
