import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:collection_providers/collection_providers.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    throw details.exception;
  };

  group('SetChangeNotifier', () {
    test('adding after dispose throws assertion', () {
      final model = SetChangeNotifier();
      model.dispose();
      expect(() => model.add('test'), throwsAssertionError);
    });

    test('copies the backing map', () {
      final backer = {1, 2, 3};
      final model = SetChangeNotifier(backer);
      model.addListener(expectAsync0(() {}, count: 1));

      backer.add(4);
      expect(backer, hasLength(4));
      expect(model, hasLength(3));

      model.add(5);
      expect(backer, hasLength(4));
      expect(model, hasLength(4));
    });

    group('Single Actions', () {
      test('notifies when value added', () {
        final model = SetChangeNotifier();
        model.addListener(expectAsync0(() {}, count: 1));

        model.add('this is only a test');
        expect(model, hasLength(1));
      });

      test('does not notify if value is already present', () {
        final model = SetChangeNotifier({'here'});
        model.addListener(expectAsync0(() {}, count: 0));

        model.add('here');
        expect(model, hasLength(1));
      });

      test('notifies when a value is removed', () {
        final model = SetChangeNotifier({1, 2, 3});
        model.addListener(expectAsync0(() {}, count: 1));

        model.remove(2);
        expect(model, hasLength(2));
        expect(model, containsAll([1, 3]));
      });

      test('does not notify when a value is removed that is not present', () {
        final model = SetChangeNotifier({1, 2, 3});
        model.addListener(expectAsync0(() {}, count: 0));

        model.remove(5);
        expect(model, hasLength(3));
      });
    });

    group('Bulk Actions', () {
      test('notifies once for addAll', () {
        final model = SetChangeNotifier({1, 2, 3});
        model.addListener(expectAsync0(() {}, count: 1));

        model.addAll([4, 5, 6]);
        expect(model, hasLength(6));
        expect(model, containsAllInOrder([1, 2, 3, 4, 5, 6]));
      });

      test('notifies once for addAll even if duplicates', () {
        final model = SetChangeNotifier({1, 2, 3});
        model.addListener(expectAsync0(() {}, count: 1));

        model.addAll([1, 2, 3]);
        expect(model, hasLength(3));
      });

      test('notifies once for removeAll', () {
        final model = SetChangeNotifier({1, 2, 3});
        model.addListener(expectAsync0(() {}, count: 1));

        model.removeAll([2, 3, 4]);
        expect(model, hasLength(1));
        expect(model, contains(1));
      });

      test('notifies once for retainAll', () {
        final model = SetChangeNotifier({1, 2, 4, 3, 5});
        model.addListener(expectAsync0(() {}, count: 1));

        model.retainAll([2, 3, 4]);
        expect(model, hasLength(3));
        expect(model, containsAllInOrder([2, 4, 3]));
      });

      test('notifies once for removeWhere', () {
        final model = SetChangeNotifier({1, 2, 3, 4, 5});
        model.addListener(expectAsync0(() {}, count: 1));

        model.removeWhere((element) => element > 3);
        expect(model, hasLength(3));
        expect(model, containsAllInOrder([1, 2, 3]));
      });

      test('notifies once for retainWhere', () {
        final model = SetChangeNotifier({1, 2, 3, 4, 5});
        model.addListener(expectAsync0(() {}, count: 1));

        model.retainWhere((element) => element > 3);
        expect(model, hasLength(2));
        expect(model, containsAllInOrder([4, 5]));
      });

      test('notifies once for clear', () {
        final model = SetChangeNotifier({1, 2, 3, 4, 5});
        model.addListener(expectAsync0(() {}, count: 1));

        model.clear();
        expect(model, isEmpty);
      });
    });

    group('Set Operations', () {
      test('expected return from lookup', () {
        final model = SetChangeNotifier({1, 2, 3});
        expect(model.lookup(3), equals(3));
        expect(model.lookup(5), isNull);
      });

      test('expected return from toSet', () {
        final model = SetChangeNotifier({1, 2, 3});
        final other = model.toSet();

        expect(other, hasLength(3));
        expect(other, containsAllInOrder([1, 2, 3]));

        // They can be modified independently
        model.add(4);
        expect(model, hasLength(4));
        expect(model, contains(4));
        expect(other, hasLength(3));

        other.add(5);
        expect(other, hasLength(4));
        expect(other, contains(5));
        expect(model, hasLength(4));
      });
    });

    group('Pausable', () {
      test('does not notify when paused synchronous', () {
        final model = SetChangeNotifier({1, 2, 3});
        model.addListener(expectAsync0(() {}, count: 0));

        model.pauseNotifications(() {
          model.add(4);
          model.addAll([5, 6]);
          model.remove(3);
        });

        expect(model, hasLength(5));
      });

      test('notifies if the flag is set synchronous', () {
        final model = SetChangeNotifier({1, 2, 3});
        model.addListener(expectAsync0(() {}, count: 1));

        model.pauseNotifications(() {
          model.add(4);
          model.addAll([5, 6]);
          model.remove(3);
        }, true);

        expect(model, hasLength(5));
      });

      test('returns a value after pause synchronous', () {
        final model = SetChangeNotifier({1, 2, 3});
        model.addListener(expectAsync0(() {}, count: 1));

        final valueRemoved = model.pauseNotifications(() {
          model.add(4);
          model.addAll([5, 6]);
          return model.remove(3);
        }, true);

        expect(valueRemoved, isTrue);
        expect(model, hasLength(5));
      });

      test('does not notify when pause asynchronous', () async {
        final model = SetChangeNotifier({1, 2, 3});
        model.addListener(expectAsync0(() {}, count: 0));

        await model.pauseNotificationsAsync(() async {
          model.add(4);
          model.addAll([5, 6]);
          model.remove(3);
        });

        expect(model, hasLength(5));
      });

      test('notifies if the flag is set asynchronous', () async {
        final model = SetChangeNotifier({1, 2, 3});
        model.addListener(expectAsync0(() {}, count: 1));

        await model.pauseNotificationsAsync(() async {
          model.add(4);
          model.addAll([5, 6]);
          model.remove(3);
        }, true);

        expect(model, hasLength(5));
      });

      test('returns a value after pause asynchronous', () async {
        final model = SetChangeNotifier({1, 2, 3});
        model.addListener(expectAsync0(() {}, count: 1));

        final valueRemoved = await model.pauseNotificationsAsync(() async {
          model.add(4);
          model.addAll([5, 6]);
          return model.remove(3);
        }, true);

        expect(valueRemoved, isTrue);
        expect(model, hasLength(5));
      });
    });
  });
}
