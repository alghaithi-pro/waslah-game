import '../models/puzzle.dart';

// ─── Pack 1: المبتدئ ──────────────────────────────────────────────────────────

// Puzzle 1
// Grid (9×9), across = RTL (startCol = rightmost letter), down = top→bottom
//
//  row\col  3  4  5  6  7
//    2       ء  ا  م  س      سماء أفقي (1)
//    3          ل  ص  ف      فصل  أفقي (2) + سفر رأسي (1)
//    4       ع  ي  ب  ر      ربيع أفقي (3)
//    5       ل               علم  رأسي (4)
//    6    ل  م  أ            أمل  أفقي (5) + لهو رأسي (6)
//    7    ه
//    8    و
const _p1 = CrosswordPuzzle(
  id: 1, title: 'لغز ١', gridRows: 9, gridCols: 9,
  clues: [
    CrosswordClue(number: 1, direction: ClueDir.across,
        startRow: 2, startCol: 7, answer: 'سماء', clue: 'ما يعلو فوق الأرض'),
    CrosswordClue(number: 1, direction: ClueDir.down,
        startRow: 2, startCol: 7, answer: 'سفر',  clue: 'الرحيل إلى مكان بعيد'),
    CrosswordClue(number: 2, direction: ClueDir.across,
        startRow: 3, startCol: 7, answer: 'فصل',  clue: 'جزء من السنة أو الكتاب'),
    CrosswordClue(number: 3, direction: ClueDir.across,
        startRow: 4, startCol: 7, answer: 'ربيع', clue: 'فصل الأزهار والنور'),
    CrosswordClue(number: 4, direction: ClueDir.down,
        startRow: 4, startCol: 4, answer: 'علم',  clue: 'المعرفة والدراسة'),
    CrosswordClue(number: 5, direction: ClueDir.across,
        startRow: 6, startCol: 5, answer: 'أمل',  clue: 'التطلع للمستقبل'),
    CrosswordClue(number: 6, direction: ClueDir.down,
        startRow: 6, startCol: 3, answer: 'لهو',  clue: 'اللعب والمرح'),
  ],
);

// Puzzle 2
//  row\col  2  3  4  5  6
//    1                   ق      قمر رأسي (1)
//    2                   م
//    3          ز  م  ر         رمز أفقي (2)
//    4          م               زمن رأسي (3)
//    5       ر  و  ن            نور أفقي (4)
//    6       أ                  رأي رأسي (5)
//    7       ي
const _p2 = CrosswordPuzzle(
  id: 2, title: 'لغز ٢', gridRows: 9, gridCols: 9,
  clues: [
    CrosswordClue(number: 1, direction: ClueDir.down,
        startRow: 1, startCol: 6, answer: 'قمر',  clue: 'يضيء الليل'),
    CrosswordClue(number: 2, direction: ClueDir.across,
        startRow: 3, startCol: 6, answer: 'رمز',  clue: 'علامة تدل على شيء'),
    CrosswordClue(number: 3, direction: ClueDir.down,
        startRow: 3, startCol: 4, answer: 'زمن',  clue: 'الوقت والعصر'),
    CrosswordClue(number: 4, direction: ClueDir.across,
        startRow: 5, startCol: 4, answer: 'نور',  clue: 'الضوء والإشراق'),
    CrosswordClue(number: 5, direction: ClueDir.down,
        startRow: 5, startCol: 2, answer: 'رأي',  clue: 'وجهة النظر'),
  ],
);

// Puzzle 3
//  row\col  3  4  5  6  7
//    1             ر  ح  ب      بحر أفقي (1)
//    2                   ر      برج رأسي (1)
//    3          ل  م  ج         جمل أفقي (2)
//    4             و            لون رأسي (3)
//    5       ت  ب  ن            نبت أفقي (4)
//    6       ي                  تين رأسي (5)
//    7       ن
const _p3 = CrosswordPuzzle(
  id: 3, title: 'لغز ٣', gridRows: 9, gridCols: 9,
  clues: [
    CrosswordClue(number: 1, direction: ClueDir.across,
        startRow: 1, startCol: 7, answer: 'بحر',  clue: 'مياه مالحة شاسعة'),
    CrosswordClue(number: 1, direction: ClueDir.down,
        startRow: 1, startCol: 7, answer: 'برج',  clue: 'بناء شاهق مرتفع'),
    CrosswordClue(number: 2, direction: ClueDir.across,
        startRow: 3, startCol: 7, answer: 'جمل',  clue: 'حيوان الصحراء'),
    CrosswordClue(number: 3, direction: ClueDir.down,
        startRow: 3, startCol: 5, answer: 'لون',  clue: 'الأحمر والأزرق وغيرهما'),
    CrosswordClue(number: 4, direction: ClueDir.across,
        startRow: 5, startCol: 5, answer: 'نبت',  clue: 'ما ينمو من الأرض'),
    CrosswordClue(number: 5, direction: ClueDir.down,
        startRow: 5, startCol: 3, answer: 'تين',  clue: 'فاكهة ذُكرت في القرآن'),
  ],
);

// ─── Pack 2: المتوسط ──────────────────────────────────────────────────────────

// Puzzle 4
//  row\col  3  4  5  6  7
//    2             ب  ل  ق      قلب أفقي (1)
//    3                   ل      قلم رأسي (1)
//    4             ف  ل  م      ملف أفقي (2)
//    5             أ            فأس رأسي (3)
//    6    ك  م  س               سمك أفقي (4)
//    7    و                     كوب رأسي (5)
//    8    ب
const _p4 = CrosswordPuzzle(
  id: 4, title: 'لغز ٤', gridRows: 9, gridCols: 9,
  clues: [
    CrosswordClue(number: 1, direction: ClueDir.across,
        startRow: 2, startCol: 7, answer: 'قلب',  clue: 'عضو يضخ الدم'),
    CrosswordClue(number: 1, direction: ClueDir.down,
        startRow: 2, startCol: 7, answer: 'قلم',  clue: 'أداة الكتابة'),
    CrosswordClue(number: 2, direction: ClueDir.across,
        startRow: 4, startCol: 7, answer: 'ملف',  clue: 'وثيقة تحفظ البيانات'),
    CrosswordClue(number: 3, direction: ClueDir.down,
        startRow: 4, startCol: 5, answer: 'فأس',  clue: 'أداة لقطع الأشجار'),
    CrosswordClue(number: 4, direction: ClueDir.across,
        startRow: 6, startCol: 5, answer: 'سمك',  clue: 'حيوان يعيش في الماء'),
    CrosswordClue(number: 5, direction: ClueDir.down,
        startRow: 6, startCol: 3, answer: 'كوب',  clue: 'إناء نشرب فيه'),
  ],
);

// Puzzle 5
//  row\col  3  4  5  6  7
//    1             م  ج  ن      نجم أفقي (1)
//    2                   ه      نهر رأسي (1)
//    3          ل  م  ر         رمل أفقي (2)
//    4          ع               لعب رأسي (3)
//    5    ت  ي  ب               بيت أفقي (4)
//    6    ا                     تاج رأسي (5)
//    7    ج
const _p5 = CrosswordPuzzle(
  id: 5, title: 'لغز ٥', gridRows: 9, gridCols: 9,
  clues: [
    CrosswordClue(number: 1, direction: ClueDir.across,
        startRow: 1, startCol: 7, answer: 'نجم',  clue: 'جرم سماوي يضيء في الليل'),
    CrosswordClue(number: 1, direction: ClueDir.down,
        startRow: 1, startCol: 7, answer: 'نهر',  clue: 'مجرى مائي طبيعي'),
    CrosswordClue(number: 2, direction: ClueDir.across,
        startRow: 3, startCol: 7, answer: 'رمل',  clue: 'تتكون منه الصحراء والشاطئ'),
    CrosswordClue(number: 3, direction: ClueDir.down,
        startRow: 3, startCol: 5, answer: 'لعب',  clue: 'الترفيه والتسلية'),
    CrosswordClue(number: 4, direction: ClueDir.across,
        startRow: 5, startCol: 5, answer: 'بيت',  clue: 'المسكن والمنزل'),
    CrosswordClue(number: 5, direction: ClueDir.down,
        startRow: 5, startCol: 3, answer: 'تاج',  clue: 'يُوضع على رأس الملك'),
  ],
);

// ─── All packs ────────────────────────────────────────────────────────────────
final List<PuzzlePack> allPacks = [
  const PuzzlePack(name: 'المبتدئ', emoji: '⭐', puzzles: [_p1, _p2, _p3]),
  const PuzzlePack(name: 'المتوسط', emoji: '🧠', puzzles: [_p4, _p5]),
];
