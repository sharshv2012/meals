import 'package:flutter_riverpod/flutter_riverpod.dart';


enum Filter{
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
}

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier() : super({
    Filter.glutenFree : false,
    Filter.lactoseFree: false,
    Filter.vegan: false,
    Filter.vegetarian: false
  });

  void setFilters(Map<Filter, bool> chosenFilter){
    state = chosenFilter;
  }

  void setFilter(Filter filter, bool isActive){
    state = {
      ...state, // spreading the  default data or key-value pair
      filter: isActive, // overriding the default data with new passed key-value pair.
    };
  }
}


final filtersProvider = StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>((ref) => FiltersNotifier());