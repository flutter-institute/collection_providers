import 'package:collection_providers/collection_providers.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';

class CollectionProvider<T extends CollectionChangeNotifier>
    extends ChangeNotifierProvider<T> {
  static T of<T extends CollectionChangeNotifier>(
    BuildContext context, {
    bool listen = true,
  }) {
    T nullCheck(T model) {
      assert(model != null,
          'Could not find an ancestor CollectionChangeNotifier<$T>');
      return model;
    }

    return nullCheck(Provider.of<T>(context, listen: listen));
  }
}
