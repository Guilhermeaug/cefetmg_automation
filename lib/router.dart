import 'package:cefetmg_automation/screens/grades_screen.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/login_screen.dart';
import 'screens/menu_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/menu',
      builder: (context, state) => const MenuScreen(),
    ),
    GoRoute(
      path: '/grades',
      builder: (context, state) => const GradesScreen(),
    ),
  ],
  redirect: (context, state) {
    final sharedPrefs = GetIt.instance.get<SharedPreferences>();
    final isLogged =
        sharedPrefs.containsKey('cpf') && sharedPrefs.containsKey('password');
    if (state.location == '/') {
      if (isLogged) {
        return '/menu';
      } else {
        return '/';
      }
    } else {
      if (isLogged) {
        return state.location;
      } else {
        return '/';
      }
    }
  },
);
