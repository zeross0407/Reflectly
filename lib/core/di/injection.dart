import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

/// Global service locator.
final sl = GetIt.instance;

/// Initialize all dependencies via injectable code generation.
///
/// Call once in `main()`:
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   configureDependencies();
///   runApp(...);
/// }
/// ```
///
/// After adding/removing `@injectable` annotations, run:
/// ```bash
/// flutter pub run build_runner build --delete-conflicting-outputs
/// ```
@InjectableInit(preferRelativeImports: false)
void configureDependencies() => sl.init();
