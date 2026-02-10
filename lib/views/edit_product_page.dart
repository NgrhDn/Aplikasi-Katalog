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

  @override
  void initState() {
    super.initState();
    nameController.text = widget.product.namaProduct;
    imageController.text = widget.product.fotoUrl;
    deskripsiController.text = widget.product.deskripsi;
    validate();
  }

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
      appBar: AppBar(title: const Text('Edit Produk')),
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
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: isValid
                        ? () {
                            widget.bloc.add(
                              EditProductEvent(
                                id: widget.product.id,
                                namaProduct: nameController.text,
                                fotoUrl: imageController.text,
                                deskripsi: deskripsiController.text,
                              ),
                            );
                            Navigator.pop(context);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Simpan'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            title: const Text('Hapus Produk'),
                            content: const Text(
                              'Apakah Anda yakin ingin menghapus produk ini?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext);
                                },
                                child: const Text('Batal'),
                              ),
                              TextButton(
                                onPressed: () {
                                  widget.bloc.add(
                                    DeleteProductEvent(widget.product.id),
                                  );
                                  Navigator.pop(dialogContext);
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Hapus',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Hapus'),
                  ),
                ),
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
