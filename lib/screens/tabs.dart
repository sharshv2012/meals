import 'package:flutter/material.dart';
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
  void _selectPage(int index){
    setState(() {
      _selectedPageIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {


    Widget activePage = const CategoriesScreen();
    var activePageTitle = 'Categories';
    if(_selectedPageIndex == 1){
      activePage = const MealsScreen(meals: [], title: '');
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