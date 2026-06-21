import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/progress.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Progress.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const KalimatApp());
}

class KalimatApp extends StatelessWidget {
  const KalimatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'وصلة',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: false),
      builder: (ctx, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child!,
      ),
      home: const HomeScreen(),
    );
  }
}
