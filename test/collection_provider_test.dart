import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:collection_providers/collection_providers.dart';
import 'package:provider/provider.dart';

void main() {
  group('CollectionProvider', () {
    testWidgets('throws provider error if ancestor not found', (tester) async {
      final widget = Builder(
        builder: (context) {
          CollectionProvider.of<ListChangeNotifier>(context);
          return Container();
        },
      );

      await tester.pumpWidget(widget);
      expect(tester.takeException(), isA<ProviderNotFoundException>());
    });

    testWidgets(
      'rebuilds when notifyListeners is called using Provider.of',
      (tester) async {
        final model = CollectionChangeNotifier();
        final listener = expectAsync0(() {}, count: 2);
        final widget = CollectionProvider.value(
          value: model,
          child: Builder(
            builder: (context) {
              CollectionProvider.of<CollectionChangeNotifier>(context);
              return BuildDetector(listener);
            },
          ),
        );

        await tester.pumpWidget(widget);
        model.notifyListeners();
        await tester.pump();
      },
    );

    testWidgets(
      'rebuilds when notifyListeners is called using context.watch',
      (tester) async {
        final model = CollectionChangeNotifier();
        final listener = expectAsync0(() {}, count: 2);
        final widget = CollectionProvider.value(
          value: model,
          child: Builder(
            builder: (context) {
              context.watch<CollectionChangeNotifier>();
              return BuildDetector(listener);
            },
          ),
        );

        await tester.pumpWidget(widget);
        model.notifyListeners();
        await tester.pump();
      },
    );

    testWidgets(
      'rebuilds when notifyListeners is called using CollectionConsumer',
      (tester) async {
        final model = CollectionChangeNotifier();
        final listener = expectAsync0(() {}, count: 2);
        final widget = CollectionProvider.value(
          value: model,
          child: Builder(
            builder: (context) {
              return CollectionConsumer(
                builder: (context, value, child) {
                  return BuildDetector(listener);
                },
              );
            },
          ),
        );

        await tester.pumpWidget(widget);
        model.notifyListeners();
        await tester.pump();
      },
    );

    test(
      'throws an assertion error if there is no builder with CollectionConsumer',
      () {
        expect(() => CollectionConsumer(), throwsAssertionError);
      },
    );

    testWidgets('rebuilds once after pause', (tester) async {
      final model = CollectionChangeNotifier();
      final listener = expectAsync0(() {}, count: 2);
      final widget = CollectionProvider(
        create: (_) => model,
        child: Builder(
          builder: (context) {
            CollectionProvider.of<CollectionChangeNotifier>(context);
            return BuildDetector(listener);
          },
        ),
      );

      await tester.pumpWidget(widget);
      model.pauseNotifications(() {
        model.notifyListeners();
        model.notifyListeners();
      }, true);
      await tester.pump();
    });

    testWidgets('does not rebuild when paused', (tester) async {
      final model = CollectionChangeNotifier();
      final listener = expectAsync0(() {}, count: 1);
      final widget = CollectionProvider.value(
        value: model,
        child: Builder(
          builder: (context) {
            CollectionProvider.of<CollectionChangeNotifier>(context);
            return BuildDetector(listener);
          },
        ),
      );

      await tester.pumpWidget(widget);
      model.pauseNotifications(() => model.notifyListeners());
      await tester.pump();
    });

    testWidgets('does not rebuild when async paused', (tester) async {
      final model = CollectionChangeNotifier();
      final listener = expectAsync0(() {}, count: 1);
      final widget = CollectionProvider.value(
        value: model,
        child: Builder(
          builder: (context) {
            CollectionProvider.of<CollectionChangeNotifier>(context);
            return BuildDetector(listener);
          },
        ),
      );

      await tester.pumpWidget(widget);
      await model.pauseNotificationsAsync(() async => model.notifyListeners());
      await tester.pump();
    });
  });
}

// Helper widget to detect when build() is called
class BuildDetector extends StatelessWidget {
  final Function() onBuild;

  BuildDetector(this.onBuild);

  @override
  Widget build(BuildContext context) {
    onBuild();
    return Container();
  }
}
