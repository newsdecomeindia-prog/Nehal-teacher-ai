import '../config/app_config.dart';
import '../models/curriculum.dart';

class CurriculumClientService {
  final String baseUrl;

  CurriculumClientService({String? baseUrl})
      : baseUrl = baseUrl ?? '${AppConfig.baseUrl}/curriculum/class-1';

  Future<List<Subject>> fetchClass1Subjects() async {
    // Client-side service layer with fallback mock for Class 1 subjects
    return [
      Subject(
        id: 'sub-eng-c1',
        code: 'english',
        titleEn: 'English Learning',
        titleNative: 'English',
        description: 'Foundational English phonics, sight words, small words, and simple sentences',
        language: 'en',
        gradeLevel: 1,
        cbseAcademicYear: '2026-27',
        topics: [
          Topic(id: 'top-eng-01', title: 'Alphabet & Phonics', sequenceOrder: 1, subtopics: []),
          Topic(id: 'top-eng-02', title: 'Sight Words Recognition', sequenceOrder: 2, subtopics: []),
          Topic(id: 'top-eng-03', title: 'Small CVC Words', sequenceOrder: 3, subtopics: []),
          Topic(id: 'top-eng-04', title: 'Simple Sentence Reading', sequenceOrder: 4, subtopics: []),
        ],
      ),
      Subject(
        id: 'sub-hnd-c1',
        code: 'hindi',
        titleEn: 'Hindi Learning',
        titleNative: 'हिंदी शिक्षण',
        description: 'वर्णमाला (स्वर, व्यंजन), मात्राएँ, छोटे शब्द और सरल वाक्य पठन',
        language: 'hi',
        gradeLevel: 1,
        cbseAcademicYear: '2026-27',
        topics: [
          Topic(id: 'top-hnd-01', title: 'वर्णमाला (स्वर और व्यंजन)', sequenceOrder: 1, subtopics: []),
          Topic(id: 'top-hnd-02', title: 'मात्राएँ (Matras)', sequenceOrder: 2, subtopics: []),
          Topic(id: 'top-hnd-03', title: 'छोटे अमात्रिक शब्द', sequenceOrder: 3, subtopics: []),
          Topic(id: 'top-hnd-04', title: 'सरल वाक्य पठन', sequenceOrder: 4, subtopics: []),
        ],
      ),
      Subject(
        id: 'sub-mar-c1',
        code: 'marathi',
        titleEn: 'Marathi Learning',
        titleNative: 'मराठी अध्ययन',
        description: 'मूलभूत मराठी मुळाक्षरे आणि प्राथमिक शब्द',
        language: 'mr',
        gradeLevel: 1,
        cbseAcademicYear: '2026-27',
        topics: [
          Topic(id: 'top-mar-01', title: 'मराठी स्वर (Marathi Vowels)', sequenceOrder: 1, subtopics: []),
        ],
      ),
      Subject(
        id: 'sub-mth-c1',
        code: 'mathematics',
        titleEn: 'Mathematics',
        titleNative: 'गणित',
        description: 'Counting, Single-digit Addition, Subtraction, Shapes, Patterns, Spatial Awareness',
        language: 'en',
        gradeLevel: 1,
        cbseAcademicYear: '2026-27',
        topics: [
          Topic(id: 'top-mth-01', title: 'Counting & Numbers 1 to 20', sequenceOrder: 1, subtopics: []),
          Topic(id: 'top-mth-02', title: 'Single-digit Addition', sequenceOrder: 2, subtopics: []),
          Topic(id: 'top-mth-03', title: 'Single-digit Subtraction', sequenceOrder: 3, subtopics: []),
          Topic(id: 'top-mth-04', title: 'Basic 2D & 3D Shapes', sequenceOrder: 4, subtopics: []),
          Topic(id: 'top-mth-05', title: 'Pattern Recognition', sequenceOrder: 5, subtopics: []),
          Topic(id: 'top-mth-06', title: 'Spatial Awareness & Positions', sequenceOrder: 6, subtopics: []),
        ],
      ),
      Subject(
        id: 'sub-gk-c1',
        code: 'evs_gk',
        titleEn: 'Environmental Studies & General Knowledge',
        titleNative: 'पर्यावरण व सामान्य ज्ञान',
        description: 'Discovering myself, my family, animals, plants, and safety rules',
        language: 'en',
        gradeLevel: 1,
        cbseAcademicYear: '2026-27',
        topics: [
          Topic(id: 'top-gk-01', title: 'About Me & My Body', sequenceOrder: 1, subtopics: []),
        ],
      ),
    ];
  }
}
