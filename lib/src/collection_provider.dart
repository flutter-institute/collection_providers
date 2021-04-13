import 'package:collection_providers/collection_providers.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';

class CollectionProvider<T extends CollectionChangeNotifier>
    extends ChangeNotifierProvider<T> {
  /// Creates a [CollectionProvider] using `create` and automatically
  /// dispose it when [CollectionProvider] is removed from the widget tree.
  ///
  /// `create` must not be `null`.
  CollectionProvider({
    Key? key,
    required Create<T> create,
    bool? lazy,
    TransitionBuilder? builder,
    Widget? child,
  }) : super(
          key: key,
          create: create,
          lazy: lazy,
          builder: builder,
          child: child,
        );

  /// Provides an existing [ChangeNotifier].
  CollectionProvider.value({
    Key? key,
    required T value,
    TransitionBuilder? builder,
    Widget? child,
  }) : super.value(
          key: key,
          builder: builder,
          value: value,
          child: child,
        );

  /// Obtains the nearest [CollectionProvider<T>] up its widget tree and returns
  /// its value.
  ///
  /// If [listen] is `true`, later value changes will trigger a new
  /// [State.build] to widgets, and [State.didChangeDependencies] for
  /// [StatefulWidget].
  ///
  /// `listen: false` is necessary to be able to call `CollectionProvider.of`
  /// inside [State.initState] or the `create` method of providers.
  static T of<T extends CollectionChangeNotifier>(
    BuildContext context, {
    bool listen = true,
  }) =>
      Provider.of<T>(context, listen: listen);
}
