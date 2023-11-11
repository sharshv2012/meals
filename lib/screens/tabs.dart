import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/data/dummy_data..dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widget/main_drawer.dart';
import 'package:meals/providers/meals_provider.dart';


const kInitialFilter = 
  {
    Filter.glutenFree: false,
    Filter.lactoseFree: false,
    Filter.vegan: false,
    Filter.vegetarian: false
  };


class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});
  @override
  ConsumerState<TabsScreen> createState() {
    return _tabsScreenState();
  }
}

class _tabsScreenState extends ConsumerState<TabsScreen> {
  var _selectedPageIndex = 0;
  
  final List<Meal> _favoriteMeals = [];
  Map<Filter, bool> _selectedFilters = {
    Filter.glutenFree: false,
    Filter.lactoseFree: false,
    Filter.vegan: false,
    Filter.vegetarian: false
  };

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _toggleMealFavouriteStatus(Meal meal) {
    final isExisting = _favoriteMeals.contains(meal);

    if (isExisting == true) {
      setState(() {
        _favoriteMeals.remove(meal);
      });
      _showInfoMessage("Meal is no longer a favorite.");
    } else {
      setState(() {
        _favoriteMeals.add(meal);
      });
      _showInfoMessage("It's your favorite meal now!");
    }
  }

  void _selectPage(int index) {

    setState(() {
      _selectedPageIndex = index;
      
    });
  }

  void _setScreen(String identifier) async{
    Navigator.of(context).pop();// to close the drawer.
    if (identifier == 'meals') {
      Navigator.of(context).push(// if you use pushReplacement ,
      // the stack will be cleared and the the screen will be 
      //pushed, then back button won't take you to previous screen.
        MaterialPageRoute(
          builder: (ctx) => MealsScreen(
            meals: dummyMeals,
            title: "All Meals",
            onToggleFavourite: _toggleMealFavouriteStatus,
          ),
        ),
      );
    } 
    
    else if (identifier == "filter") {
      
      final result = await Navigator.of(context).push<Map<Filter, bool>>(  
        MaterialPageRoute(builder: (ctx) => FilterScreen(currentFilters: _selectedFilters,)),// passing the _selectFilter to filter screen so it can align the switches as they were.
      );// once the result screen is pushed it'll surely return that map value in future.

      setState(() {
        _selectedFilters = result ?? kInitialFilter; // in case result is null.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final meals = ref.watch(mealsProvider);
    final avaibleMeals = meals.where((Meal) { 
      // filtering the dummyMeals list according to the filters we have.
      if (_selectedFilters[Filter.glutenFree]! && !Meal.isGlutenFree){
        return false;
      }
      if (_selectedFilters[Filter.lactoseFree]! && !Meal.isLactoseFree){
        return false;
      }
      if (_selectedFilters[Filter.vegan]! && !Meal.isVegan){
        return false;
      }
      if (_selectedFilters[Filter.vegetarian]! && !Meal.isVegetarian){
        return false;
      }

      return true; // for remaining list items which aren't filtered.

    }).toList();


    Widget activePage = CategoriesScreen(
      onToggleFavourite: _toggleMealFavouriteStatus,
      availbleMeals: avaibleMeals,
    );
    var activePageTitle = 'Categories';
    //print("heyy ${_selectedPageIndex}");
    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: _favoriteMeals,
        title: '',
        onToggleFavourite: _toggleMealFavouriteStatus,
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
        key: Key('bottom_navigation_bar'),
        onTap: (index) {
          setState(() {
            _selectedPageIndex = index;
          });
        }, // flutter gives an index value according to the pressed tab.
        currentIndex:
            _selectedPageIndex, // it'll control highlighting of current tab.
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "Favourites"),
        ],
      ),
    );
  }
}
