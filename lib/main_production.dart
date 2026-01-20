import 'package:logly/app/app.dart';
import 'package:logly/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
