import 'package:shared_preferences/shared_preferences.dart';

class Progress {
  static SharedPreferences? _p;

  static Future<void> init() async {
    _p = await SharedPreferences.getInstance();
  }

  static int get totalStars => _p?.getInt('total_stars') ?? 0;

  static bool isPuzzleDone(int puzzleId) =>
      _p?.getBool('done_$puzzleId') ?? false;

  static int puzzleStars(int puzzleId) =>
      _p?.getInt('pstars_$puzzleId') ?? 0;

  static Future<void> completePuzzle(int puzzleId, int stars) async {
    if (_p == null) return;
    final wasDone  = isPuzzleDone(puzzleId);
    final oldStars = puzzleStars(puzzleId);

    await _p!.setBool('done_$puzzleId', true);

    if (!wasDone) {
      await _p!.setInt('pstars_$puzzleId', stars);
      await _p!.setInt('total_stars', totalStars + stars);
    } else if (stars > oldStars) {
      await _p!.setInt('pstars_$puzzleId', stars);
      await _p!.setInt('total_stars', totalStars + (stars - oldStars));
    }
  }
}
