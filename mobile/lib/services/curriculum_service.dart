import '../models/curriculum.dart';

class CurriculumClientService {
  final String baseUrl;

  CurriculumClientService({this.baseUrl = 'http://localhost:8000/api/v1/curriculum/class-1'});

  Future<List<Subject>> fetchClass1Subjects() async {
    // Client-side service layer with mock fallback for Class 1 subjects
    return [
      Subject(
        id: 'sub-eng-c1',
        code: 'english',
        titleEn: 'English Learning',
        titleNative: 'English',
        description: 'Foundational English phonics and sight words for Class 1',
        language: 'en',
        gradeLevel: 1,
        topics: [],
      ),
      Subject(
        id: 'sub-hnd-c1',
        code: 'hindi',
        titleEn: 'Hindi Learning',
        titleNative: 'हिंदी शिक्षण',
        description: 'सीखें स्वर, व्यंजन और शुरुआती शब्द रचना',
        language: 'hi',
        gradeLevel: 1,
        topics: [],
      ),
      Subject(
        id: 'sub-mar-c1',
        code: 'marathi',
        titleEn: 'Marathi Learning',
        titleNative: 'मराठी अध्ययन',
        description: 'मूलभूत मराठी मुळाक्षरे आणि प्राथमिक शब्द',
        language: 'mr',
        gradeLevel: 1,
        topics: [],
      ),
      Subject(
        id: 'sub-mth-c1',
        code: 'mathematics',
        titleEn: 'Mathematics',
        titleNative: 'गणित',
        description: 'Counting, numbers 1 to 20, basic shapes, and spatial understanding',
        language: 'en',
        gradeLevel: 1,
        topics: [],
      ),
      Subject(
        id: 'sub-gk-c1',
        code: 'evs_gk',
        titleEn: 'Environmental Studies & General Knowledge',
        titleNative: 'पर्यावरण व सामान्य ज्ञान',
        description: 'Discovering myself, my family, animals, plants, and safety rules',
        language: 'en',
        gradeLevel: 1,
        topics: [],
      ),
    ];
  }
}
