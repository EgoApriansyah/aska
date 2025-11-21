// lib/services/medicine_service.dart
import 'dart:math';
import 'package:aska/models/facility_model.dart';

class MedicineService {
  // Kumpulan obat yang lebih besar dan realistis
  static const List<String> allMedicines = [
    // Obat Demam & Flu
    'Paracetamol',
    'Ibuprofen',
    'Asam Mefenamat',
    'Amoxicillin',
    'Oxycodone',
    'Dextromethorphan',
    'Pseudoephedrine',
    'Phenylephrine',
    'Loratadine',
    'Fexofenadine',
    'Zinc',
    'Vitamin C',
    'Echinacea',
    'Tolak Angin',
    'Antasida',
    'Dekongestan',
    'Loratadin',
    'Cetirizine',
    'Promethazine',
    'Guaifenesin',
    'Dextromethorphan',
    'Codeine',
    'Bromhexine',
    'Ambroxol',
    'Guaifenesin',
    'Obat Batuk Pilek',
    'Komix',
    'Siladex',
    'Vicks',
    'Bodrex',
    'Procold',
    'Neo Cold',
    'OBH',
    'Sanmol',
    'Komix',
    'Siladex',
    'Vicks',
    'Bodrex',
    'Procold',
    'Neo Cold',
    'OBH',
    'Sanmol',
    // Obat Maag
    'Antasida',
    'Omeprazole',
    'Ranitidine',
    'Famotidine',
    'Lansoprazole',
    'Esomeprazole',
    'Pantoprazole',
    'Sukralfate',
    'Misoprostol',
    'Aluminium Hidroksida',
    'Kalsium Karbonat',
    // Obat Diare
    'Loperamide',
    'Attapulgida',
    'Raceskadotrile',
    'Zinc Sulfate',
    'Kloramfenikol',
    'Nifuroxazide',
    'Ofloksasin',
    'Ciprofloxacin',
    // Obat Alergi
    'Loratadine',
    'Cetirizine',
    'Feksofenadina',
    'Loratadin',
    'Desloratadine',
    'Levosetirizin',
    'Azelastine',
    // Obat Nyeri & Demam
    'Mefenamat Asam',
    'Natrium Diklofenak',
    'Naproxen',
    'Piroksikam',
    'Meloksikam',
    'Celekoksib',
    'Etorikoksib',
    'Indometasin',
    'Ketoprofen',
    'Nabumeton',
    'Tramadol',
    // Vitamin & Suplemen
    'Vitamin A',
    'Vitamin B Kompleks',
    'Vitamin D',
    'Vitamin E',
    'Asam Folat',
    'Zink',
    'Besi',
    'Kalsium',
    'Magnesium',
    'Minyak Ikan (Omega-3)',
    'Koenzim Q10',
    'Probiotik',
    'Ekstrak Teh Hijau',
    'Kurkumin',
    'Gingseng',
    'Tongkat Ali',
    // Obat Kulit
    'Hydrokortison Krim',
    'Krim Antijamur',
    'Salisil Asam',
    'Benzoil Peroksida',
    'Mikonazol',
    'Klotrimazol',
    'Ketoconazol',
    'Terbinafin',
    'Mupirosin',
    'Retinoid',
    'Azelik Asam',
    // Obat Mata
    'Tetra-Hidroksin',
    'Lubricating Eye Drops',
    'Natrium Kromolik',
    'Natrium Fluoresensin',
    'Tobramisin',
    'Gentamisin',
    'Ofloksasin',
    'Moksifloksasin',
    // Obat Tetanus
    'Tetanus Toksoid',
    'Difteri, Pertusis, Tetanus (DPT)',
    'Tetanus Difteri (Td)',
    // Lainnya
    'Betadine',
    'Klorheksidin',
    'Povidone-Iodin',
    'Alkohol 70%',
    'Garam Enceri',
    'Peroksida',
    'Insulin',
    'Metformin',
    'Glibenklamid',
    'Amlodipine',
    'Atorvastatin',
    'Simvastatin',
    'Lisinopril',
    'Losartan',
    'Furosemide',
    'Hidroklorotiazid',
    'Aspilet',
    'Klopidogrel',
    'Warfarin',
    'Allopurinol',
  ];

  /// Menghasilkan daftar obat acak untuk sebuah apotek
  /// Menghasilkan antara 20 hingga 50 obat untuk setiap apotek
  static List<String> generateRandomMedicineList() {
    final random = Random();
    final numberOfMedicines = 20 + random.nextInt(31); // Acak antara 20-50

    // Acak urutan daftar obat
    final shuffledList = List<String>.from(allMedicines)..shuffle(random);

    // Ambil sejumlah obat acak
    return shuffledList.take(numberOfMedicines).toList();
  }

  /// Memeriksa apakah query obat ada di daftar obat umum
  static bool isMedicineQuery(String query) {
    for (var medicine in allMedicines) {
      if (medicine.toLowerCase().contains(query.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  /// Menghitung skor kemungkinan sebuah faskes memiliki obat
  /// Skor ini tidak lagi relevan dengan pendekatan baru, tapi bisa dipertahankan
  static int calculateMedicineLikelihood(Facility facility) {
    switch (facility.type) {
      case 'Apotek':
        return 3; // Sangat Mungkin
      case 'Klinik':
      case 'Klinik Dokter':
      case 'Puskesmas':
        return 2; // Mungkin
      case 'Rumah Sakit':
        return 1; // Kurang Mungkin
      default:
        return 0; // Tidak diketahui
    }
  }
}