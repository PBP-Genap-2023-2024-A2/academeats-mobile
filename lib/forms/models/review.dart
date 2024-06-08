import 'dart:convert';

Progress progressFromJson(String str) => Progress.fromJson(json.decode(str));

String progressToJson(Progress data) => json.encode(data.toJson());

class Progress {
    List<Review> reviews;
    Makanan makanan;

    Progress({
        required this.reviews,
        required this.makanan,
    });

    factory Progress.fromJson(Map<String, dynamic> json) => Progress(
        reviews: List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
        makanan: Makanan.fromJson(json["makanan"]),
    );

    Map<String, dynamic> toJson() => {
        "reviews": List<dynamic>.from(reviews.map((x) => x.toJson())),
        "makanan": makanan.toJson(),
    };
}

class Makanan {
    int id;
    String nama;
    int harga;
    String deskripsi;
    int stok;
    int toko;
    int kategori;
    String imgUrl;

    Makanan({
        required this.id,
        required this.nama,
        required this.harga,
        required this.deskripsi,
        required this.stok,
        required this.toko,
        required this.kategori,
        required this.imgUrl,
    });

    factory Makanan.fromJson(Map<String, dynamic> json) => Makanan(
        id: json["id"],
        nama: json["nama"],
        harga: json["harga"],
        deskripsi: json["deskripsi"],
        stok: json["stok"],
        toko: json["toko"],
        kategori: json["kategori"],
        imgUrl: json["img_url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "harga": harga,
        "deskripsi": deskripsi,
        "stok": stok,
        "toko": toko,
        "kategori": kategori,
        "img_url": imgUrl,
    };
}

class Review {
    int id;
    dynamic userId;
    dynamic orderId;
    int makananId;
    int nilai;
    String komentar;
    String? reply;

    Review({
        required this.id,
        required this.userId,
        required this.orderId,
        required this.makananId,
        required this.nilai,
        required this.komentar,
        required this.reply,
    });

    factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        userId: json["user_id"],
        orderId: json["order_id"],
        makananId: json["makanan_id"],
        nilai: json["nilai"],
        komentar: json["komentar"],
        reply: json["reply"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "order_id": orderId,
        "makanan_id": makananId,
        "nilai": nilai,
        "komentar": komentar,
        "reply": reply,
    };
}