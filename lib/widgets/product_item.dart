import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  ProductItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          leading: Consumer<Product>(
            builder: (ctx, value, _) {
              return IconButton(
                color: Theme.of(context).colorScheme.secondary,
                icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_outline,
                ),
                onPressed: product.toggleFavoriteStatus,
              );
            },
          ),
          trailing: IconButton(
            color: Theme.of(context).colorScheme.secondary,
            icon: const Icon(
              Icons.shopping_cart,
            ),
            onPressed: () =>
                cart.addItem(product.id, product.price, product.title),
          ),
        ),
      ),
    );
  }
}
