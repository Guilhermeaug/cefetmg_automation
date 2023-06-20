import 'dart:convert';

import 'package:cefetmg_automation/models/grade.dart';
import 'package:cefetmg_automation/services/sigaa/sigaa.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

class GradesScreen extends StatefulWidget {
  const GradesScreen({Key? key}) : super(key: key);

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  final sharedPrefs = GetIt.instance.get<SharedPreferences>();
  late bool notificationEnabled;

  @override
  void initState() {
    super.initState();
    if (!sharedPrefs.containsKey('grades')) {
      fetchGrades();
    }
    notificationEnabled = sharedPrefs.getBool('grade_notitification') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              if (notificationEnabled) {
                Workmanager().cancelByTag('get-grades-func');
              } else {
                Workmanager()
                    .registerPeriodicTask('get-grades-func', 'get-grades');
              }

              setState(() {
                sharedPrefs.setBool(
                    'grade_notitification', !notificationEnabled);
                notificationEnabled = !notificationEnabled;
              });
            },
            icon: notificationEnabled
                ? const Icon(Icons.notifications_active)
                : const Icon(Icons.notifications_none),
          ),
          IconButton(
            onPressed: () {
              fetchGrades();
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Center(
                  child: Text(
                    'Notas das disciplinas',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                FutureBuilder(
                  future: sharedPrefs.reload(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Erro ao carregar as notas',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      List<Grade> grades =
                          jsonDecode(sharedPrefs.getString('grades') ?? '[]')
                              .map<Grade>((grade) => Grade.fromJson(grade))
                              .toList();

                      if (grades.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: grades.length,
                        itemBuilder: (context, index) {
                          final item = grades[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Theme.of(context).colorScheme.surface,
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    item.name,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8.0),
                                  DataTable(
                                    columns: const [
                                      DataColumn(
                                          label: Text(
                                        'Avaliacao',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                      DataColumn(
                                          label: Text(
                                        'Nota',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ],
                                    rows: [
                                      for (final grade in item.grades.entries)
                                        DataRow(
                                          cells: [
                                            DataCell(Text(grade.key)),
                                            DataCell(Text(grade.value)),
                                          ],
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    'Total: ${item.total}',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
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
      ),
    );
  }
}
