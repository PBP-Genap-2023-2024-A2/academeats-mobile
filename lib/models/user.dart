class User {
  int id;
  String username;
  String namaLengkap;
  String namaPanggilan;
  String bio;
  // DateTime tanggalBergabung;

  User({
    required this.id,
    required this.username,
    required this.namaLengkap,
    required this.namaPanggilan,
    required this.bio,
    // required this.tanggalBergabung,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    username: json["username"],
    namaLengkap: json["nama_lengkap"],
    namaPanggilan: json["nama_panggilan"],
    bio: json["bio"],
    // tanggalBergabung: DateTime.parse(json["tanggal_bergabung"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "nama_lengkap": namaLengkap,
    "nama_panggilan": namaPanggilan,
    "bio": bio,
    // "date_added": "${tanggalBergabung.year.toString().padLeft(4, '0')}-${tanggalBergabung.month.toString().padLeft(2, '0')}-${tanggalBergabung.day.toString().padLeft(2, '0')}",
  };
}