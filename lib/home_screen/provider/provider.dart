import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore dependency
import 'package:foodmenu/home_screen/model.dart';

class FoodProvider with ChangeNotifier {
  final List<FoodItem> _foodItems = [];
  bool _isLoading = false;

  List<FoodItem> get foodItems => _foodItems;
  bool get isLoading => _isLoading;

  /// Fetch food items from Firestore
  Future<void> fetchFoodItems() async {
    _isLoading = true;
    notifyListeners();

    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('foodItems').get();
      _foodItems.clear();
      for (var doc in querySnapshot.docs) {
        _foodItems.add(
          FoodItem(
            id: doc.id,
            name: doc['name'] ?? '',
            price: doc['price']?.toDouble() ?? 0.0,
          ),
        );
      }
    } catch (e) {
      print("Error fetching food items: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Add a new food item to Firestore
  Future<void> addFoodItem(FoodItem foodItem) async {
    try {
      final docRef = await FirebaseFirestore.instance.collection('foodItems').add({
        'name': foodItem.name,
        'price': foodItem.price,
      });
      _foodItems.add(FoodItem(id: docRef.id, name: foodItem.name, price: foodItem.price));
      notifyListeners();
    } catch (e) {
      print("Error adding food item: $e");
    }
  }
}
