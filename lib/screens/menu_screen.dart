import 'package:cefetmg_automation/models/menu.dart';
import 'package:cefetmg_automation/services/firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../components/day_menu.dart';
import '../utils/menu_utils.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int? _selectedDay = DateTime.now().weekday;
  late Future<Map<int, Menu>> menu;

  @override
  void initState() {
    super.initState();
    menu = fetchWeekMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.article),
          onPressed: () {
            context.push('/grades');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() => menu = fetchWeekMenu()),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  'Cardápio do RU',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16.0),
              FutureBuilder(
                future: menu,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    final data = snapshot.data as Map<int, Menu>;
                    return Column(
                      children: [
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 4.0,
                          children: [
                            for (final item in data.values)
                              ChoiceChip(
                                label: Text(
                                  days[item.weekDay],
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                selected: _selectedDay == item.weekDay,
                                onSelected: (selected) => setState(
                                  () => _selectedDay =
                                      selected ? item.weekDay : null,
                                ),
                              )
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        DayMenu(item: data[_selectedDay]),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Erro ao carregar o cardápio',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
