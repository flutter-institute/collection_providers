import 'package:collection_providers/collection_providers.dart';
import 'package:provider/provider.dart';

class CollectionConsumer<T extends CollectionChangeNotifier>
    extends Consumer<T> {
  // noop, just a wrapper for type enforcement
}
