import 'package:flutter/widgets.dart';
import 'package:collection_providers/collection_providers.dart';
import 'package:provider/provider.dart';

class CollectionConsumer<T extends CollectionChangeNotifier>
    extends Consumer<T> {
  CollectionConsumer({
    Key key,
    @required
        Widget Function(BuildContext context, T value, Widget child) builder,
    Widget child,
  })  : assert(builder != null),
        super(key: key, builder: builder, child: child);
}
