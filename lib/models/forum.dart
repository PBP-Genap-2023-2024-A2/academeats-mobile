class Forum {
  int pk;
  String name;
  String description;
  DateTime dateAdded;

  Forum({
    required this.pk,
    required this.name,
    required this.description,
    required this.dateAdded,
  });

  factory Forum.fromJson(Map<String, dynamic> json) => Forum(
    pk: json["pk"],
    name: json["name"],
    description: json["description"],
    dateAdded: DateTime.parse(json["date_added"]),
  );

  Map<String, dynamic> toJson() => {
    "pk": pk,
    "name": name,
    "description": description,
    "date_added": "${dateAdded.year.toString().padLeft(4, '0')}-${dateAdded.month.toString().padLeft(2, '0')}-${dateAdded.day.toString().padLeft(2, '0')}",
  };
}