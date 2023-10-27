import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/widget/category_grid_item.dart';
import 'package:meals/data/dummy_data..dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/models/category.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key, required this.onToggleFavourite});

  final void Function(Meal meal) onToggleFavourite;

  void _selectCategory(BuildContext context, Category category) {

  final filteredMeals = dummyMeals.where(
    (meal) => 
      meal.categories.contains(category.id),
    ).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>  MealsScreen(
          meals: filteredMeals, 
          title: category.title,
          onToggleFavourite: onToggleFavourite,
        ),
      ),
    ); // u can also do Navigator.of(context).push(rout);
  }

  @override
  Widget build(BuildContext context) {
    
      return GridView(
        padding: const EdgeInsets.all(18),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        children: [
          for (final category in availableCategories)
            CategoryGridItem(
              category: category, 
              onSelectCategory: (){_selectCategory(context, category);},
            )
          // u can also map the widgets like :
          //...availableCategories.map((category) => CategoryGridItem(category:category)).toList()
        ],
      );
  
  }
}
