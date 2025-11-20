import 'package:flutter_gemini/flutter_gemini.dart';

class HealthAnalysisService {
  static const String _apiKey = 'AIzaSyAS1H4mMZbgVqowCH_mYZAmJFh-hfgUPgA';
  
  static bool _isInitialized = false;

  static void _initializeGemini() {
    if (!_isInitialized) {
      Gemini.init(apiKey: _apiKey, enableDebugging: true);
      _isInitialized = true;
    }
  }

  static Future<String> generateHealthAnalysis({
    required int healthScore,
    required int heartRate,
    required String bloodPressure,
    required double temperature,
    required int oxygenSaturation,
    required int steps,
    required int sleepMinutes,
    required int stressLevel,
    required String period,
  }) async {
    try {
      _initializeGemini();

      final prompt = '''
Sebagai ahli analisis data kesehatan, berikan analisis singkat dan padat untuk data berikut:

DATA KESEHATAN ($period)
- Skor: $healthScore/100
- Detak Jantung: $heartRate bpm
- Tekanan Darah: $bloodPressure mmHg
- Suhu: ${temperature}°C
- Oksigen: $oxygenSaturation%
- Langkah: $steps steps
- Tidur: ${(sleepMinutes / 60).toStringAsFixed(1)} jam
- Stres: $stressLevel/10

Hanya berikan poin-poin penting tanpa format markdown (tanpa **, ###, [ ], dll). Format yang diinginkan:

KESIMPULAN UTAMA
- Ringkasan kondisi kesehatan
- 2 pencapaian terbaik
- 2 area perhatian

REKOMENDASI PRIORITAS
1. Rekomendasi urgent
2. Rekomendasi jangka menengah  
3. Tips improvement

TARGET 30 HARI
- Target spesifik yang bisa diukur

HARAP TANPA MARKDOWN, HANYA TEKS BIASA DENGAN POIN-POIN.
MAKSIMAL 10-12 BARIS TOTAL. LANGSUNG KE INTI.
''';

      final parts = [Part.text(prompt)];
      final response = await Gemini.instance.prompt(parts: parts);
      
      // Clean up any remaining markdown
      String cleanResponse = response?.output ?? 'Tidak dapat menghasilkan analisis kesehatan. Silakan coba lagi.';
      cleanResponse = cleanResponse
          .replaceAll('**', '')
          .replaceAll('###', '')
          .replaceAll('##', '')
          .replaceAll('[', '')
          .replaceAll(']', '')
          .replaceAll('()', '');
      
      return cleanResponse;
    } catch (e) {
      return 'Error dalam menganalisis data kesehatan: $e';
    }
  }
}