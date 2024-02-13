class AcceptedTasksByOtherUser {
  final String number;
  final DateTime date;
  final String user;

  AcceptedTasksByOtherUser(
      {required this.number, required this.date, required this.user});

  factory AcceptedTasksByOtherUser.fromJson(Map<String, dynamic> json) {
    return AcceptedTasksByOtherUser(
        number: json['number'],
        date: DateTime.parse(json['date']),
        user: json['user']);
  }
}
