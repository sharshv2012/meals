import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';

class MealDetailsScreen extends StatelessWidget{

  const MealDetailsScreen({super.key, required this.meal});
  final Meal meal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
      ),
      body: SingleChildScrollView(
        child: Column( // for making it Scrollable I can also use ListView instead of column but themn the items won't be centered by default.
          children: [
            Image.network(
              meal.imageUrl,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 14,),
            Text('Ingredients', style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.onBackground, fontWeight: FontWeight.bold,
            ),),
            const SizedBox(height: 14,),
            for (final ingredient in meal.ingredients)
              Text(ingredient, style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.primary,),),
            
            const SizedBox(height: 24,),
            Text('Steps', style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.onBackground, fontWeight: FontWeight.bold,
            ),),
            const SizedBox(height: 12,),
            for (final steps in meal.steps)
              Padding(
                padding: const EdgeInsets.symmetric(vertical:8 , horizontal:12 ,),
                child: Text(steps, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,),),
              ),
          ],
        ),
      ),
    );
  }
}