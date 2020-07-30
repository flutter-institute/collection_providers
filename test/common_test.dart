import 'package:flutter_test/flutter_test.dart';
import 'package:collection_providers/collection_providers.dart';

void main() {
  final models = {
    'ListChangeNotifier': () => ListChangeNotifier(),
    'MapChangeNotifier': () => MapChangeNotifier(),
    'SetChangeNotifier': () => SetChangeNotifier(),
  };

  models.entries.forEach((element) {
    group('Common ${element.key}', () {
      CollectionChangeNotifier getModel() => element.value();

      group('addListener()', () {
        test('invoking after dispose throws assertion', () {
          final model = getModel();
          model.dispose();
          expect(() => model.addListener(null), throwsAssertionError);
        });

        test('same listener returns normally', () {
          final listener = () {};
          final model = getModel();
          model.addListener(listener);
          expect(() => model.addListener(listener), returnsNormally);
        });
      });

      group('removeListener()', () {
        test('invoking after dispose throws assertion', () {
          final model = getModel();
          model.dispose();
          expect(() => model.removeListener(null), throwsAssertionError);
        });

        test(
            'removing listeners while invoking does not invoke removed listener',
            () {
          final model = getModel();
          final l2 = expectAsync0(() {}, count: 0);
          final l1 = expectAsync0(() {
            model.removeListener(l2);
          }, count: 1);

          model.addListener(l1);
          model.addListener(l2);
          model.notifyListeners();
        });

        test('adding listeners while invoking does not invoke added listener',
            () {
          final model = getModel();
          final l2 = expectAsync0(() {}, count: 0);
          final l1 = expectAsync0(() {
            model.addListener(l2);
          }, count: 1);

          model.addListener(l1);
          model.notifyListeners();
        });

        test('same listener is invoked multiple times', () {
          final model = getModel();
          final l = expectAsync0(() {}, count: 2);
          model.addListener(l);
          model.addListener(l);
          model.notifyListeners();
        });

        test('removed listener is not invoked', () {
          final model = getModel();
          final l = expectAsync0(() {}, count: 0);
          model.addListener(l);
          model.removeListener(l);
          model.notifyListeners();
        });
      });
    });
  });
}
