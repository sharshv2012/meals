import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/widget/meal_item_meta_data.dart';
import 'package:transparent_image/transparent_image.dart';

class MealItem extends StatelessWidget {
  const MealItem({
    super.key,
    required this.meal,
    required this.onSelectMeal,
  });

  final Meal meal;
  final void Function(Meal meal ) onSelectMeal;

  String get complexityText{
    return meal.complexity.name[0].toUpperCase() + meal.complexity.name.substring(1); //harsh -> Harsh
  }
  String get affordabilityText{
    return meal.affordability.name[0].toUpperCase() + meal.affordability.name.substring(1); //harsh -> Harsh
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.hardEdge, // clips any outgoing content of child widget(as we used circular radius which stack overrides.)
      elevation: 2,
      child: InkWell(
        onTap: () {
          onSelectMeal(meal); //Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => MealDetailsScreen(meal: meal),
                              // I can do this too.
        },
        //splashColor: Colors.white,(not working over image)
        child: Stack(
          children: [
            FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(meal.imageUrl),
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 44,),
                color: Colors.black54,
                child: Column(
                  children: [
                     Text(
                      meal.title,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis, // very long...
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                     ),
                     const SizedBox(height: 12,),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MealItemTrait(icon: Icons.schedule, label: '${meal.duration} min'),
                        const SizedBox(width: 12,),
                        MealItemTrait(icon: Icons.menu_book, label: complexityText),
                        const SizedBox(width: 12,),
                        MealItemTrait(icon: Icons.attach_money, label: affordabilityText),


                      ],
                     )
                  ],
                ),

              ),
            ), //used transparentImage Library
          ],
        ),
      ),
    );
  }
}
