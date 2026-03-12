import 'package:flutter/material.dart';
import '../../models/cart_item.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final VoidCallback onAddOne;
  final VoidCallback onRemoveOne;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.onAddOne,
    required this.onRemoveOne,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(item.product.fotoUrl),
      ),
      title: Text(item.product.namaProduct),
      subtitle: Text(
        'Qty: ${item.quantity} • Subtotal: Rp ${item.product.harga * item.quantity}',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onRemoveOne,
            icon: const Icon(Icons.remove_circle_outline),
          ),
          IconButton(
            onPressed: onAddOne,
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
    );
  }
}
