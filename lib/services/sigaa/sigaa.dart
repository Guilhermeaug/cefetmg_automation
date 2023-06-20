import 'dart:convert';

import 'package:cefetmg_automation/models/notification.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/grade.dart';

class SigaaHelper {
  final baseUrl = "https://sig.cefetmg.br/sigaa";
  final SharedPreferences _sharedPreferences;

  SigaaHelper(this._sharedPreferences);

  Future<void> _getJSessionId(Dio http) async {
    const endpoint = "/verTelaLogin.do";
    await http.get(endpoint);
  }

  Future<void> _login(Dio http) async {
    const endpoint = "/logar.do?dispatch=logOn";
    final cpf = _sharedPreferences.getString("cpf");
    final password = _sharedPreferences.getString("password");
    final form = FormData.fromMap({
      "user.login": cpf,
      "user.senha": password,
    });
    await http.post(endpoint, data: form);
  }

  Future<List<GradesPayload>> _getClasses(Dio http) async {
    const endpoint = "/verPortalDiscente.do";
    final response = await http.get(endpoint);
    final $ = parse(response.data);

    List<GradesPayload> payloads = [];
    for (final course in $.querySelectorAll("td.descricao")) {
      final onClick = course.querySelector("a")?.attributes["onclick"]!;
      final name = course.text.trim();
      final action = course.querySelector("form")?.attributes["name"]!;
      final formName =
          course.querySelector("form:first-child")?.attributes["name"]!;
      final idRegex = RegExp(r"'frontEndIdTurma':'(.*)'");
      final id = idRegex.firstMatch(onClick!)!.group(0)!.split("'")[3];
      final mRegex = RegExp("$formName:[a-zA-Z0-9_]+");
      final m = mRegex.firstMatch(onClick)!.group(0)!;

      GradesPayload payload = GradesPayload(
        name: name,
        request: {
          "action": action!,
          "frontEndIdTurma": id,
          "viewState": course
              .querySelector('input[name="javax.faces.ViewState"]')!
              .attributes["value"]!,
          "formName": formName!,
          "m": m,
        },
      );
      payloads.add(payload);
    }
    return payloads;
  }

  Future<List<Grade>> _getGrades(Dio http, List<GradesPayload> courses) async {
    List<Grade> grades = [];
    for (final course in courses) {
      const courseEndpoint = "/portais/discente/discente.jsf";
      final courseData = FormData.fromMap({
        course.request["formName"]!: course.request["formName"],
        "javax.faces.ViewState": course.request["viewState"],
        course.request["m"]!: course.request["m"],
        "frontEndIdTurma": course.request["frontEndIdTurma"],
      });
      final responseCoursePage =
          await http.post(courseEndpoint, data: courseData);

      final $ = parse(responseCoursePage.data);
      final viewState = $
          .querySelector('input[name="javax.faces.ViewState"]')!
          .attributes["value"]!;

      const gradesUrl = "/ava/index.jsf";
      final gradesData = FormData.fromMap({
        "formMenu": "formMenu",
        "formMenu:j_id_jsp_311393315_65": "formMenu:j_id_jsp_311393315_88",
        "javax.faces.ViewState": viewState,
        "formMenu:j_id_jsp_311393315_93": "formMenu:j_id_jsp_311393315_93",
      });

      final responseGradesPage = await http.post(gradesUrl, data: gradesData);
      final $$ = parse(responseGradesPage.data);
      if ($$.querySelector(".tabelaRelatorio") == null) {
        continue;
      }
      final p = $$
          .querySelectorAll(".tabelaRelatorio tbody tr td")
          .map((el) => el.text.trim())
          .toList();

      final points = p.sublist(2, p.length - 4);
      final l = $$
          .querySelectorAll("tr#trAval th")
          .map((el) => el.text.trim())
          .toList();
      final labels = l.sublist(2, l.length - 5);

      Map<String, String> gradesMap = {};
      for (var i = 0; i < labels.length; i++) {
        gradesMap[labels[i]] = points[i];
      }

      grades.add(Grade(
        name: course.name,
        grades: gradesMap,
      ));
    }

    return grades;
  }

  Dio _configureHttpClient(CookieJar cookieJar) {
    final options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      validateStatus: (status) =>
          status! >= 200 && status < 300 || status == 302,
    );
    final http = Dio(options);
    http.interceptors.add(CookieManager(cookieJar));
    return http;
  }

  Future<List<Grade>> runAction() async {
    final cookieJar = CookieJar();
    final http = _configureHttpClient(cookieJar);
    await _getJSessionId(http);
    await cookieJar.loadForRequest(Uri.parse(baseUrl));
    await _login(http);
    final courses = await _getClasses(http);
    final grades = await _getGrades(http, courses);
    return grades;
  }
}

void newGradeNotification() async {
  final notificationService = GetIt.I.get<NotificationService>();
  final notification = CustomNotification(
    id: 1,
    title: 'Notas atualizadas!',
    body: 'Suas notas foram atualizadas!',
  );
  await notificationService.showNotification(notification);
}

void fetchGrades() async {
  print('Fetching grades...');

  final sharedPrefs = await SharedPreferences.getInstance();
  await sharedPrefs.reload();

  final grades = await SigaaHelper(sharedPrefs).runAction();
  var newGrades = false;

  List<Grade> oldGrades = jsonDecode(sharedPrefs.getString('grades') ?? '[]')
      .map<Grade>((grade) => Grade.fromJson(grade))
      .toList();

  if (oldGrades.isEmpty) {
    // First time fetching grades
    newGradeNotification();
    newGrades = true;
  } else {
    // Check if grades have changed
    for (var i = 0; i < grades.length; i++) {
      final oldGrade = oldGrades[i];
      final newGrade = grades[i];
      if (oldGrade.grades.toString() != newGrade.grades.toString()) {
        newGradeNotification();
        newGrades = true;
        break;
      }
    }
  }
  // Calculate total
  for (final grade in grades) {
    double sum = 0;
    for (final grade in grade.grades.values) {
      final num = double.tryParse(grade.replaceAll(',', '.'));
      if (num != null) {
        sum += num;
      }
    }
    grade.total = sum.toStringAsFixed(2);
  }

  if (newGrades) {
    final String encodedData = jsonEncode(grades);
    await sharedPrefs.setString('grades', encodedData);
  }
}
