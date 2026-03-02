import 'dart:convert';
import 'package:ecommerce_app/features/cart/data/model/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/cached_key.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<void> addToCart(CartItemModel item);
  Future<void> removeFromCart(int productId);
  Future<void> decrementCartItem(int productId);
  Future<void> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final SharedPreferences sharedPreferences;

  CartLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<CartItemModel>> getCartItems() async {
    final jsonString = sharedPreferences.getString(cartKey);

    if (jsonString != null) {
      final List decodedJson = jsonDecode(jsonString);

      return decodedJson.map((json) => CartItemModel.fromJson(json)).toList();
    }

    return [];
  }

  @override
  Future<void> addToCart(CartItemModel item) async {
    final items = await getCartItems();

    final existingIndex = items.indexWhere((element) => element.product.id == item.product.id);

    if (existingIndex >= 0) {
      items[existingIndex].quantity += 1;
    } else {
      items.add(item);
    }

    final List<Map<String, dynamic>> jsonList = items.map((e) => e.toJson()).toList();
    await sharedPreferences.setString(cartKey, jsonEncode(jsonList));
  }

  @override
  Future<void> removeFromCart(int productId) async {
    final items = await getCartItems();
    items.removeWhere((item) => item.product.id == productId);
    final List<Map<String, dynamic>> jsonList = items.map((e) => e.toJson()).toList();
    await sharedPreferences.setString(cartKey, jsonEncode(jsonList));
  }

  @override
  Future<void> decrementCartItem(int productId) async {
    final items = await getCartItems();
    final index = items.indexWhere((element) => element.product.id == productId);

    if (index >= 0) {
      if (items[index].quantity > 1) {
        items[index].quantity -= 1;
      } else {
        items.removeAt(index);
      }

      final List<Map<String, dynamic>> jsonList = items.map((e) => e.toJson()).toList();
      await sharedPreferences.setString(cartKey, jsonEncode(jsonList));
    }
  }

  @override
  Future<void> clearCart() async {
    await sharedPreferences.remove(cartKey);
  }
}
