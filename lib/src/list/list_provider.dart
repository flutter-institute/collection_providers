import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../pausable_change_notifier.dart';

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
class ListProvider<T> extends ChangeNotifier
    with PausableChangeNotifier, ListMixin<T> {
  List<T> _list = [];

  /// The number of objects in this list.
  ///
  /// The valid indices for a list are `0` through `length - 1`
  @override
  int get length {
    assert(_debugAssertNotDisposed());
    return _list.length;
  }

  /// Changes the length of this list.
  ///
  /// If [newLength] is greater than the current length, entries are initialized to `null`.
  @override
  set length(int newLength) {
    assert(_debugAssertNotDisposed());
    _list.length = newLength;
  }

  /// Returns the object at the given [index] in the list
  /// or throws a [RangeError] if [index] is out of bounds.
  @override
  T operator [](int index) {
    assert(_debugAssertNotDisposed());
    return _list[index];
  }

  /// Sets the value at the given [index] in the list to [value]
  /// or throws a [RangeError] if [index] is out of bounds.
  @override
  void operator []=(int index, T value) {
    assert(_debugAssertNotDisposed());
    _list[index] = value;
  }

  /// Appends all objects of [iterable] to the end of the list.
  /// Listeners are notified after all objects have been added.
  ///
  /// Extends the length of the list by the number of objects in [iterable].
  @override
  void addAll(Iterable<T> iterable) {
    assert(_debugAssertNotDisposed());
    pauseNotifications(() {
      super.addAll(iterable);
    }, true);
  }

  /// Removes all objects from this list that satisfy [test].
  /// Listeners are notified after all objects have been removed.
  ///
  /// An object [:o:] satisfies [test] if [:test(o):] is true.
  @override
  void removeWhere(bool Function(T element) test) {
    assert(_debugAssertNotDisposed());
    pauseNotifications(() {
      super.removeWhere(test);
    }, true);
  }

  /// Removes all objects from the list that fail to satisfy [test].
  /// Listeners are notified after all objects have been removed.
  ///
  /// An object [:o:] satisfies [test] if [:test(o):] is true.
  @override
  void retainWhere(bool Function(T element) test) {
    assert(_debugAssertNotDisposed());
    pauseNotifications(() {
      super.retainWhere(test);
    }, true);
  }

  /// Sorts this list according to the order specified by the [compare] function.
  /// Listeners are notified after sorting is completed.
  ///
  /// The [compare] function must act as a [Comparator].
  /// The default List implementations use [Comparable.compare] if [compare] is omitted.
  @override
  void sort([int Function(T a, T b) compare]) {
    assert(_debugAssertNotDisposed());
    pauseNotifications(() {
      super.sort(compare);
    }, true);
  }

  /// Shuffles the elements of this list randomly.
  /// Listeners are notified after shuffling is completed.
  @override
  void shuffle([Random random]) {
    assert(_debugAssertNotDisposed());
    pauseNotifications(() {
      super.shuffle(random);
    }, true);
  }

  /// Removes the objects in the range [start] inclusive to [end] exclusive.
  /// Listeners are notified after all objects are removed.
  ///
  /// The provided range, given by [start] to [end], must be valid.
  /// A range from [start] to [end] is valid if `0 <= start <= end <= len`, where
  /// `len` ist he list's `length`. The range starts at `start` and has length
  /// `end - start`. An empty range (with `end == start`) is valid.
  @override
  void removeRange(int start, int end) {
    assert(_debugAssertNotDisposed());
    pauseNotifications(() {
      super.removeRange(start, end);
    }, true);
  }

  /// Sets the objects in the range [start] inclusive to [end] exclusive to the
  /// given [fill]
  /// Listeners are notified after all objects are updated.
  ///
  /// The provided range, given by [start] to [end], must be valid.
  /// A range from [start] to [end] is valid if `0 <= start <= end <= len`, where
  /// `len` ist he list's `length`. The range starts at `start` and has length
  /// `end - start`. An empty range (with `end == start`) is valid.
  @override
  void fillRange(int start, int end, [T fill]) {
    assert(_debugAssertNotDisposed());
    pauseNotifications(() {
      super.fillRange(start, end, fill);
    }, true);
  }

  /// Copies the objects of [iterable], skipping [skipCount] object first, into
  /// the range [start] inclusive to [end] exclusive of the list.
  /// Listeners are notified after all the values have been set.
  ///
  /// The provided range, given by [start] to [end], must be valid.
  /// A range from [start] to [end] is valid if `0 <= start <= end <= len`, where
  /// `len` ist he list's `length`. The range starts at `start` and has length
  /// `end - start`. An empty range (with `end == start`) is valid.
  ///
  /// The [iterable] must have enough objects to fill the range from [start] to
  /// [end] after skipping [skipCount] objects.
  ///
  /// If [iterable] is this list, the operation copies the elements originally
  /// in the range from `skipCount` to `skipCount + (end - start)` to the range
  /// `start` to `end`, even if the two ranges overlap.
  ///
  /// If [iterable] depends on this list in some other way, no guarantees are made.
  @override
  void setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) {
    assert(_debugAssertNotDisposed());
    pauseNotifications(() {
      super.setRange(start, end, iterable, skipCount);
    }, true);
  }

  /// Removes the objects in the range [start] inclusive to [end] exclusive and
  /// inserts the contes of [newContents] in its place.
  /// Listeners are notified after all the objects have been replaced.
  ///
  /// The provided range, given by [start] to [end], must be valid.
  /// A range from [start] to [end] is valid if `0 <= start <= end <= len`, where
  /// `len` ist he list's `length`. The range starts at `start` and has length
  /// `end - start`. An empty range (with `end == start`) is valid.
  @override
  void replaceRange(int start, int end, Iterable<T> newContents) {
    assert(_debugAssertNotDisposed());
    pauseNotifications(() {
      super.replaceRange(start, end, newContents);
    }, true);
  }

  /// Insert [element] at the position [index] in this list.
  /// Listeners are notified after all objects have been repositioned.
  ///
  /// This increases the length of the list by one and shifts all objects at or
  /// after the index towards the end of the list.
  ///
  /// The [index] value must be non-negative and no greater than [length].
  @override
  void insert(int index, T element) {
    assert(_debugAssertNotDisposed());
    pauseNotifications(() {
      super.insert(index, element);
    }, true);
  }

  /// Removes the object at position [index] from the list.
  /// Listeners are notified after all objects have been repositioned.
  ///
  /// This method reduces the length of `this` by one and moves all later objects
  /// down by one position.
  ///
  /// Returns the removed object.
  ///
  /// The [index] must be in the range `0 ≤ index < length`.
  @override
  T removeAt(int index) {
    assert(_debugAssertNotDisposed());
    return pauseNotifications(() {
      return super.removeAt(index);
    }, true);
  }

  /// Inserts all objects of [iterable] at position [index] in this list.
  /// Listeners are notified after all objects have been inserted.
  ///
  /// This increases the length of the list by the length of [iterable] and
  /// shifts all later objects towards the end of the list.
  ///
  /// The [index] value must be non-negative and no greater than [length].
  @override
  void insertAll(int index, Iterable<T> iterable) {
    assert(_debugAssertNotDisposed());
    pauseNotifications(() {
      super.insertAll(index, iterable);
    }, true);
  }

  /// Overwrites objects of `this` with the objects of [iterable] start at
  /// positions [index] in this list.
  /// Listeners are notified after all objects have been set.
  ///
  /// This operation does not icrease the length of `this`.
  ///
  /// The [index] must be non-negative and no greater than [length].
  ///
  /// The [iterable] must not have more elements than what can fit from [index]
  /// to [length].
  ///
  /// if `iterable` is based on this list, its values may change /during/ the
  /// `setAll` operation.
  @override
  void setAll(int index, Iterable<T> iterable) {
    assert(_debugAssertNotDisposed());
    pauseNotifications(() {
      super.setAll(index, iterable);
    }, true);
  }

  /// Discards the internal resources used by the object.
  /// After this is called, the object is not in a usable state and should be discarded.
  ///
  /// This method should only be called by the object's owner.
  @override
  @mustCallSuper
  void dispose() {
    assert(_debugAssertNotDisposed());
    _list = null;
    super.dispose();
  }

  /// Reimplemented from [ChangeNotifier]
  bool _debugAssertNotDisposed() {
    assert(() {
      if (_list == null) {
        throw FlutterError('A $runtimeType was used after being disposed\n'
            'Once you have called dispose() on a $runtimeType it can no longer by used.');
      }
      return true;
    }());
    return true;
  }
}
