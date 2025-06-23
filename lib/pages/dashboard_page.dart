import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../models/transaksi_model.dart';
import 'transaksi_form_page.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Transaksi> transaksi = [];
  int pemasukan = 0;
  int pengeluaran = 0;

  final service = SupabaseService();

  void loadData() async {
    transaksi = await service.getTransaksi();
    setState(() {
      pemasukan = transaksi
          .where((e) => e.tipe == 'masuk')
          .fold(0, (a, b) => a + b.jumlah);
      pengeluaran = transaksi
          .where((e) => e.tipe == 'keluar')
          .fold(0, (a, b) => a + b.jumlah);
    });
  }

 void editTransaksi(Transaksi trx) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => TransaksiFormPage(
        transaksi: trx, // kirim data transaksi yang mau diedit
        editTransaksi: (updatedTrx) {
          // Callback setelah transaksi diedit
          setState(() {
            // Bisa dipakai untuk refresh UI lokal jika perlu
          });
        },
      ),
    ),
  );
  loadData(); // Refresh data dari Supabase
}

  void hapusTransaksi(String id) async {
    await service.hapusTransaksi(id);
    loadData();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    final saldo = pemasukan - pengeluaran;

    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard Keuangan")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TransaksiFormPage()),
          );
          loadData();
        },
      ),
      body: Column(
        children: [
          // Header saldo
          Container(
            color: Colors.blue.shade600,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Saldo Bulan Ini",
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
                const SizedBox(height: 8),
                Text("Rp $saldo",
                    style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Pemasukan: Rp $pemasukan",
                        style: const TextStyle(color: Colors.white)),
                    Text("Pengeluaran: Rp $pengeluaran",
                        style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Daftar transaksi
          Expanded(
            child: transaksi.isEmpty
                ? const Center(child: Text("Belum ada transaksi"))
                : ListView.builder(
                    itemCount: transaksi.length,
                    itemBuilder: (_, i) {
                      final item = transaksi[i];
                      final isMasuk = item.tipe == 'masuk';
                      final icon = isMasuk ? Icons.arrow_downward : Icons.arrow_upward;
                      final iconColor = isMasuk ? Colors.green : Colors.red;
                      final jumlahFormatted =
                          NumberFormat("#,##0", "id_ID").format(item.jumlah);
                      final tanggalFormatted =
                          DateFormat("dd MMM yyyy").format(item.tanggal);
                      final waktuFormatted = item.waktu;

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: iconColor.withOpacity(0.1),
                          child: Icon(icon, color: iconColor),
                        ),
                        title: Text(
                          item.catatan ?? '-',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle:
                            Text("${item.kategori} • $tanggalFormatted $waktuFormatted"),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Rp $jumlahFormatted",
                              style: TextStyle(
                                color: iconColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  editTransaksi(item);
                                } else if (value == 'hapus') {
                                  hapusTransaksi(item.id);
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                    value: 'edit', child: Text('Edit')),
                                const PopupMenuItem(
                                    value: 'hapus', child: Text('Hapus')),
                              ],
                              child: const Icon(Icons.more_vert, size: 16),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
