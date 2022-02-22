import 'package:flutter/material.dart';

import '../widgets/product_grid.dart';

enum FilterOptions {
  favorite,
  all,
}

class ProductsOverviewScreen extends StatelessWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            // ignore: avoid_print
            onSelected: (FilterOptions value) => print(value),
            icon: const Icon(Icons.more_vert),
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                child: Text('Favorites'),
                value: FilterOptions.favorite,
              ),
              const PopupMenuItem(
                child: Text('All'),
                value: FilterOptions.all,
              ),
            ],
          ),
        ],
      ),
      body: const ProductGrid(),
    );
  }
}
