class Kategori {
  final String id;
  final String nama;
  final String tipe; // pemasukan / pengeluaran

  Kategori({required this.id, required this.nama, required this.tipe});

  factory Kategori.fromJson(Map<String, dynamic> json) => Kategori(
    id: json['id'],
    nama: json['nama'],
    tipe: json['tipe'],
  );
}
