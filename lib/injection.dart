import 'package:flutter_ui_utils/injection.config.dart';
import 'package:injectable/injectable.dart';
import 'package:get_it/get_it.dart';

Future? shopBuilderInjection(GetIt getIt) async {
  await _init(getIt);
}

@InjectableInit(
  initializerName: 'flutterUiUtils', // default
)
Future<void> _init(GetIt getIt) async {
  getIt.flutterUiUtils();

  ///inject packages
  // await getIt.get<NotificationLocalDataSource>().ensureInitialized();
  // await getIt.get<SettingLocalDataSource>().ensureInitialized();
}
// gh.lazySingleton<_i4.BaseProfilePage>(() => _i5.Theme3ProfilePage());
