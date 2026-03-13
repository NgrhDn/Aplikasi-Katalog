import 'package:flutter/material.dart';
import '../blocs/product/product_bloc.dart';
import '../blocs/product/product_event.dart';
import '../widgets/notification/app_notification.dart';

class AddProductSimplePage extends StatefulWidget {
  final ProductBloc bloc;

  const AddProductSimplePage({super.key, required this.bloc});

  @override
  State<AddProductSimplePage> createState() => AddProductSimplePageState();
}

class AddProductSimplePageState extends State<AddProductSimplePage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();

  void submit() {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) {
      showAppNotification(context, 'Lengkapi semua data dulu');
      return;
    }

    final harga = int.tryParse(hargaController.text.trim()) ?? 0;

    widget.bloc.add(
      AddProductEvent(
        namaProduct: nameController.text.trim(),
        fotoUrl: imageController.text.trim(),
        deskripsi: deskripsiController.text.trim(),
        harga: harga,
      ),
    );
    showAppNotification(context, 'Produk berhasil disimpan');
    Navigator.pop(context);
  }

  Widget buildInputField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildInputField(
                controller: nameController,
                label: 'Nama Produk',
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
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    imageController.dispose();
    deskripsiController.dispose();
    hargaController.dispose();
    super.dispose();
  }
}
