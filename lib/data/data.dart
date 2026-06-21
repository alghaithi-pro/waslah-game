import '../models/models.dart';

// ─────────────────────────────────────────────────────────────────────────────
// التحقق من صحة التقاطعات:
//   كل حرف في خلية مشتركة بين كلمتين يجب أن يكون نفس الحرف في الكلمتين.
// ─────────────────────────────────────────────────────────────────────────────

// ─── المجموعة الأولى ──────────────────────────────────────────────────────────

const _g1 = CrosswordGroup(
  id: 1,
  name: 'المجموعة الأولى',
  starsRequired: 0,
  levels: [

    // ── المستوى 1 — 5×5 ─────────────────────────────────────────────────────
    // شبكة:
    //   Row 0: ك ت ا ب _
    //   Row 1: أ م _ _ _
    //   Row 2: س ر ب _ _
    // كتاب أفقي (0,0) | كأس عمودي (0,0) | تمر عمودي (0,1) | أمر أفقي (1,0) | سرب أفقي (2,0)
    CrosswordLevel(id: 101, number: 1, rows: 5, cols: 5, words: [
      CrosswordWord(id: 1011, answer: 'كتاب', clueType: ClueType.text,
          clueText: 'تقرأ منه وتتعلم',
          startRow: 0, startCol: 0, direction: WordDirection.horizontal),
      CrosswordWord(id: 1012, answer: 'كأس', clueType: ClueType.text,
          clueText: 'إناء تشرب منه',
          startRow: 0, startCol: 0, direction: WordDirection.vertical),
      CrosswordWord(id: 1013, answer: 'تمر', clueType: ClueType.text,
          clueText: 'ثمرة النخلة',
          startRow: 0, startCol: 1, direction: WordDirection.vertical),
      CrosswordWord(id: 1014, answer: 'أمر', clueType: ClueType.text,
          clueText: 'توجيه يجب تنفيذه',
          startRow: 1, startCol: 0, direction: WordDirection.horizontal),
      CrosswordWord(id: 1015, answer: 'سرب', clueType: ClueType.text,
          clueText: 'مجموعة من الطيور أو الأسماك',
          startRow: 2, startCol: 0, direction: WordDirection.horizontal),
    ]),

    // ── المستوى 2 — 5×5 ─────────────────────────────────────────────────────
    // شبكة:
    //   Row 0: ن ه ل _ _
    //   Row 1: ج ب ل _ _
    //   Row 2: م ط ر _ _
    // نهل أفقي (0,0) | نجم عمودي (0,0) | هبط عمودي (0,1) | جبل أفقي (1,0) | مطر أفقي (2,0)
    CrosswordLevel(id: 102, number: 2, rows: 5, cols: 5, words: [
      CrosswordWord(id: 1021, answer: 'نهل', clueType: ClueType.text,
          clueText: 'شرب حتى ارتوى',
          startRow: 0, startCol: 0, direction: WordDirection.horizontal),
      CrosswordWord(id: 1022, answer: 'نجم', clueType: ClueType.text,
          clueText: 'كوكب يلمع في السماء ليلاً',
          startRow: 0, startCol: 0, direction: WordDirection.vertical),
      CrosswordWord(id: 1023, answer: 'هبط', clueType: ClueType.text,
          clueText: 'نزل من مكان مرتفع',
          startRow: 0, startCol: 1, direction: WordDirection.vertical),
      CrosswordWord(id: 1024, answer: 'جبل', clueType: ClueType.text,
          clueText: 'تضاريس شاهقة الارتفاع',
          startRow: 1, startCol: 0, direction: WordDirection.horizontal),
      CrosswordWord(id: 1025, answer: 'مطر', clueType: ClueType.text,
          clueText: 'قطرات تنزل من السماء',
          startRow: 2, startCol: 0, direction: WordDirection.horizontal),
    ]),

    // ── المستوى 3 — 5×5 ─────────────────────────────────────────────────────
    // شبكة:
    //   Row 0: ك ل ب _ _
    //   Row 1: ت ب ن _ _
    //   Row 2: ب ن ت _ _
    // كلب أفقي (0,0) | كتب عمودي (0,0) | لبن عمودي (0,1) | تبن أفقي (1,0) | بنت أفقي (2,0)
    CrosswordLevel(id: 103, number: 3, rows: 5, cols: 5, words: [
      CrosswordWord(id: 1031, answer: 'كلب', clueType: ClueType.text,
          clueText: 'حيوان أليف معروف بوفائه',
          startRow: 0, startCol: 0, direction: WordDirection.horizontal),
      CrosswordWord(id: 1032, answer: 'كتب', clueType: ClueType.text,
          clueText: 'جمع كتاب',
          startRow: 0, startCol: 0, direction: WordDirection.vertical),
      CrosswordWord(id: 1033, answer: 'لبن', clueType: ClueType.text,
          clueText: 'مشروب أبيض مغذٍّ',
          startRow: 0, startCol: 1, direction: WordDirection.vertical),
      CrosswordWord(id: 1034, answer: 'تبن', clueType: ClueType.text,
          clueText: 'قش يُطعم به المواشي',
          startRow: 1, startCol: 0, direction: WordDirection.horizontal),
      CrosswordWord(id: 1035, answer: 'بنت', clueType: ClueType.text,
          clueText: 'مؤنث الولد',
          startRow: 2, startCol: 0, direction: WordDirection.horizontal),
    ]),

    // ── المستوى 4 — 5×5 ─────────────────────────────────────────────────────
    // شبكة:
    //   Row 0: س م ك _ _
    //   Row 1: ف ق ر _ _
    //   Row 2: ر ص د _ _
    // سمك أفقي (0,0) | سفر عمودي (0,0) | مقص عمودي (0,1) | فقر أفقي (1,0) | رصد أفقي (2,0)
    CrosswordLevel(id: 104, number: 4, rows: 5, cols: 5, words: [
      CrosswordWord(id: 1041, answer: 'سمك', clueType: ClueType.text,
          clueText: 'حيوان يعيش في الماء',
          startRow: 0, startCol: 0, direction: WordDirection.horizontal),
      CrosswordWord(id: 1042, answer: 'سفر', clueType: ClueType.text,
          clueText: 'التنقل من مكان إلى آخر',
          startRow: 0, startCol: 0, direction: WordDirection.vertical),
      CrosswordWord(id: 1043, answer: 'مقص', clueType: ClueType.text,
          clueText: 'أداة للقص',
          startRow: 0, startCol: 1, direction: WordDirection.vertical),
      CrosswordWord(id: 1044, answer: 'فقر', clueType: ClueType.text,
          clueText: 'الحاجة وعدم اليسار',
          startRow: 1, startCol: 0, direction: WordDirection.horizontal),
      CrosswordWord(id: 1045, answer: 'رصد', clueType: ClueType.text,
          clueText: 'المراقبة والمتابعة',
          startRow: 2, startCol: 0, direction: WordDirection.horizontal),
    ]),

    // ── المستوى 5 — 5×5 ─────────────────────────────────────────────────────
    // شبكة:
    //   Row 0: ع ل م _ _
    //   Row 1: م ح ل _ _
    //   Row 2: ل م ح _ _
    // علم أفقي (0,0) | عمل عمودي (0,0) | لحم عمودي (0,1) | محل أفقي (1,0) | لمح أفقي (2,0)
    CrosswordLevel(id: 105, number: 5, rows: 5, cols: 5, words: [
      CrosswordWord(id: 1051, answer: 'علم', clueType: ClueType.text,
          clueText: 'المعرفة والدراسة',
          startRow: 0, startCol: 0, direction: WordDirection.horizontal),
      CrosswordWord(id: 1052, answer: 'عمل', clueType: ClueType.text,
          clueText: 'ما يؤديه الإنسان للكسب',
          startRow: 0, startCol: 0, direction: WordDirection.vertical),
      CrosswordWord(id: 1053, answer: 'لحم', clueType: ClueType.text,
          clueText: 'الجزء العضلي من الحيوان',
          startRow: 0, startCol: 1, direction: WordDirection.vertical),
      CrosswordWord(id: 1054, answer: 'محل', clueType: ClueType.text,
          clueText: 'مكان البيع والشراء',
          startRow: 1, startCol: 0, direction: WordDirection.horizontal),
      CrosswordWord(id: 1055, answer: 'لمح', clueType: ClueType.text,
          clueText: 'رأى شيئاً بسرعة من بعيد',
          startRow: 2, startCol: 0, direction: WordDirection.horizontal),
    ]),

    // ── المستوى 6 — 5×5 ─────────────────────────────────────────────────────
    // شبكة:
    //   Row 0: ق م ح _ _
    //   Row 1: ل د ن _ _
    //   Row 2: م ح ن _ _
    // قمح أفقي (0,0) | قلم عمودي (0,0) | مدح عمودي (0,1) | لدن أفقي (1,0) | محن أفقي (2,0)
    CrosswordLevel(id: 106, number: 6, rows: 5, cols: 5, words: [
      CrosswordWord(id: 1061, answer: 'قمح', clueType: ClueType.text,
          clueText: 'حبوب يُصنع منها الخبز',
          startRow: 0, startCol: 0, direction: WordDirection.horizontal),
      CrosswordWord(id: 1062, answer: 'قلم', clueType: ClueType.text,
          clueText: 'أداة للكتابة',
          startRow: 0, startCol: 0, direction: WordDirection.vertical),
      CrosswordWord(id: 1063, answer: 'مدح', clueType: ClueType.text,
          clueText: 'الثناء والإطراء',
          startRow: 0, startCol: 1, direction: WordDirection.vertical),
      CrosswordWord(id: 1064, answer: 'لدن', clueType: ClueType.text,
          clueText: 'طري وسهل الانحناء',
          startRow: 1, startCol: 0, direction: WordDirection.horizontal),
      CrosswordWord(id: 1065, answer: 'محن', clueType: ClueType.text,
          clueText: 'جمع محنة، شدائد الحياة',
          startRow: 2, startCol: 0, direction: WordDirection.horizontal),
    ]),

    // ── المستوى 7 — 5×5 ─────────────────────────────────────────────────────
    // شبكة:
    //   Row 0: ح ص ن _ _
    //   Row 1: ر ب ح _ _
    //   Row 2: ب ر ج _ _
    // حصن أفقي (0,0) | حرب عمودي (0,0) | صبر عمودي (0,1) | ربح أفقي (1,0) | برج أفقي (2,0)
    CrosswordLevel(id: 107, number: 7, rows: 5, cols: 5, words: [
      CrosswordWord(id: 1071, answer: 'حصن', clueType: ClueType.text,
          clueText: 'مكان محمي بالأسوار',
          startRow: 0, startCol: 0, direction: WordDirection.horizontal),
      CrosswordWord(id: 1072, answer: 'حرب', clueType: ClueType.text,
          clueText: 'نزاع مسلح بين الدول',
          startRow: 0, startCol: 0, direction: WordDirection.vertical),
      CrosswordWord(id: 1073, answer: 'صبر', clueType: ClueType.text,
          clueText: 'التحمل والثبات',
          startRow: 0, startCol: 1, direction: WordDirection.vertical),
      CrosswordWord(id: 1074, answer: 'ربح', clueType: ClueType.text,
          clueText: 'الكسب والفائدة المادية',
          startRow: 1, startCol: 0, direction: WordDirection.horizontal),
      CrosswordWord(id: 1075, answer: 'برج', clueType: ClueType.text,
          clueText: 'بناء شاهق الارتفاع',
          startRow: 2, startCol: 0, direction: WordDirection.horizontal),
    ]),

    // ── المستوى 8 — 5×5 ─────────────────────────────────────────────────────
    // شبكة:
    //   Row 0: د ر ب _ _
    //   Row 1: و م ض _ _
    //   Row 2: ر ح ل _ _
    // درب أفقي (0,0) | دور عمودي (0,0) | رمح عمودي (0,1) | ومض أفقي (1,0) | رحل أفقي (2,0)
    CrosswordLevel(id: 108, number: 8, rows: 5, cols: 5, words: [
      CrosswordWord(id: 1081, answer: 'درب', clueType: ClueType.text,
          clueText: 'طريق ضيق',
          startRow: 0, startCol: 0, direction: WordDirection.horizontal),
      CrosswordWord(id: 1082, answer: 'دور', clueType: ClueType.text,
          clueText: 'جمع دار — بيوت',
          startRow: 0, startCol: 0, direction: WordDirection.vertical),
      CrosswordWord(id: 1083, answer: 'رمح', clueType: ClueType.text,
          clueText: 'سلاح طعن قديم',
          startRow: 0, startCol: 1, direction: WordDirection.vertical),
      CrosswordWord(id: 1084, answer: 'ومض', clueType: ClueType.text,
          clueText: 'برق ولمع بسرعة',
          startRow: 1, startCol: 0, direction: WordDirection.horizontal),
      CrosswordWord(id: 1085, answer: 'رحل', clueType: ClueType.text,
          clueText: 'غادر وانصرف',
          startRow: 2, startCol: 0, direction: WordDirection.horizontal),
    ]),

    // ── المستوى 9 — 5×5 ─────────────────────────────────────────────────────
    // شبكة:
    //   Row 0: ن ف ط _ _
    //   Row 1: ب ت ر _ _
    //   Row 2: ت ح ت _ _
    // نفط أفقي (0,0) | نبت عمودي (0,0) | فتح عمودي (0,1) | بتر أفقي (1,0) | تحت أفقي (2,0)
    CrosswordLevel(id: 109, number: 9, rows: 5, cols: 5, words: [
      CrosswordWord(id: 1091, answer: 'نفط', clueType: ClueType.text,
          clueText: 'سائل أسود يُستخرج من باطن الأرض',
          startRow: 0, startCol: 0, direction: WordDirection.horizontal),
      CrosswordWord(id: 1092, answer: 'نبت', clueType: ClueType.text,
          clueText: 'ظهر وخرج من الأرض',
          startRow: 0, startCol: 0, direction: WordDirection.vertical),
      CrosswordWord(id: 1093, answer: 'فتح', clueType: ClueType.text,
          clueText: 'الغزو والانتصار',
          startRow: 0, startCol: 1, direction: WordDirection.vertical),
      CrosswordWord(id: 1094, answer: 'بتر', clueType: ClueType.text,
          clueText: 'قطع عضواً من الجسم',
          startRow: 1, startCol: 0, direction: WordDirection.horizontal),
      CrosswordWord(id: 1095, answer: 'تحت', clueType: ClueType.text,
          clueText: 'في الجهة السفلى',
          startRow: 2, startCol: 0, direction: WordDirection.horizontal),
    ]),

  ],
);

// ─── المجموعة الثانية (قيد الإعداد) ─────────────────────────────────────────

const _g2 = CrosswordGroup(
  id: 2,
  name: 'المجموعة الثانية',
  starsRequired: 18,
  levels: [],
);

// ─── المجموعة الثالثة (قيد الإعداد) ─────────────────────────────────────────

const _g3 = CrosswordGroup(
  id: 3,
  name: 'المجموعة الثالثة',
  starsRequired: 35,
  levels: [],
);

const List<CrosswordGroup> allGroups = [_g1, _g2, _g3];
