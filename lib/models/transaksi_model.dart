class Transaksi {
  final String id;
  final String deskripsi;
  final int jumlah;
  final String tipe;
  final String kategori;
  final DateTime tanggal;

  Transaksi({required this.id, required this.deskripsi, required this.jumlah, required this.tipe, required this.kategori, required this.tanggal});

  factory Transaksi.fromJson(Map<String, dynamic> json) => Transaksi(
    id: json['id'],
    deskripsi: json['deskripsi'],
    jumlah: json['jumlah'],
    tipe: json['tipe'],
    kategori: json['kategori'],
    tanggal: DateTime.parse(json['tanggal']),
  );
}
