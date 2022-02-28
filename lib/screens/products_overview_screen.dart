import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/cart.dart';
import '../widgets/app_drawer.dart';
import '../widgets/product_grid.dart';
import '../widgets/badge.dart';
import './cart_screen.dart';

enum FilterOptions {
  favorite,
  all,
}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var isLoading = false;

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    Provider.of<Products>(context, listen: false).fetchAndSetProducts().then((_) {
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            // ignore: avoid_print
            onSelected: (FilterOptions value) {
              setState(() {
                if (FilterOptions.favorite == value) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
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
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch!,
              value: cart.lengthItems.toString(),
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () =>
                  Navigator.of(context).pushNamed(CartScreen.routeName),
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(showFavorites: _showOnlyFavorites),
    );
  }
}
