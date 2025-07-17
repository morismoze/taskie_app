import 'package:logging/logging.dart';

import '../../../data/repositories/preferences/preferences_repository.dart';

class PreferencesScreenViewModel {
  PreferencesScreenViewModel({
    required PreferencesRepository preferencesRepository,
  }) : _preferencesRepository = preferencesRepository;

  final PreferencesRepository _preferencesRepository;
  final _log = Logger('PreferencesScreenViewModel');
}
