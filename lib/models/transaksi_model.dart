class Transaksi {
  final String id;
  final String deskripsi;
  final int jumlah;
  final String tipe; // 'masuk' atau 'keluar'
  final String kategori;
  final DateTime tanggal;
  final String waktu;     // tambahan: format 'HH:mm'
  final String? catatan;  // tambahan: bisa null

  Transaksi({
    required this.id,
    required this.deskripsi,
    required this.jumlah,
    required this.tipe,
    required this.kategori,
    required this.tanggal,
    required this.waktu,
    this.catatan,
  });

  factory Transaksi.fromJson(Map<String, dynamic> json) {
    return Transaksi(
      id: json['id'],
      deskripsi: json['deskripsi'],
      jumlah: json['jumlah'],
      tipe: json['tipe'],
      kategori: json['kategori'],
      tanggal: DateTime.parse(json['tanggal']),
      waktu: json['waktu'] ?? '', // fallback kalau kosong
      catatan: json['catatan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deskripsi': deskripsi,
      'jumlah': jumlah,
      'tipe': tipe,
      'kategori': kategori,
      'tanggal': tanggal.toIso8601String(),
      'waktu': waktu,
      'catatan': catatan,
    };
  }
}
