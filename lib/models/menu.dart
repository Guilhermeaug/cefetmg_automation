import 'package:cloud_firestore/cloud_firestore.dart';

class Menu {
  final String mainCourse;
  final String veggieCourse;
  final String veganCourse;
  final String sideDish;
  final String rice;
  final String beans;
  final String salad1;
  final String salad2;
  final String salad3;
  final String salad4;
  final String dessert;
  final String date;
  final int weekDay;

  Menu({
    required this.mainCourse,
    required this.veggieCourse,
    required this.veganCourse,
    required this.sideDish,
    required this.rice,
    required this.beans,
    required this.salad1,
    required this.salad2,
    required this.salad3,
    required this.salad4,
    required this.dessert,
    required this.date,
    required this.weekDay,
  });

  factory Menu.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final options = data!['options'];
    List<String> date = data['date'].split('/');
    int weekDay = DateTime(
      int.parse(date[2]),
      int.parse(date[1]),
      int.parse(date[0]),
    ).weekday;

    return Menu(
      mainCourse: options['main_course']!,
      veggieCourse: options['veggie_course']!,
      veganCourse: options['vegan_course']!,
      sideDish: options['side_dish']!,
      rice: options['rice']!,
      beans: options['beans']!,
      salad1: options['salad1']!,
      salad2: options['salad2']!,
      salad3: options['salad3']!,
      salad4: options['salad4']!,
      dessert: options['dessert']!,
      date: data['date'],
      weekDay: weekDay,
    );
  }

  @override
  String toString() {
    return 'Menu{mainCourse: $mainCourse, veggieCourse: $veggieCourse, veganCourse: $veganCourse, sideDish: $sideDish, rice: $rice, beans: $beans, salad1: $salad1, salad2: $salad2, salad3: $salad3, salad4: $salad4, dessert: $dessert, date: $date, weekDay: $weekDay}';
  }
}
