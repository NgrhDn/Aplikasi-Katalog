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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Produk')),
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
            SizedBox(width: double.infinity, child: buildSaveButton()),
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
