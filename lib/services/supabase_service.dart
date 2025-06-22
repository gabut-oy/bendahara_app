import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/transaksi_model.dart';

class SupabaseService {
  final client = Supabase.instance.client;

  Future<List<Transaksi>> getTransaksi() async {
    final response = await client.from('transaksi').select().order('tanggal');
    return response.map((t) => Transaksi.fromJson(t)).toList().cast<Transaksi>();
  }

  Future<void> tambahTransaksi(Map<String, dynamic> data) async {
    await client.from('transaksi').insert(data);
  }

  Future<void> hapusTransaksi(String id) async {
    await client.from('transaksi').delete().eq('id', id);
  }
}
