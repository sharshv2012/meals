import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/meals.dart';

class TabsScreen extends StatefulWidget{

  const TabsScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _tabsScreenState();
  }
}

class _tabsScreenState extends State<TabsScreen>{
  int _selectedPageIndex = 0;
  final List<Meal> _favoriteMeals = [];

  void _showInfoMessage(String message){
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message),),);
  }

  void _toggleMealFavouriteStatus(Meal meal){
    final isExisting = _favoriteMeals.contains(meal);

    if(isExisting == true){
      setState(() {
        _favoriteMeals.remove(meal);
      });
      _showInfoMessage("Meal is no longer a favorite.");
     
    }else{
      setState(() {
        _favoriteMeals.add(meal);
      });
      _showInfoMessage("It's your favorite meal now!");
      
      
    }
  }
  void _selectPage(int index){
    setState(() {
      _selectedPageIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {


    Widget activePage = CategoriesScreen(onToggleFavourite: _toggleMealFavouriteStatus,);
    var activePageTitle = 'Categories';
    if(_selectedPageIndex == 1){
      activePage = MealsScreen(meals: _favoriteMeals, title: '', onToggleFavourite: _toggleMealFavouriteStatus,);
      activePageTitle = 'Your Favourites';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex, // it'll control highlighting of current tab.
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.set_meal), label: 'Categories' ),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "Favourites"),
        ],
      ),
    );
  }
}