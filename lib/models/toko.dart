import 'package:academeats_mobile/models/user.dart';

class Toko {
  int pk;
  User user;
  String name;
  String description;

  Toko({
    required this.pk,
    required this.user,
    required this.name,
    required this.description,
  });

  factory Toko.fromJson(Map<String, dynamic> json) => Toko(
    pk: json['pk'],
    user: User.fromJson(json['user']),
    name: json['name'],
    description: json['description'],
  );

  Map<String, dynamic> toJson() => {
    "pk": pk,
    "user": user,
    "name": name,
    "description": description,
  };
}