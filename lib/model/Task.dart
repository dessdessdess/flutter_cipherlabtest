class Task {
  final String number;
  final DateTime date;
  final String docType;
  final String guid;
  bool selected;

  Task(
      {required this.number,
      required this.date,
      required this.docType,
      required this.guid,
      required this.selected});

  // static List<Task> getExampleTasks() {
  //   return [
  //     (Task(
  //         "Г00235461",
  //         date: DateTime.now(),
  //         "Реализация товаров услуг",
  //         "guid",
  //         selected: false)),
  //     (Task(
  //         "Р1739204",
  //         date: DateTime.now(),
  //         "Реализация товаров услуг",
  //         "guid",
  //         selected: false)),
  //     (Task("Р1739373", DateTime.now(), "Перемещение товаров", "guid", false)),
  //     (Task("Р1739206", DateTime.now(), "Перемещение товаров", "guid", false)),
  //     (Task("Р1739321321", DateTime.now(), "Реализация товаров услуг", "guid",
  //         false)),
  //     (Task("Р17392065475", DateTime.now(), "Перемещение товаров", "guid",
  //         false)),
  //     (Task("Г0045614754", DateTime.now(), "Реализация товаров услуг", "guid",
  //         false)),
  //     (Task("Р00678424", DateTime.now(), "Реализация товаров услуг", "guid",
  //         false))
  //   ];
  // }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      number: json['Номер'],
      date: json['Дата'],
      docType: json['ВидДокумента'],
      guid: json['GUID'],
      selected: false,
    );
  }
}
