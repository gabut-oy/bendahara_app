import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class TransaksiPage extends StatefulWidget {
  const TransaksiPage({super.key});
  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  final client = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  String? _idEdit;
  final deskripsiCtrl = TextEditingController();
  final jumlahCtrl = TextEditingController();
  String tipe = 'masuk';

  Future<void> _loadData() async {
    final res = await client.from('transaksi').select().order('tanggal');
    setState(() {
      _data = res;
    });
  }

  List<dynamic> _data = [];

  Future<void> _simpan() async {
    final isEdit = _idEdit != null;
    final data = {
      'deskripsi': deskripsiCtrl.text,
      'jumlah': int.parse(jumlahCtrl.text),
      'tipe': tipe,
    };

    if (isEdit) {
      await client.from('transaksi').update(data).eq('id', _idEdit!);
    } else {
      data['id'] = const Uuid().v4();
      await client.from('transaksi').insert(data);
    }

    _resetForm();
    _loadData();
  }

  void _resetForm() {
    deskripsiCtrl.clear();
    jumlahCtrl.clear();
    tipe = 'masuk';
    _idEdit = null;
  }

  Future<void> _hapus(String id) async {
    await client.from('transaksi').delete().eq('id', id);
    _loadData();
  }

  void _isiForm(Map item) {
    deskripsiCtrl.text = item['deskripsi'];
    jumlahCtrl.text = item['jumlah'].toString();
    tipe = item['tipe'];
    _idEdit = item['id'];
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bendahara Desa')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(controller: deskripsiCtrl, decoration: const InputDecoration(labelText: 'Deskripsi')),
                  TextFormField(controller: jumlahCtrl, decoration: const InputDecoration(labelText: 'Jumlah'), keyboardType: TextInputType.number),
                  DropdownButtonFormField<String>(
                    value: tipe,
                    items: ['masuk', 'keluar']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e.toUpperCase())))
                        .toList(),
                    onChanged: (val) => setState(() => tipe = val!),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(onPressed: _simpan, child: Text(_idEdit == null ? 'Tambah' : 'Update')),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _data.length,
                itemBuilder: (ctx, i) {
                  final item = _data[i];
                  return ListTile(
                    title: Text(item['deskripsi']),
                    subtitle: Text('${item['tipe'].toUpperCase()} - Rp${item['jumlah']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.edit), onPressed: () => _isiForm(item)),
                        IconButton(icon: const Icon(Icons.delete), onPressed: () => _hapus(item['id'])),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
