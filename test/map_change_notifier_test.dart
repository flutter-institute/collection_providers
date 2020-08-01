import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:collection_providers/collection_providers.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    throw details.exception;
  };

  group('MapChangeNotifier', () {
    test('copies the backing map', () {
      final backer = {
        'first': 1,
        'second': 2,
        'third': 3,
      };
      final model = MapChangeNotifier(backer);
      model.addListener(expectAsync0(() {}, count: 1));

      backer['fourth'] = 4;
      expect(backer, hasLength(4));
      expect(model, hasLength(3));

      model['fifth'] = 5;
      expect(backer, hasLength(4));
      expect(model, hasLength(4));
    });

    test('can manipulate when backed by unmodifiable map', () {
      final model = MapChangeNotifier(Map.unmodifiable({
        'first': 1,
        'second': 2,
        'third': 3,
      }));
      expect(model, hasLength(3));

      model.addListener(expectAsync0(() {}, count: 1));

      model['fourth'] = 4;
      expect(model, hasLength(4));
    });

    group('Single Actions', () {
      test('notifies when a key is added', () {
        final model = MapChangeNotifier();
        model.addListener(expectAsync0(() {}, count: 1));

        model['test'] = true;
        expect(model, hasLength(1));
      });

      test('notifies when a key is updated', () {
        final model = MapChangeNotifier({'test': true});
        model.addListener(expectAsync0(() {}, count: 1));

        model['test'] = false;
        expect(model, hasLength(1));
      });

      test('notifies when a key is removed', () {
        final model = MapChangeNotifier({'test': 'value'});
        model.addListener(expectAsync0(() {}, count: 1));

        final removed = model.remove('test');
        expect(model, isEmpty);
        expect(removed, equals('value'));
      });
    });

    group('Bulk Actions', () {
      test('notifies once for clear', () {
        final model = MapChangeNotifier({'test': true});
        model.addListener(expectAsync0(() {}, count: 1));

        model.clear();
        expect(model, isEmpty);
      });

      test('notifies once for addAll', () {
        final model = MapChangeNotifier({'test': 3});
        model.addListener(expectAsync0(() {}, count: 1));

        model.addAll({
          'first': 1,
          'second': 2,
        });
        expect(model, hasLength(3));
      });

      test('notifies once for updateAll', () {
        final model = MapChangeNotifier({
          'first': 1,
          'second': 2,
        });
        model.addListener(expectAsync0(() {}, count: 1));

        model.updateAll((k, v) => v + 2);
        expect(model, hasLength(2));
        expect(model, containsPair('first', 3));
        expect(model, containsPair('second', 4));
      });

      test('notifies once for addEntries', () {
        final model = MapChangeNotifier({
          'first': 1,
          'second': 2,
        });
        model.addListener(expectAsync0(() {}, count: 1));

        final toAdd = {
          'third': 3,
          'fourth': 4,
        };
        model.addEntries(toAdd.entries);
        expect(model, hasLength(4));
      });

      test('notifies once for removeWhere', () {
        final model = MapChangeNotifier({
          'first': 1,
          'second': 2,
          'third': 3,
          'fourth': 4,
        });
        model.addListener(expectAsync0(() {}, count: 1));

        model.removeWhere((key, value) => key == 'first' || value == 3);
        expect(model.keys, containsAllInOrder(['second', 'fourth']));
      });
    });

    group('Pausable', () {
      test('does not notify when paused synchronous', () async {
        final model = MapChangeNotifier({
          'first': 1,
          'second': 2,
          'third': 3,
        });
        final listener = expectAsync0(() async {}, count: 0);
        model.addListener(listener);

        model.pauseNotifications(() {
          model['fourth'] = 4;
          model.addAll({
            'fifth': 5,
            'sixth': 6,
          });
          model.remove('third');
        });

        // expect(model, hasLength(5));
        await listener;
      });

      test('notifies if the flag is set synchronous', () {
        final model = MapChangeNotifier({
          'first': 1,
          'second': 2,
          'third': 3,
        });
        model.addListener(expectAsync0(() {}, count: 1));

        model.pauseNotifications(() {
          model['fourth'] = 4;
          model.addAll({
            'fifth': 5,
            'sixth': 6,
          });
          model.remove('third');
        }, true);

        expect(model, hasLength(5));
      });

      test('returns a value after pause synchronous', () {
        final model = MapChangeNotifier({
          'first': 1,
          'second': 2,
          'third': 3,
        });
        model.addListener(expectAsync0(() {}, count: 1));

        final valueRemoved = model.pauseNotifications(() {
          model['fourth'] = 4;
          model.addAll({
            'fifth': 5,
            'sixth': 6,
          });
          return model.remove('third');
        }, true);

        expect(valueRemoved, equals(3));
        expect(model, hasLength(5));
      });

      test('does not notify when pause asynchronous', () async {
        final model = MapChangeNotifier({
          'first': 1,
          'second': 2,
          'third': 3,
        });
        model.addListener(expectAsync0(() {}, count: 0));

        await model.pauseNotificationsAsync(() async {
          model['fourth'] = 4;
          model.addAll({
            'fifth': 5,
            'sixth': 6,
          });
          model.remove('third');
        });

        expect(model, hasLength(5));
      });

      test('notifies if the flag is set asynchronous', () async {
        final model = MapChangeNotifier({
          'first': 1,
          'second': 2,
          'third': 3,
        });
        model.addListener(expectAsync0(() {}, count: 1));

        await model.pauseNotificationsAsync(() async {
          model['fourth'] = 4;
          model.addAll({
            'fifth': 5,
            'sixth': 6,
          });
          model.remove('third');
        }, true);

        expect(model, hasLength(5));
      });

      test('returns a value after pause asynchronous', () async {
        final model = MapChangeNotifier({
          'first': 1,
          'second': 2,
          'third': 3,
        });
        model.addListener(expectAsync0(() {}, count: 1));

        final valueRemoved = await model.pauseNotificationsAsync(() async {
          model['fourth'] = 4;
          model.addAll({
            'fifth': 5,
            'sixth': 6,
          });
          return model.remove('third');
        }, true);

        expect(valueRemoved, equals(3));
        expect(model, hasLength(5));
      });
    });
  });
}
