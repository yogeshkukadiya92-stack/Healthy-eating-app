import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseRepository {
  SupabaseRepository(this._client);

  final SupabaseClient _client;

  Future<List<Map<String, dynamic>>> searchFoods(String query) {
    return _client
        .from('foods')
        .select()
        .ilike('name', '%$query%')
        .limit(20);
  }

  Future<void> logWater({required String userId, required int amount}) {
    return _client.from('water_logs').insert({
      'user_id': userId,
      'amount': amount,
      'date': DateTime.now().toIso8601String(),
    });
  }

  Future<void> logWeight({
    required String userId,
    required double weight,
    double? bodyFat,
    double? muscleMass,
  }) {
    return _client.from('weight_logs').insert({
      'user_id': userId,
      'weight': weight,
      'body_fat': bodyFat,
      'muscle_mass': muscleMass,
      'date': DateTime.now().toIso8601String(),
    });
  }

  RealtimeChannel subscribeToDailyLogs(String userId) {
    return _client.channel('daily-logs:$userId')
      ..onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'meal_items',
        callback: (_) {},
      )
      ..subscribe();
  }
}
