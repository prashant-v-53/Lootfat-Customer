class NotificationModel {
  final String title;
  final String body;
  final String type;
  final String typeId;
  final DateTime date;
  final String id;
  int? current;
  int? last;
  int? totalResults;
  int? limit;

  NotificationModel({
    required this.title,
    required this.body,
    required this.type,
    required this.typeId,
    required this.date,
    required this.id,
    this.current,
    this.last,
    this.totalResults,
    this.limit,
  });

  factory NotificationModel.fromJson(
    Map<String, dynamic> json,
    int currentPage,
    int lastPage,
    int totalResults,
    int limit,
  ) =>
      NotificationModel(
        title: json["title"],
        body: json["body"],
        type: json["type"],
        typeId: json["typeId"],
        date: DateTime.parse(json["date"]),
        id: json["_id"],
        current: currentPage,
        last: lastPage,
        totalResults: totalResults,
        limit: limit,
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "body": body,
        "type": type,
        "typeId": typeId,
        "date": date.toIso8601String(),
        "_id": id,
        "current": current,
        "last": last,
        "totalResults": totalResults,
        "limit": limit,
      };
}
