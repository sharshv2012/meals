import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/models/meal.dart';

class FavMealsNotifier extends StateNotifier<List<Meal>> {
  FavMealsNotifier() : super([]); 
  // inside super we have to pass our initial data.

  void _toggleMealFavouriteStatus(Meal meal){ // methods to edit our data.
    // but the thing is we can't edit or mutate our data just like we normally did.
    // We have to pass the data derived from our data.
    // we can use add or remove here.

    final mealIsFav = state.contains(meal);
    // state holds the data it is made availble by StateNotifier class.

    if(mealIsFav){
      state = state.where((m) => m.id != meal.id).toList();
    }else{
      state = [...state, meal]; 
      // ... spreads items of the list or state and adds them to the new list.
    }
    // only reassignment can be done to the state.
    



  }
}

final favouriteMealsProvider = StateNotifierProvider<FavMealsNotifier, List<Meal>>((ref) {
  return FavMealsNotifier();
});