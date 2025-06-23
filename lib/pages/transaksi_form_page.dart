import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../services/supabase_service.dart';
import 'package:intl/intl.dart';

class TransaksiFormPage extends StatefulWidget {
  const TransaksiFormPage({super.key});

  @override
  State<TransaksiFormPage> createState() => _TransaksiFormPageState();
}

class _TransaksiFormPageState extends State<TransaksiFormPage> {
  final TextEditingController catatanCtrl = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String jumlah = "";
  String selectedTipe = 'keluar';
  String selectedKategori = 'Makan';

  final List<String> tipeOptions = ['masuk', 'keluar'];
  final List<String> kategoriOptions = [
    'Makan',
    'Transportasi',
    'Belanja',
    'Gaji',
    'Lainnya'
  ];

  void tambahAngka(String angka) {
    setState(() {
      jumlah += angka;
    });
  }

  void hapusAngka() {
    setState(() {
      if (jumlah.isNotEmpty) {
        jumlah = jumlah.substring(0, jumlah.length - 1);
      }
    });
  }

  Future<void> pilihTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> pilihWaktu() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  Future<void> simpanTransaksi() async {
    final uuid = Uuid();
    final tanggalWaktu = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    try {
      await SupabaseService().client.from('transaksi').insert({
        'id': uuid.v4(),
        'jumlah': int.tryParse(jumlah.replaceAll(',', '')) ?? 0,
        'tipe': selectedTipe,
        'kategori': selectedKategori,
        'tanggal': tanggalWaktu.toIso8601String(),
        'waktu': DateFormat('HH:mm').format(tanggalWaktu),
        'catatan': catatanCtrl.text,
      });
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal simpan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tanggalFormatted = DateFormat('dd MMM yyyy').format(selectedDate);
    final waktuFormatted = selectedTime.format(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Tambah Transaksi")),
      body: Column(
        children: [
          // Bagian atas: ikon dan jumlah
          Container(
            color: Colors.blue.shade600,
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.fastfood, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    jumlah.isEmpty ? "0" : jumlah,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 36, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          // Tipe dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Tipe Transaksi',
                prefixIcon: Icon(Icons.swap_vert),
              ),
              value: selectedTipe,
              items: tipeOptions.map((tipe) {
                return DropdownMenuItem(
                  value: tipe,
                  child: Text(tipe.capitalize()),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) setState(() => selectedTipe = value);
              },
            ),
          ),

          // Kategori dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Kategori',
                prefixIcon: Icon(Icons.category),
              ),
              value: selectedKategori,
              items: kategoriOptions.map((kategori) {
                return DropdownMenuItem(
                  value: kategori,
                  child: Text(kategori),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) setState(() => selectedKategori = value);
              },
            ),
          ),

          // Informasi tanggal, waktu, dan catatan
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text("Tanggal"),
            subtitle: Text(tanggalFormatted),
            trailing: const Icon(Icons.chevron_right),
            onTap: pilihTanggal,
          ),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text("Waktu"),
            subtitle: Text(waktuFormatted),
            trailing: const Icon(Icons.chevron_right),
            onTap: pilihWaktu,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: catatanCtrl,
              decoration: const InputDecoration(
                labelText: 'Catatan',
                prefixIcon: Icon(Icons.edit),
              ),
            ),
          ),

          const Spacer(),

          // Keyboard angka custom
          Container(
            color: Colors.grey.shade100,
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                for (var row in [
                  ['7', '8', '9', '÷'],
                  ['4', '5', '6', '×'],
                  ['1', '2', '3', '-'],
                  [',', '0', '⌫', '+']
                ])
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: row.map((e) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: e == '⌫' ? Colors.red.shade100 : Colors.white,
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () {
                              if (e == '⌫') {
                                hapusAngka();
                              } else if (int.tryParse(e) != null || e == ',') {
                                tambahAngka(e);
                              }
                            },
                            child: Text(e, style: const TextStyle(fontSize: 20)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () => simpanTransaksi(),
      ),
    );
  }
}

extension StringCasingExtension on String {
  String capitalize() => isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
