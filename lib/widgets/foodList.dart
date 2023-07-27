import 'package:flutter/material.dart';
import 'package:food_ordering_application/model/food_menu_model.dart';
import 'package:food_ordering_application/widgets/foodTileAnimation.dart';

class FoodList extends StatelessWidget {
  const FoodList({super.key, required this.foods});

  final List<FoodMenuModel> foods;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (foods.isNotEmpty) {
        return GridView.builder(
          itemCount: foods.length,
          itemBuilder: (context, index) => FoodTileAnimation(
            itemNo: index,
            food: foods[index],
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: constraints.maxWidth > 700 ? 4 : 2,
            childAspectRatio: 1,
          ),
        );
      } else {
        return const Center(
          child: Text("There is no food right now..."),
        );
      }
    });
  }
}
