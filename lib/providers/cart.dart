import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  final Map<String, CartItem>? _items = {};
  Map<String, CartItem>? get items {
    return {...?_items};
  }

  int get lengthItems {
    //option 1
    // return _items == null ? 0 : _items!.length;

    //option 2
    var sumatoria = 0;
    _items?.forEach((key, value) {
      sumatoria += value.quantity;
    });
    return sumatoria;
  }

  double get totalAmount {
    var amount = 0.0;
    _items?.forEach((key, carItem) {
      amount += carItem.quantity * carItem.price;
    });
    return amount;
  }

  void addItem(String productId, double price, String title) {
    if (_items!.containsKey(productId)) {
      _items!.update(
        productId,
        (existingCarItem) => CartItem(
          id: existingCarItem.id,
          title: existingCarItem.title,
          quantity: existingCarItem.quantity + 1,
          price: existingCarItem.price,
        ),
      );
    } else {
      _items!.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items!.remove(productId);
    notifyListeners();
  }
}
