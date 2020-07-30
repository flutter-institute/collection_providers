import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:collection_providers/collection_providers.dart';

class SetChangeNotifier<T> extends ChangeNotifier
    with CollectionChangeNotifier, SetMixin<T> {
  Set<T> _set;

  SetChangeNotifier([Set<T> backingSet]) {
    _set = Set<T>.from(backingSet ?? {});
  }

  /// Adds [value] to the set.
  /// Listeners are only notified if the set changes.
  ///
  /// Returns `true` if [value] (or an equal value) was not yet in the set.
  /// Otherwise returns `false` and the set is not changed
  @override
  bool add(T value) {
    assert(_debugAssertNotDisposed());
    final result = _set.add(value);

    // Only notify if things actually changed
    if (result) {
      notifyListeners();
    }

    return result;
  }

  /// Adds all [elements] to this set.
  /// Listeners are notified after all values have been added.
  ///
  /// Equivalent to adding each element in [elements] using [add].
  @override
  void addAll(Iterable<T> elements) {
    pauseNotifications(() {
      _set.addAll(elements);
    }, true);
  }

  /// Returns `true` if [value] is in the set.
  @override
  bool contains(Object element) {
    assert(_debugAssertNotDisposed());
    return _set.contains(element);
  }

  /// Provides an iterator that iterates over the elements of this set.
  @override
  Iterator<T> get iterator {
    assert(_debugAssertNotDisposed());
    return _set.iterator;
  }

  @override
  int get length {
    assert(_debugAssertNotDisposed());
    return _set.length;
  }

  /// If an object equal to [element] is in the set, return it.
  ///
  /// Checks whether [element] is in the set, like [contains], and if so,
  /// returns the object in the set, otherwise returns `null`.
  @override
  T lookup(Object element) {
    assert(_debugAssertNotDisposed());
    return _set.lookup(element);
  }

  /// Removes [value] from the set. Returns `true` if [value] was in the set.
  /// Only notifies the listeners if the set was changed.
  ///
  /// Returns `false` otherwise. The method has no effect if [value] was not
  /// in the set.
  @override
  bool remove(Object value) {
    assert(_debugAssertNotDisposed());
    final result = _set.remove(value);

    // Only notify if something changed
    if (result) {
      notifyListeners();
    }
    return result;
  }

  /// Removes each element of [elements] from this set.
  /// Listeners are notified after all values have been removed.
  @override
  void removeAll(Iterable<Object> elements) {
    assert(_debugAssertNotDisposed());
    _set.removeAll(elements);
    notifyListeners();
  }

  /// Removes all elements of this set that are not elements in [elements].
  /// Listeners are notified after all values have been removed.
  ///
  /// Checks for each element of [elements] whether there is an element in this
  /// set that is equal to it (according to `this.contains`), and if so, the
  /// equal element in this set is retained, and elements that are not equal to
  /// any elements in [elements] are removed.
  @override
  void retainAll(Iterable<Object> elements) {
    assert(_debugAssertNotDisposed());
    _set.retainAll(elements);
    notifyListeners();
  }

  /// Removes all elements of this set that satisfy [test]
  /// Listeners are notified after all values have been removed.
  @override
  void removeWhere(bool Function(T element) test) {
    assert(_debugAssertNotDisposed());
    _set.removeWhere(test);
    notifyListeners();
  }

  /// Removes all elements of this set that fail to satisfy [test]
  /// Listeners are notified after all values have been removed.
  @override
  void retainWhere(bool Function(T element) test) {
    assert(_debugAssertNotDisposed());
    _set.retainWhere(test);
    notifyListeners();
  }

  /// Removes all elements in the set.
  /// Listeners are notified after all valuse have been removed.
  @override
  void clear() {
    assert(_debugAssertNotDisposed());
    _set.clear();
    notifyListeners();
  }

  /// Creates a [Set] with the same elements as this `Set`.
  @override
  Set<T> toSet() {
    assert(_debugAssertNotDisposed());
    return _set.toSet();
  }

  /// Discards the internal resources used by the object.
  /// After this is called, the object is not in a usable state and should be discarded.
  ///
  /// This method should only be called by the object's owner.
  @override
  @mustCallSuper
  void dispose() {
    assert(_debugAssertNotDisposed());
    _set = null;
    super.dispose();
  }

  /// Reimplemented from [ChangeNotifier]
  bool _debugAssertNotDisposed() {
    assert(() {
      if (_set == null) {
        throw FlutterError('A $runtimeType was used after being disposed\n'
            'Once you have called dispose() on a $runtimeType it can no longer by used.');
      }
      return true;
    }());
    return true;
  }
}
