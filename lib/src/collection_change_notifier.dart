import 'package:flutter/foundation.dart';

typedef AsyncChangeHandler<T> = Future<T> Function();

typedef ChangeHandler<T> = T Function();

class CollectionChangeNotifier extends ChangeNotifier {
  bool _paused = false;

  /// Pause notifications until after an asynchronous handler has completed.
  /// If [notifyAfter] is `true`, then listeners will automatically be notified
  /// after the callback completes. Otherwise, you must notify the listeners;
  Future<T> pauseNotificationsAsync<T>(AsyncChangeHandler<T> handler,
      [bool notifyAfter = false]) async {
    final prevState = _paused;
    _paused = true;

    final result = await handler();
    _paused = prevState;

    if (notifyAfter) {
      notifyListeners();
    }

    return result;
  }

  /// Pause notifications until after a synchronous handler has completed.
  /// If [notifyAfter] is `true`, then listeners will automatically be notified
  /// after the callback completes. Otherwise, you must notify the listeners;
  T pauseNotifications<T>(ChangeHandler<T> handler,
      [bool notifyAfter = false]) {
    final prevState = _paused;
    _paused = true;
    final result = handler();
    _paused = prevState;

    if (notifyAfter) {
      notifyListeners();
    }

    return result;
  }

  /// Notify all the listeners, respecting our paused state falg
  @override
  void notifyListeners() {
    if (!_paused) {
      super.notifyListeners();
    }
  }
}
