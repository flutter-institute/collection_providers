import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:collection_providers/collection_providers.dart';

/// An implementation of [ChangeNotifier] that allows implementers to interact
/// with this provider as if it were a [Map] and be notified when any changes
/// to the map have been made
///
/// Like [ChangeNotifier], this is optimized for small numbers of listeners.
/// It is O(N) for adding and removing listeners.
///
/// [K] is the type of the Key to be used by this map. It is usually a [String],
/// but can be any subclass of [Object]. It must implement `operator==` and
/// `hashCode`
///
/// [T] is the type of the Value to be used by this map. It can be any subclass
/// of [Object] and has no special requirements.
class MapChangeNotifier<K, T> extends CollectionChangeNotifier
    with MapMixin<K, T> {
  Map<K, T>? _map;

  MapChangeNotifier([Map<K, T>? backingMap])
      : _map = Map<K, T>.from(backingMap ?? {});

  /// Returns the value for the given [key] or null if [key] is not in the map.
  @override
  T? operator [](Object? key) {
    assert(_debugAssertNotDisposed());
    return _map![key];
  }

  /// Associates the [key] with the given [value].
  ///
  /// If the key was already in the map, its associated value is changed.
  /// Otherwise the key/value pair is added to the map.
  @override
  void operator []=(K key, T value) {
    assert(_debugAssertNotDisposed());
    _map![key] = value;
    notifyListeners();
  }

  /// Removes all pairs from the map.
  ///
  /// After this, the map is empty.
  @override
  void clear() {
    assert(_debugAssertNotDisposed());
    _map!.clear();
    notifyListeners();
  }

  /// The keys of [this].
  ///
  /// The returned iterable has efficient `length` and `contains` operations
  /// based on [length] and [containsKey] of the map.
  ///
  /// Modifying the map while iterating the keys may break the iteration.
  @override
  Iterable<K> get keys {
    assert(_debugAssertNotDisposed());
    return _map!.keys;
  }

  /// Removes [key] and its associated value, if present, from the map.
  ///
  /// Returns the value associated with [key] before it was removed.
  /// Returns `null` if [key] was not in the map.
  ///
  /// Note that values can be `null` and a returned `null` value doesn't
  /// always mean that the key was absent.
  @override
  T? remove(Object? key) {
    assert(_debugAssertNotDisposed());
    var removed = _map!.remove(key);
    notifyListeners();
    return removed;
  }

  /// Adds all the key/value pairs of [other] to this map.
  /// Listeners are notified after all values have been added.
  ///
  /// If a key of [other] is already in this map, its value is overwritten.
  ///
  /// The operation is equivalent to doing `this[key] = value` for each key
  /// and associated value in [other]. It iterates over [other], which must
  /// therefore not change during iteration.
  @override
  void addAll(Map<K, T> other) {
    assert(_debugAssertNotDisposed());
    _map!.addAll(other);
    notifyListeners();
  }

  /// Updates all values.
  /// Listeners are notified after all values have been updated.
  ///
  /// Iterates over all entries in the map and updates them with the result of invoking [update].
  @override
  void updateAll(T Function(K key, T value) update) {
    assert(_debugAssertNotDisposed());
    _map!.updateAll(update);
    notifyListeners();
  }

  /// Adds all the key/value pairs of [newEntries] to othis map.
  /// Listeners are notified after all the entries have been added.
  ///
  /// If a key of [newEntries] is already in the map,
  /// the corresponding value is ovewritten.
  ///
  /// The operations is equivalent to doing `this[entry.key] = entry.value`
  /// for each [MapEntry] of the iterable.
  @override
  void addEntries(Iterable<MapEntry<K, T>> newEntries) {
    assert(_debugAssertNotDisposed());
    _map!.addEntries(newEntries);
    notifyListeners();
  }

  /// Remove all entries of this map that satisfy [test]
  /// Listeners are notified after all removals have taken place.
  ///
  /// An entry [:e:] satisfies [test] if [:test(e.key, e.value):] is true.
  @override
  void removeWhere(bool Function(K key, T value) test) {
    assert(_debugAssertNotDisposed());
    _map!.removeWhere(test);
    notifyListeners();
  }

  /// Discards the internal resources used by the object.
  /// After this is called, the object is not in a usable state and should be discarded.
  ///
  /// This method should only be called by the object's owner.
  @override
  @mustCallSuper
  void dispose() {
    assert(_debugAssertNotDisposed());
    _map = null;
    super.dispose();
  }

  /// Reimplemented from [ChangeNotifier]
  bool _debugAssertNotDisposed() {
    assert(() {
      if (_map == null) {
        throw FlutterError('A $runtimeType was used after being disposed\n'
            'Once you have called dispose() on a $runtimeType it can no longer by used.');
      }
      return true;
    }());
    return true;
  }
}
