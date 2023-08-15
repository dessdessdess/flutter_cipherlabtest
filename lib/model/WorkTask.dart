class WorkTask {
  final String number;
  final DateTime date;
  final String docType;
  final String guid;

  WorkTask(this.number, this.date, this.docType, this.guid);

  static List<WorkTask> getExampleWorkTasks() {
    return [
      (WorkTask(
          "Г00235461", DateTime.now(), "Реализация товаров услуг", "guid")),
      (WorkTask(
          "Р1739204", DateTime.now(), "Реализация товаров услуг", "guid")),
      (WorkTask("Р1739373", DateTime.now(), "Перемещение товаров", "guid")),
      (WorkTask("Р1739206", DateTime.now(), "Перемещение товаров", "guid")),
      (WorkTask(
          "Р1739321321", DateTime.now(), "Реализация товаров услуг", "guid")),
      (WorkTask("Р17392065475", DateTime.now(), "Перемещение товаров", "guid")),
      (WorkTask(
          "Г0045614754", DateTime.now(), "Реализация товаров услуг", "guid")),
      (WorkTask(
          "Р00678424", DateTime.now(), "Реализация товаров услуг", "guid"))
    ];
  }
}
