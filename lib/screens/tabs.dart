import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/data/dummy_data..dart';

import 'package:meals/providers/filters_provider.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widget/main_drawer.dart';
import 'package:meals/providers/meals_provider.dart';
import 'package:meals/providers/favourites_provider.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});
  @override
  ConsumerState<TabsScreen> createState() {
    return _tabsScreenState();
  }
}

class _tabsScreenState extends ConsumerState<TabsScreen> {
  var _selectedPageIndex = 0;

  // void _toggleMealFavouriteStatus(Meal meal) {
  //   final isExisting = _favoriteMeals.contains(meal);

  //   if (isExisting == true) {
  //     setState(() {
  //       _favoriteMeals.remove(meal);
  //     });
  //     _showInfoMessage("Meal is no longer a favorite.");
  //   } else {
  //     setState(() {
  //       _favoriteMeals.add(meal);
  //     });
  //     _showInfoMessage("It's your favorite meal now!");
  //   }
  // }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop(); // to close the drawer.
    if (identifier == 'meals') {
      Navigator.of(context).push(
        // if you use pushReplacement ,
        // the stack will be cleared and the the screen will be
        //pushed, then back button won't take you to previous screen.
        MaterialPageRoute(
          builder: (ctx) =>
              const MealsScreen(meals: dummyMeals, title: "All Meals"),
        ),
      );
    } else if (identifier == "filter") {
      await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
            builder: (ctx) =>
                const FilterScreen()), // passing the _selectFilter to filter screen so it can align the switches as they were.
      ); // once the result screen is pushed it'll surely return that map value in future.
    }
  }

  @override
  Widget build(BuildContext context) {
    final meals = ref.watch(mealsProvider);
    final activeFilters = ref.watch(filtersProvider);
    final avaibleMeals = meals.where((Meal) {
      // filtering the dummyMeals list according to the filters we have.
      if (activeFilters[Filter.glutenFree]! && !Meal.isGlutenFree) {
        return false;
      }
      if (activeFilters[Filter.lactoseFree]! && !Meal.isLactoseFree) {
        return false;
      }
      if (activeFilters[Filter.vegan]! && !Meal.isVegan) {
        return false;
      }
      if (activeFilters[Filter.vegetarian]! && !Meal.isVegetarian) {
        return false;
      }

      return true; // for remaining list items which aren't filtered.
    }).toList();

    Widget activePage = CategoriesScreen(
      availbleMeals: avaibleMeals,
    );
    var activePageTitle = 'Categories';
    //print("heyy ${_selectedPageIndex}");
    if (_selectedPageIndex == 1) {
      final favMeal = ref.watch(favouriteMealsProvider);
      activePage = MealsScreen(
        meals: favMeal,
        title: '',
      );
      activePageTitle = 'Your Favourites';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        key: const Key('bottom_navigation_bar'),
        onTap: (index) {
          setState(() {
            _selectedPageIndex = index;
          });
        }, // flutter gives an index value according to the pressed tab.
        currentIndex:
            _selectedPageIndex, // it'll control highlighting of current tab.
        items: [
          BottomNavigationBarItem(
              icon: AnimatedSwitcher(
                // implicit animation.
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: Tween<double>(begin: 0.5, end: 1).animate(
                      animation), // Tween is used to define the range of values.
                  child: child,
                ),
                child: const Icon(
                  Icons.set_meal,
                  key: ValueKey("fish"),
                ),
              ),
              label: 'Categories'),
          BottomNavigationBarItem(
              icon: AnimatedSwitcher(
                // implicit animation.
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return RotationTransition(
                    turns: Tween<double>(begin: 0.5, end: 1).
                    animate(animation), // Tween is used to define the range of values.
                    child: child,
                  );
                },
                child: const Icon(
                  Icons.star,
                  key: ValueKey("star"),
                ),
              ),
              label: "Favourites"),
        ],
      ),
    );
  }
}
