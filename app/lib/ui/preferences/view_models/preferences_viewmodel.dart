import 'package:logging/logging.dart';

import '../../../data/repositories/preferences/preferences_repository.dart';

class PreferencesViewModel {
  PreferencesViewModel({required PreferencesRepository preferencesRepository})
    : _preferencesRepository = preferencesRepository;

  final PreferencesRepository _preferencesRepository;
  final _log = Logger('PreferencesViewModel');
}
