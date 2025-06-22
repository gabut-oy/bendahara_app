import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../services/supabase_service.dart';

class TransaksiFormPage extends StatefulWidget {
  const TransaksiFormPage({super.key});
  @override
  State<TransaksiFormPage> createState() => _TransaksiFormPageState();
}

class _TransaksiFormPageState extends State<TransaksiFormPage> {
  final deskripsiCtrl = TextEditingController();
  final jumlahCtrl = TextEditingController();
  String tipe = 'masuk';
  String kategori = 'Lainnya';
  final service = SupabaseService();

  void simpan() async {
    final data = {
      'id': const Uuid().v4(),
      'deskripsi': deskripsiCtrl.text,
      'jumlah': int.tryParse(jumlahCtrl.text) ?? 0,
      'tipe': tipe,
      'kategori': kategori,
      'tanggal': DateTime.now().toIso8601String(),
    };
    await service.tambahTransaksi(data);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Transaksi")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: deskripsiCtrl, decoration: const InputDecoration(labelText: 'Deskripsi')),
            TextField(controller: jumlahCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Jumlah')),
            DropdownButtonFormField<String>(
              value: tipe,
              onChanged: (val) => setState(() => tipe = val!),
              items: ['masuk', 'keluar'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            ),
            DropdownButtonFormField<String>(
              value: kategori,
              onChanged: (val) => setState(() => kategori = val!),
              items: ['Sewa', 'Upah', 'Penjualan', 'Lainnya'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: simpan, child: const Text("Simpan")),
          ],
        ),
      ),
    );
  }
}
