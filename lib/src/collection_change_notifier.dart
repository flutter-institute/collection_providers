import 'package:flutter/foundation.dart';

typedef Future<T> AsyncChangeHandler<T>();

typedef T ChangeHandler<T>();

mixin CollectionChangeNotifier on ChangeNotifier {
  bool _paused = false;

  Future<T> pauseNotificationsAsync<T>(AsyncChangeHandler<T> handler,
      [bool notifyAfter = false]) async {
    _paused = true;
    final T result = await handler();
    _paused = false;

    if (notifyAfter) {
      notifyListeners();
    }

    return result;
  }

  T pauseNotifications<T>(ChangeHandler<T> handler,
      [bool notifyAfter = false]) {
    _paused = true;
    final T result = handler();
    _paused = false;

    if (notifyAfter) {
      notifyListeners();
    }

    return result;
  }

  @override
  void notifyListeners() {
    if (!_paused) {
      super.notifyListeners();
    }
  }
}
