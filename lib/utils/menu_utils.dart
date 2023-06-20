final days = [
  'Domingo',
  'Segunda',
  'Terça',
  'Quarta',
  'Quinta',
  'Sexta',
  'Sábado',
];

List<String> generateWeekDays() {
  DateTime now = DateTime.now();
  return List.generate(
    5,
        (index) => now
        .subtract(Duration(days: now.weekday - index - 1))
        .toString()
        .split(' ')[0]
        .split('-')
        .reversed
        .join('/'),
  );
}
