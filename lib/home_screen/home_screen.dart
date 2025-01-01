import 'package:flutter/material.dart';
import 'package:foodmenu/home_screen/provider/provider.dart';
import 'package:provider/provider.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  Map<String, int> selectedItems = {};
  double totalExpense = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FoodProvider>(context, listen: false).fetchFoodItems();
    });
  }

  void updateQuantity(String foodItemId, int quantity) {
    setState(() {
      if (quantity == 0) {
        selectedItems.remove(foodItemId);
      } else {
        selectedItems[foodItemId] = quantity;
      }
      calculateTotalExpense();
    });
  }

  void calculateTotalExpense() {
    double total = 0;
    selectedItems.forEach((foodItemId, quantity) {
      final foodItem = Provider.of<FoodProvider>(context, listen: false)
          .foodItems
          .firstWhere((item) => item.id == foodItemId);
      total += foodItem.price * quantity;
    });
    setState(() {
      totalExpense = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Royal Orchid"),
      //   backgroundColor: Colors.deepPurple,
      // ),
      body: Column(
        children: [
          // Header section
        Container(
  width: double.infinity,
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.pink, Colors.deepPurple],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    borderRadius: BorderRadius.vertical(
      bottom: Radius.circular(20), // Add rounded corners to the bottom
    ),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Thrissur Guddies",
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        "Experience the taste of food",
        style: TextStyle(color: Colors.white70, fontSize: 16),
      ),
    ],
  ),
),
          // Filter section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ChoiceChip(
                      label: Text("Veg"),
                      selected: false, // Add state management for toggling
                    ),
                    SizedBox(width: 8),
                    ChoiceChip(
                      label: Text("Non-Veg"),
                      selected: false,
                    ),
                  ],
                ),
                DropdownButton(
                  value: "Sort by",
                  items: ["Sort by", "Price", "Popularity"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<FoodProvider>(
              builder: (context, foodProvider, child) {
                if (foodProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (foodProvider.foodItems.isEmpty) {
                  return Center(child: Text("No food items available"));
                }
                return ListView.builder(
                  itemCount: foodProvider.foodItems.length,
                  itemBuilder: (context, index) {
                    final foodItem = foodProvider.foodItems[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepPurple,
                          child: Icon(
                            Icons.food_bank,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          foodItem.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("₹${foodItem.price.toStringAsFixed(2)}"),
                        trailing: selectedItems.containsKey(foodItem.id)
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: () {
                                      int quantity =
                                          selectedItems[foodItem.id] ?? 0;
                                      if (quantity > 0) {
                                        updateQuantity(
                                            foodItem.id, quantity - 1);
                                      }
                                    },
                                  ),
                                  Text(
                                    selectedItems[foodItem.id]?.toString() ??
                                        '0',
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      int quantity =
                                          selectedItems[foodItem.id] ?? 0;
                                      updateQuantity(
                                          foodItem.id, quantity + 1);
                                    },
                                  ),
                                ],
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  updateQuantity(foodItem.id, 1);
                                },
                                child: Text("ADD"),
                              ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Total expense display
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Expense:",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  "₹${totalExpense.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
