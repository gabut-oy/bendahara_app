import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../models/transaksi_model.dart';
import 'transaksi_form_page.dart';

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
      pemasukan = transaksi.where((e) => e.tipe == 'masuk').fold(0, (a, b) => a + b.jumlah);
      pengeluaran = transaksi.where((e) => e.tipe == 'keluar').fold(0, (a, b) => a + b.jumlah);
    });
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
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const TransaksiFormPage()));
          loadData();
        },
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blue,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Saldo Juni 2025", style: const TextStyle(color: Colors.white)),
                Text("Rp $saldo", style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Pemasukan: Rp $pemasukan", style: const TextStyle(color: Colors.white)),
                    Text("Pengeluaran: Rp $pengeluaran", style: const TextStyle(color: Colors.white)),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: transaksi.isEmpty
              ? const Center(child: Text("Belum ada transaksi"))
              : ListView.builder(
                  itemCount: transaksi.length,
                  itemBuilder: (_, i) => ListTile(
                    title: Text(transaksi[i].deskripsi),
                    subtitle: Text(transaksi[i].kategori),
                    trailing: Text("Rp ${transaksi[i].jumlah}"),
                  ),
                ),
          )
        ],
      ),
    );
  }
}
