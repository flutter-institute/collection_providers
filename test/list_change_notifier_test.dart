import 'package:flutter_test/flutter_test.dart';
import 'package:collection_providers/collection_providers.dart';

void main() {
  group('ListChangeNotifier', () {
    test('copies the backing list', () {
      final backer = [1, 2, 3];
      final model = ListChangeNotifier(backer);
      model.addListener(expectAsync0(() {}, count: 1));

      backer.add(4);
      expect(backer, hasLength(4));
      expect(model, hasLength(3));

      model.add(5);
      expect(backer, hasLength(4));
      expect(model, hasLength(4));
    });

    test('can manipulate when backed by unmodifiable list', () {
      final model = ListChangeNotifier(List.unmodifiable([1, 2, 3]));
      expect(model, hasLength(3));

      model.addListener(expectAsync0(() {}, count: 1));

      model.add(4);
      expect(model, hasLength(4));
    });

    group('Single Actions', () {
      test('notifies when an element is added', () {
        final model = ListChangeNotifier();
        model.addListener(expectAsync0(() {}, count: 1));

        model.add(1);
      });

      test('notifies when an element is changed', () {
        final model = ListChangeNotifier([1]);
        model.addListener(expectAsync0(() {}, count: 1));

        model[0] = 3;
        expect(model, hasLength(1));
        expect(model[0], equals(3));
      });

      test('notifies when an element is inserted', () {
        final model = ListChangeNotifier([1, 2, 3]);
        model.addListener(expectAsync0(() {}, count: 1));

        model.insert(1, 4);
        expect(model, hasLength(4));
        expect(model, containsAllInOrder([1, 4, 2, 3]));
      });

      test('notifies when an element is removed', () {
        final model = ListChangeNotifier([1, 2, 3]);
        model.addListener(expectAsync0(() {}, count: 1));

        model.removeAt(2);
        expect(model, hasLength(2));
        expect(model, containsAllInOrder([1, 2]));
      });
    });

    group('Bulk Actions', () {
      test('notifies once for addAll', () {
        final model = ListChangeNotifier([1, 2, 3]);
        model.addListener(expectAsync0(() {}, count: 1));

        model.addAll([4, 5, 6]);
        expect(model, hasLength(6));
      });

      test('notifies once for removeWhere', () {
        final model = ListChangeNotifier([1, 2, 3]);
        model.addListener(expectAsync0(() {}, count: 1));

        model.removeWhere((element) => element > 1);
        expect(model, hasLength(1));
      });

      test('notifies once for retainWhere', () {
        final model = ListChangeNotifier([1, 2, 3]);
        model.addListener(expectAsync0(() {}, count: 1));

        model.retainWhere((element) => element > 2);
        expect(model, hasLength(1));
      });

      test('notifies once for sort', () {
        final model = ListChangeNotifier([3, 1, 2]);
        model.addListener(expectAsync0(() {}, count: 1));

        model.sort();
        expect(model, containsAllInOrder([1, 2, 3]));
      });

      test('notifies once for shuffle', () {
        final model = ListChangeNotifier([3, 1, 2]);
        model.addListener(expectAsync0(() {}, count: 1));

        model.shuffle();
      });

      test('notifies once for removeRnage', () {
        final model = ListChangeNotifier([1, 2, 3, 4, 5]);
        model.addListener(expectAsync0(() {}, count: 1));

        model.removeRange(1, 3);
        expect(model, hasLength(3));
        expect(model, containsAllInOrder([1, 4, 5]));
      });

      test('notifies once for fillRange', () {
        final model = ListChangeNotifier([1, 2, 3, 4, 5]);
        model.addListener(expectAsync0(() {}, count: 1));

        model.fillRange(1, 3, 7);
        expect(model, hasLength(5));
        expect(model, containsAllInOrder([1, 7, 7, 4, 5]));
      });

      test('notifies once for setRange', () {
        final model = ListChangeNotifier([1, 2, 3, 4, 5]);
        model.addListener(expectAsync0(() {}, count: 1));

        model.setRange(1, 3, [8, 9, 10], 1);
        expect(model, hasLength(5));
        expect(model, containsAllInOrder([1, 9, 10, 4, 5]));
      });

      test('notifies once for replaceRange', () {
        final model = ListChangeNotifier([1, 2, 3, 4, 5]);
        model.addListener(expectAsync0(() {}, count: 1));

        model.replaceRange(1, 3, [8, 9, 10]);
        expect(model, hasLength(6));
        expect(model, containsAllInOrder([1, 8, 9, 10, 4, 5]));
      });

      test('notifies once for insertAll', () {
        final model = ListChangeNotifier([1, 2]);
        model.addListener(expectAsync0(() {}, count: 1));

        model.insertAll(1, [3, 4, 5]);
        expect(model, hasLength(5));
        expect(model, containsAllInOrder([1, 3, 4, 5, 2]));
      });

      test('notifies once for setAll', () {
        final model = ListChangeNotifier([1, 2, 3, 4, 5]);
        model.addListener(expectAsync0(() {}, count: 1));

        model.setAll(1, [6, 7]);
        expect(model, hasLength(5));
        expect(model, containsAllInOrder([1, 6, 7, 4, 5]));
      });
    });

    group('Pausable', () {});
  });
}
