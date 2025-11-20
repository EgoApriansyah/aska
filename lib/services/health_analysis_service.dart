import 'package:google_generative_ai/google_generative_ai.dart';

class HealthAnalysisService {
  static const String _apiKey = 'AIzaSyAS1H4mMZbgVqowCH_mYZAmJFh-hfgUPgA'; // Ganti dengan API key Anda
  
  // Gunakan model yang tersedia
  static final GenerativeModel _model = GenerativeModel(
    model: 'gemini-1.5-flash', // atau 'gemini-pro' jika tersedia
    apiKey: _apiKey,
  );

  // Analisis data kesehatan komprehensif
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
      // Data dummy untuk demo - PAKAI DATA DARI SCREEN
      final dummyData = '''
DATA KESEHATAN ($period):
• Skor Kesehatan: $healthScore/100
• Detak Jantung: $heartRate bpm (Normal: 60-100 bpm)
• Tekanan Darah: $bloodPressure mmHg (Normal: 90-120/60-80) 
• Suhu Tubuh: ${temperature}°C (Normal: 36-37°C)
• Saturasi O2: $oxygenSaturation% (Normal: 95-100%)
• Langkah: $steps steps
• Tidur: ${(sleepMinutes / 60).toStringAsFixed(1)} jam
• Level Stres: $stressLevel/10

HASIL ANALISIS:
''';

      final prompt = '''
Sebagai asisten kesehatan AI, analisis data kesehatan berikut:

$dummyData

Berikan analisis dalam bahasa Indonesia dengan format:
1. **Status Kesehatan Keseluruhan**
2. **Pencapaian Positif**
3. **Area Perbaikan** 
4. **Rekomendasi Spesifik**

Gunakan tone yang friendly dan motivasional.
''';

      print('Mengirim request ke Gemini...'); // Debug
      
      final content = Content.text(prompt);
      final response = await _model.generateContent([content]);
      
      print('Response diterima dari Gemini'); // Debug
      
      return response.text ?? 'Tidak dapat menganalisis data kesehatan saat ini.';
    } catch (e) {
      print('Error Gemini: $e'); // Debug
      return _getFallbackAnalysis(healthScore, heartRate, steps, sleepMinutes);
    }
  }

  // Fallback analysis jika Gemini error
  static String _getFallbackAnalysis(int healthScore, int heartRate, int steps, int sleepMinutes) {
    final sleepHours = sleepMinutes / 60;
    
    String status = '';
    if (healthScore >= 80) {
      status = '💪 **Status Kesehatan Keseluruhan**\nKondisi kesehatan Anda sangat baik! Skor $healthScore/100 menunjukkan performa yang optimal.';
    } else if (healthScore >= 60) {
      status = '👍 **Status Kesehatan Keseluruhan**\nKesehatan Anda dalam kondisi baik, masih ada ruang untuk improvement.';
    } else {
      status = '💡 **Status Kesehatan Keseluruhan**\nPerlu perhatian lebih pada kesehatan. Skor $healthScore/100 menunjukkan area yang perlu ditingkatkan.';
    }

    String achievements = '';
    if (heartRate >= 60 && heartRate <= 100) {
      achievements += '• Detak jantung dalam range normal ($heartRate bpm) ✅\n';
    }
    if (steps >= 8000) {
      achievements += '• Aktivitas fisik sangat baik ($steps steps) 🏃\n';
    } else if (steps >= 5000) {
      achievements += '• Aktivitas fisik cukup baik ($steps steps) 👍\n';
    }
    if (sleepHours >= 7) {
      achievements += '• Durasi tidur optimal (${sleepHours.toStringAsFixed(1)} jam) 😴\n';
    }

    String improvements = '';
    if (steps < 5000) {
      improvements += '• Tingkatkan aktivitas fisik, targetkan 8,000 steps/hari\n';
    }
    if (sleepHours < 7) {
      improvements += '• Tambah waktu tidur, idealnya 7-9 jam/hari\n';
    }
    if (improvements.isEmpty) {
      improvements = '• Pertahankan gaya hidup sehat saat ini\n';
    }

    return '''
$status

**Pencapaian Positif**
$achievements
**Area Perbaikan**
$improvements
**Rekomendasi**
1. Terus monitor tanda vital secara rutin
2. Pertahankan konsistensi aktivitas fisik  
3. Perhatikan kualitas tidur dan manajemen stres

*Analisis ini berdasarkan data kesehatan yang tersedia.*
''';
  }
}