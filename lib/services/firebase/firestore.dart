import 'package:cefetmg_automation/utils/menu_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/menu.dart';

Future<Map<int, Menu>> fetchWeekMenu() async {
  final weekDays = generateWeekDays();
  final db = FirebaseFirestore.instance;
  final menuRef = db.collection('menus').withConverter(
      fromFirestore: Menu.fromFirestore, toFirestore: (m, _) => {});
  final menuSnapshot =
      await menuRef.where("date", whereIn: weekDays).limit(5).get();
  List<Menu> menus = [...menuSnapshot.docs.map((e) => e.data())];
  menus.sort((a, b) => a.weekDay.compareTo(b.weekDay));
  return {}..addEntries(menus.map((e) => MapEntry(e.weekDay, e)));
}
