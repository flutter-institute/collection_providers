import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:collection_providers/collection_providers.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    throw details.exception;
  };

  group('CollectionChangeNotifier', () {
    test('does not notify while paused', () {
      final sut = CollectionChangeNotifier();
      sut.addListener(expectAsync0(() {}, count: 0));

      sut.pauseNotifications(() {
        sut.notifyListeners();
      });
    });

    test('notifies once after pause with flag', () {
      final sut = CollectionChangeNotifier();
      sut.addListener(expectAsync0(() {}, count: 1));

      sut.pauseNotifications(() {
        sut.notifyListeners();
        sut.notifyListeners();
      }, true);
    });

    test('returns a value properly from pause', () {
      final sut = CollectionChangeNotifier();
      sut.addListener(expectAsync0(() {}, count: 1));

      final value = sut.pauseNotifications(() {
        sut.notifyListeners();
        sut.notifyListeners();
        return 'ret';
      }, true);

      expect(value, equals('ret'));
    });

    test('does not notify during nested pausing', () {
      final sut = CollectionChangeNotifier();
      sut.addListener(expectAsync0(() {}, count: 0));

      sut.pauseNotifications(() {
        sut.notifyListeners();
        sut.pauseNotifications(() {
          sut.notifyListeners();
        }, true);
        sut.notifyListeners();
      });
    });

    test('does not notify during nested async pausing', () async {
      final sut = CollectionChangeNotifier();
      sut.addListener(expectAsync0(() {}, count: 0));

      await sut.pauseNotificationsAsync(() async {
        sut.notifyListeners();
        await sut.pauseNotificationsAsync(() async {
          sut.notifyListeners();
        }, true);
        sut.notifyListeners();
      });
    });

    test('does not notify during nested pause during async pause', () async {
      final sut = CollectionChangeNotifier();
      sut.addListener(expectAsync0(() {}, count: 0));

      await sut.pauseNotificationsAsync(() async {
        sut.notifyListeners();
        sut.pauseNotifications(() {
          sut.notifyListeners();
        }, true);
        sut.notifyListeners();
      });
    });

    test('does not notify while async paused', () async {
      final sut = CollectionChangeNotifier();
      sut.addListener(expectAsync0(() {}, count: 0));

      await sut.pauseNotificationsAsync(() async {
        sut.notifyListeners();
      });
    });

    test('notifies once after async pause with flag', () async {
      final sut = CollectionChangeNotifier();
      sut.addListener(expectAsync0(() {}, count: 1));

      await sut.pauseNotificationsAsync(() async {
        sut.notifyListeners();
        sut.notifyListeners();
      }, true);
    });

    test('returns a value properly from async pause', () async {
      final sut = CollectionChangeNotifier();
      sut.addListener(expectAsync0(() {}, count: 1));

      final value = await sut.pauseNotificationsAsync(() {
        sut.notifyListeners();
        sut.notifyListeners();
        return Future.value('ret');
      }, true);

      expect(value, equals('ret'));
    });
  });
}
