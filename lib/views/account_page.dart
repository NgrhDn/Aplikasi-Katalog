import 'package:flutter/material.dart';

class EmptyPage extends StatelessWidget {
  const EmptyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Halaman Kosong',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }
}
