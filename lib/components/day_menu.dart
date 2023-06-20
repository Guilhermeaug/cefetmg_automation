import 'package:flutter/material.dart';

import '../models/menu.dart';

class DayMenu extends StatelessWidget {
  const DayMenu({
    super.key,
    required this.item,
  });

  final Menu? item;

  @override
  Widget build(BuildContext context) {
    if (item == null) {
      return const Center(
        child: Text('Sem cardápio para o dia de hoje'),
      );
    }

    TextStyle heading = Theme.of(context).textTheme.bodyLarge!.copyWith(
          fontWeight: FontWeight.bold,
        );
    final food = item!;
    return Center(
      child: Wrap(
        direction: Axis.vertical,
        spacing: 4.0,
        children: [
          Text('Prato principal (escolha um)', style: heading),
          Text(food.mainCourse),
          Text(food.veggieCourse),
          Text(food.veganCourse),
          const Text(''),
          Text('Acompanhamentos', style: heading),
          Text(food.sideDish),
          Text(food.rice),
          Text(food.beans),
          const Text(''),
          Text('Saladas e sobremesa', style: heading),
          Text(food.salad1),
          Text(food.salad2),
          Text(food.salad3),
          Text(food.salad4),
          Text(food.dessert),
        ],
      ),
    );
  }
}
