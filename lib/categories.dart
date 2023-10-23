import 'package:flutter/material.dart';
import 'package:meals/category_grid_item.dart';
import 'package:meals/data/dummy_data..dart';
import 'package:meals/meals.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  void _selectCategory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MealsScreen(meals: [], title: "some title"),
      ),
    ); // u can also do Navigator.of(context).push(rout);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick Your Category"),
      ),
      body: GridView(
        padding: const EdgeInsets.all(18),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        children: [
          for (final category in availableCategories)
            CategoryGridItem(category: category, onSelectCategory: (){_selectCategory(context);})
          // u can also map the widgets like :
          //...availableCategories.map((category) => CategoryGridItem(category:category)).toList()
        ],
      ),
    );
  }
}
