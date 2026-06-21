import 'package:shared_preferences/shared_preferences.dart';

class Progress {
  static SharedPreferences? _p;

  static Future<void> init() async {
    _p = await SharedPreferences.getInstance();
  }

  static int get totalStars => _p?.getInt('total_stars') ?? 0;

  static bool isLevelDone(int levelId) =>
      _p?.getBool('lvl_done_$levelId') ?? false;

  static int levelStars(int levelId) =>
      _p?.getInt('lvl_stars_$levelId') ?? 0;

  static Future<void> completeLevel(int levelId, int stars) async {
    if (_p == null) return;
    final wasDone = isLevelDone(levelId);
    final oldStars = levelStars(levelId);
    await _p!.setBool('lvl_done_$levelId', true);
    if (!wasDone) {
      await _p!.setInt('lvl_stars_$levelId', stars);
      await _p!.setInt('total_stars', totalStars + stars);
    } else if (stars > oldStars) {
      await _p!.setInt('lvl_stars_$levelId', stars);
      await _p!.setInt('total_stars', totalStars + (stars - oldStars));
    }
  }
}
