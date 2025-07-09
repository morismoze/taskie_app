import 'package:flutter/foundation.dart';

class CombinedListenable extends ChangeNotifier {
  CombinedListenable(List<Listenable> listenables) {
    for (final listenable in listenables) {
      listenable.addListener(notifyListeners);
    }
  }
}
