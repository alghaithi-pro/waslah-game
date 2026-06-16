import 'dart:math';

class Puzzle {
  final int id;
  final String sentence; // sentence with ____ placeholder
  final String answer;   // the missing word
  final String extras;   // extra distractor letters (as a string)

  const Puzzle({
    required this.id,
    required this.sentence,
    required this.answer,
    required this.extras,
  });

  List<String> get answerLetters =>
      List.generate(answer.length, (i) => answer[i]);

  // answer letters + extras shuffled (seeded so consistent)
  List<String> generatePool() {
    final all = [...answerLetters, ...List.generate(extras.length, (i) => extras[i])];
    all.shuffle(Random(id * 31 + answer.length));
    return all;
  }
}

class Group {
  final int id;
  final String name;
  final int starsRequired;
  final List<Puzzle> puzzles;

  const Group({
    required this.id,
    required this.name,
    required this.starsRequired,
    required this.puzzles,
  });
}
