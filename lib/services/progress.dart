import 'package:shared_preferences/shared_preferences.dart';

class Progress {
  Progress._();

  static SharedPreferences? _p;

  static const int _startingCoins    = 50;
  static const int _coinsPerLevel    = 10;
  static const int revealLetterCost  = 5;
  static const int checkErrorsCost   = 3;

  static Future<void> init() async {
    _p = await SharedPreferences.getInstance();
    if (_p?.containsKey('coins') == false) {
      await _p?.setInt('coins', _startingCoins);
    }
  }

  // ── Coins ──────────────────────────────────────────────────────────────────

  static int get coins => _p?.getInt('coins') ?? _startingCoins;

  static Future<void> addCoins(int amount) async =>
      _p?.setInt('coins', coins + amount);

  /// Returns true if coins were deducted, false if insufficient balance.
  static Future<bool> spendCoins(int amount) async {
    if (coins < amount) return false;
    await _p?.setInt('coins', coins - amount);
    return true;
  }

  // ── Level completion ───────────────────────────────────────────────────────

  static bool isLevelDone(int levelId) =>
      _p?.getBool('done_$levelId') ?? false;

  static int levelStars(int levelId) =>
      _p?.getInt('stars_$levelId') ?? 0;

  static Future<void> completeLevel(int levelId, {required int stars}) async {
    if (_p == null) return;
    final wasDone  = isLevelDone(levelId);
    final oldStars = levelStars(levelId);
    await _p!.setBool('done_$levelId', true);
    if (!wasDone) {
      await _p!.setInt('stars_$levelId', stars);
      await addCoins(_coinsPerLevel);
    } else if (stars > oldStars) {
      await _p!.setInt('stars_$levelId', stars);
    }
  }

  // ── Level grid state (letters entered so far) ──────────────────────────────
  // Stored as "row,col=letter|row,col=letter|..."

  static Map<String, String> getLevelState(int levelId) {
    final raw = _p?.getString('state_$levelId');
    if (raw == null || raw.isEmpty) return {};
    final map = <String, String>{};
    for (final entry in raw.split('|')) {
      final idx = entry.indexOf('=');
      if (idx > 0) map[entry.substring(0, idx)] = entry.substring(idx + 1);
    }
    return map;
  }

  static Future<void> saveLevelState(
      int levelId, Map<String, String> state) async {
    final encoded =
        state.entries.map((e) => '${e.key}=${e.value}').join('|');
    await _p?.setString('state_$levelId', encoded);
  }

  static Future<void> clearLevelState(int levelId) async =>
      _p?.remove('state_$levelId');

  // ── Revealed cells (locked by hint) ───────────────────────────────────────

  static Set<String> getRevealedCells(int levelId) {
    final raw = _p?.getString('revealed_$levelId') ?? '';
    if (raw.isEmpty) return {};
    return raw.split('|').toSet();
  }

  static Future<void> addRevealedCell(int levelId, String cellKey) async {
    final current = getRevealedCells(levelId);
    current.add(cellKey);
    await _p?.setString('revealed_$levelId', current.join('|'));
  }

  // ── Total stars ────────────────────────────────────────────────────────────

  static int get totalStars {
    int total = 0;
    final keys = _p?.getKeys() ?? {};
    for (final key in keys) {
      if (key.startsWith('stars_')) total += _p?.getInt(key) ?? 0;
    }
    return total;
  }
}
