import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/widget/category_grid_item.dart';
import 'package:meals/data/dummy_data..dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/models/category.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.availbleMeals});

  final List<Meal> availbleMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  // used 'with' to merge another class.
  // if u have multiple animation controller the use
  //TickerProviderStateMixin class.
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
      lowerBound: 0,
      upperBound: 1,
    );

    _animationController.forward();
    // run it once , u can use .repeat to repeat the animation.
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = widget.availbleMeals
        .where(
          // filtering from the availble meals I got from tabsScreen.
          (meal) => meal.categories.contains(category.id),
        )
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealsScreen(
          meals: filteredMeals,
          title: category.title,
        ),
      ),
    ); // u can also do Navigator.of(context).push(rout);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,

      //the builder will be rebuild every sec hence to avoid rebuilding of every
      //widget, we take them in the child so they won't be build this many times.
      //the gridview is animating but it is not changing only padding is changing.
      child: GridView(
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
              onSelectCategory: () {
                _selectCategory(context, category);
              },
            )
          // u can also map the widgets like :
          //...availableCategories.map((category) => CategoryGridItem(category:category)).toList()
        ],
      ),
      builder: (context, child) => SlideTransition( // there are many types of transitions available.
        //optimized version
        position: Tween(
          begin: const Offset(0, 0.3), // 30% offset on y axis.
          end: const Offset(0, 0),
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut, // nature of animation
            // ease in out means it will be slow at ending and start.
          ),
        ),
        child: child,
      ),

      /*Padding(padding: EdgeInsets.only(
        top: 100 - _animationController.value * 100, 
        // @value = 0 padding will be 100 and at value @ 1 padding will be 0.
      ),child: child),*/
    );
  }
}
