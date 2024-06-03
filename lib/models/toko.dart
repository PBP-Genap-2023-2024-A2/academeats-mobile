import 'package:academeats_mobile/models/base_model.dart';
import 'package:academeats_mobile/models/user.dart';

class Toko implements ISendable {
  int id;
  User user;
  String name;
  String description;

  Toko({
    required this.id,
    required this.user,
    required this.name,
    required this.description,
  });

  factory Toko.fromJson(Map<String, dynamic> json) => Toko(
    id: json['id'],
    user: User.fromJson(json['user']),
    name: json['name'],
    description: json['description'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user,
    "name": name,
    "description": description,
  };
}