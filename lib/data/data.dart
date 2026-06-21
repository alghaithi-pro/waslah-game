import '../models/models.dart';

// ─── المجموعة الأولى: سهل ────────────────────────────────────────────────────

const _g1 = WordSearchGroup(
  id: 1,
  name: 'سهل',
  starsRequired: 0,
  levels: [
    WordSearchLevel(
      id: 101,
      name: 'حيوانات البر',
      difficulty: Difficulty.easy,
      rows: 8, cols: 8,
      words: [
        WordPlacement(word: 'أسد', clue: 'ملك الغابة', row: 1, col: 0, horizontal: true),
        WordPlacement(word: 'قرد', clue: 'حيوان يشبه الإنسان', row: 2, col: 0, horizontal: false),
        WordPlacement(word: 'نمر', clue: 'حيوان مخطط سريع', row: 0, col: 5, horizontal: false),
        WordPlacement(word: 'فيل', clue: 'أكبر حيوان بري', row: 3, col: 3, horizontal: true),
        WordPlacement(word: 'ذئب', clue: 'يعيش في الأحراش ويعوي', row: 5, col: 2, horizontal: true),
        WordPlacement(word: 'حصان', clue: 'حيوان يُركب ويسابق', row: 7, col: 0, horizontal: true),
      ],
    ),
    WordSearchLevel(
      id: 102,
      name: 'فواكه',
      difficulty: Difficulty.easy,
      rows: 8, cols: 8,
      words: [
        WordPlacement(word: 'موز', clue: 'فاكهة صفراء طويلة', row: 0, col: 0, horizontal: true),
        WordPlacement(word: 'عنب', clue: 'يصنع منه الزبيب', row: 0, col: 4, horizontal: false),
        WordPlacement(word: 'تين', clue: 'ذُكرت في القرآن الكريم', row: 3, col: 5, horizontal: true),
        WordPlacement(word: 'رمان', clue: 'فاكهة حمراء كثيرة البذور', row: 2, col: 1, horizontal: false),
        WordPlacement(word: 'خوخ', clue: 'فاكهة ناعمة وردية اللون', row: 6, col: 3, horizontal: true),
        WordPlacement(word: 'تمر', clue: 'ثمرة النخلة', row: 7, col: 5, horizontal: true),
      ],
    ),
    WordSearchLevel(
      id: 103,
      name: 'ألوان',
      difficulty: Difficulty.easy,
      rows: 8, cols: 8,
      words: [
        WordPlacement(word: 'أحمر', clue: 'لون الدم والورد', row: 0, col: 0, horizontal: true),
        WordPlacement(word: 'أزرق', clue: 'لون السماء والبحر', row: 0, col: 5, horizontal: false),
        WordPlacement(word: 'أسود', clue: 'لون الليل والفحم', row: 2, col: 0, horizontal: true),
        WordPlacement(word: 'أبيض', clue: 'لون الثلج والحليب', row: 3, col: 2, horizontal: false),
        WordPlacement(word: 'أخضر', clue: 'لون الأشجار والعشب', row: 5, col: 4, horizontal: true),
        WordPlacement(word: 'بني', clue: 'لون التراب والخشب', row: 7, col: 0, horizontal: true),
      ],
    ),
  ],
);

// ─── المجموعة الثانية: متوسط ──────────────────────────────────────────────────

const _g2 = WordSearchGroup(
  id: 2,
  name: 'متوسط',
  starsRequired: 6,
  levels: [
    WordSearchLevel(
      id: 201,
      name: 'دول عربية',
      difficulty: Difficulty.medium,
      rows: 8, cols: 8,
      words: [
        WordPlacement(word: 'مصر', clue: 'بلد الأهرامات والنيل', row: 0, col: 0, horizontal: true),
        WordPlacement(word: 'قطر', clue: 'ضيّفت كأس العالم 2022', row: 0, col: 4, horizontal: false),
        WordPlacement(word: 'عمان', clue: 'سلطنة جنوب شرق الجزيرة', row: 3, col: 0, horizontal: true),
        WordPlacement(word: 'يمن', clue: 'جمهورية في جنوب الجزيرة العربية', row: 1, col: 7, horizontal: false),
        WordPlacement(word: 'ليبيا', clue: 'أكبر دول شمال أفريقيا', row: 5, col: 1, horizontal: true),
        WordPlacement(word: 'كويت', clue: 'دولة خليجية غنية بالنفط', row: 0, col: 6, horizontal: false),
      ],
    ),
    WordSearchLevel(
      id: 202,
      name: 'رياضة',
      difficulty: Difficulty.medium,
      rows: 8, cols: 8,
      words: [
        WordPlacement(word: 'كرة', clue: 'أكثر الألعاب شعبية في العالم', row: 0, col: 0, horizontal: true),
        WordPlacement(word: 'سباحة', clue: 'رياضة مائية للجسم كله', row: 0, col: 4, horizontal: false),
        WordPlacement(word: 'جري', clue: 'أبسط الرياضات وأقدمها', row: 2, col: 0, horizontal: true),
        WordPlacement(word: 'تنس', clue: 'رياضة المضرب والكرة الصفراء', row: 0, col: 7, horizontal: false),
        WordPlacement(word: 'غوص', clue: 'النزول تحت الماء', row: 5, col: 2, horizontal: true),
        WordPlacement(word: 'رمي', clue: 'إطلاق شيء بقوة نحو هدف', row: 7, col: 5, horizontal: true),
      ],
    ),
    WordSearchLevel(
      id: 203,
      name: 'مهن',
      difficulty: Difficulty.medium,
      rows: 8, cols: 8,
      words: [
        WordPlacement(word: 'طبيب', clue: 'يعالج المرضى ويصف الدواء', row: 0, col: 0, horizontal: true),
        WordPlacement(word: 'معلم', clue: 'يُعلّم الطلاب في المدرسة', row: 0, col: 5, horizontal: false),
        WordPlacement(word: 'طيار', clue: 'يقود الطائرة في السماء', row: 3, col: 0, horizontal: true),
        WordPlacement(word: 'محامي', clue: 'يدافع عن موكله أمام المحكمة', row: 2, col: 7, horizontal: false),
        WordPlacement(word: 'شرطي', clue: 'يحفظ الأمن والنظام', row: 6, col: 2, horizontal: true),
      ],
    ),
  ],
);

// ─── المجموعة الثالثة: صعب ───────────────────────────────────────────────────

const _g3 = WordSearchGroup(
  id: 3,
  name: 'صعب',
  starsRequired: 15,
  levels: [
    WordSearchLevel(
      id: 301,
      name: 'علوم',
      difficulty: Difficulty.hard,
      rows: 8, cols: 8,
      words: [
        WordPlacement(word: 'نواة', clue: 'مركز الذرة الذي يحوي البروتونات', row: 0, col: 0, horizontal: true),
        WordPlacement(word: 'غاز', clue: 'مادة لا لون لها ولا شكل ثابت', row: 0, col: 5, horizontal: false),
        WordPlacement(word: 'ذرة', clue: 'أصغر وحدة في المادة', row: 2, col: 0, horizontal: true),
        WordPlacement(word: 'طاقة', clue: 'القدرة على بذل الشغل والحركة', row: 3, col: 3, horizontal: false),
        WordPlacement(word: 'ضوء', clue: 'يسير بأسرع سرعة في الكون', row: 4, col: 5, horizontal: true),
        WordPlacement(word: 'حرارة', clue: 'ما تشعر به عند الاقتراب من النار', row: 7, col: 1, horizontal: true),
      ],
    ),
    WordSearchLevel(
      id: 302,
      name: 'جغرافيا',
      difficulty: Difficulty.hard,
      rows: 8, cols: 8,
      words: [
        WordPlacement(word: 'نيل', clue: 'أطول أنهار العالم', row: 0, col: 0, horizontal: true),
        WordPlacement(word: 'فرات', clue: 'نهر يجري في العراق وسوريا', row: 0, col: 4, horizontal: false),
        WordPlacement(word: 'دجلة', clue: 'نهر عراقي يلتقي بالفرات', row: 3, col: 0, horizontal: true),
        WordPlacement(word: 'صحراء', clue: 'منطقة قاحلة قليلة الأمطار', row: 0, col: 7, horizontal: false),
        WordPlacement(word: 'جبال', clue: 'تضاريس شاهقة الارتفاع', row: 6, col: 2, horizontal: true),
      ],
    ),
    WordSearchLevel(
      id: 303,
      name: 'تاريخ إسلامي',
      difficulty: Difficulty.hard,
      rows: 8, cols: 8,
      words: [
        WordPlacement(word: 'عمر', clue: 'ثاني الخلفاء الراشدين', row: 0, col: 0, horizontal: true),
        WordPlacement(word: 'علي', clue: 'رابع الخلفاء وابن عم النبي ﷺ', row: 0, col: 5, horizontal: false),
        WordPlacement(word: 'خالد', clue: 'سيف الله المسلول', row: 3, col: 1, horizontal: true),
        WordPlacement(word: 'طارق', clue: 'فاتح الأندلس', row: 1, col: 7, horizontal: false),
        WordPlacement(word: 'سيف', clue: 'سلاح حاد من الحديد', row: 5, col: 3, horizontal: true),
        WordPlacement(word: 'بلال', clue: 'أول مؤذن في الإسلام', row: 7, col: 0, horizontal: true),
      ],
    ),
  ],
);

const allGroups = [_g1, _g2, _g3];
