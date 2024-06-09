class User {
  int id;
  String username;
  String namaLengkap;
  String namaPanggilan;
  String bio;
  String role;
  double saldo;
  String? pfp_url;
  // DateTime tanggalBergabung;

  User({
    required this.id,
    required this.username,
    required this.namaLengkap,
    required this.namaPanggilan,
    required this.bio,
    required this.role,
    required this.saldo,
    required this.pfp_url
    // required this.tanggalBergabung,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"] ?? 0,
    username: json["username"],
    namaLengkap: json["nama_lengkap"],
    namaPanggilan: json["nama_panggilan"],
    bio: json["bio"] ?? "-",
    role: json["role"],
    saldo: json["saldo"] ?? 0,
    pfp_url: json["pfp_url"] ?? "https://i.quotev.com/hiaa3fa55smq.jpg",
    // tanggalBergabung: DateTime.parse(json["tanggal_bergabung"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "nama_lengkap": namaLengkap,
    "nama_panggilan": namaPanggilan,
    "bio": bio,
    "role": role,
    // "date_added": "${tanggalBergabung.year.toString().padLeft(4, '0')}-${tanggalBergabung.month.toString().padLeft(2, '0')}-${tanggalBergabung.day.toString().padLeft(2, '0')}",
  };

}