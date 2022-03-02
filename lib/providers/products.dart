import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/http_exception.dart';
import './product.dart';

class Products with ChangeNotifier {
  List<Product>? _items = [];
  final String? authToken;
  final String? userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items!];
  }

  List<Product> get favorites {
    return _items!.where((product) => product.isFavorite).toList();
  }

  Product findById(String id) {
    return _items!.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    var url =
        'https://app-shop-1c7f1-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }
      url =
          'https://app-shop-1c7f1-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(Uri.parse(url));
      final favoriteData = jsonDecode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach(
        (prodId, prodData) {
          loadedProducts.add(
            Product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              price: prodData['price'],
              imageUrl: prodData['imageUrl'],
              isFavorite:
                  favoriteData == null ? false : favoriteData[prodId] ?? false,
            ),
          );
        },
      );
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      // ignore: use_rethrow_when_possible
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://app-shop-1c7f1-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
        }),
      );
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items!.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      // ignore: avoid_print
      print(error);
      // ignore: use_rethrow_when_possible
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items!.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://app-shop-1c7f1-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
      final response = await http.patch(
        Uri.parse(url),
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price,
        }),
      );
      if (response.statusCode >= 400) {
        throw HttpException("Error");
      }
      _items![prodIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final itemIndex = _items!.indexWhere((prod) => prod.id == id);
    Product? itemSave = _items![itemIndex];
    _items!.removeAt(itemIndex);
    notifyListeners();

    final url =
        'https://app-shop-1c7f1-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items!.insert(itemIndex, itemSave);
      notifyListeners();
      throw HttpException('Error al eliminar el producto');
    }
    itemSave = null;
  }
}
