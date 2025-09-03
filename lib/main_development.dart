import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:potato4cut/app/app.dart';
import 'package:potato4cut/bootstrap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  await bootstrap(() => const App());
}
