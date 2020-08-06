[![Build Status](https://travis-ci.org/flutter-institute/collection_providers.svg?branch=master)](https://travis-ci.org/flutter-institute/collection_providers)
[![Pub Version](https://img.shields.io/pub/v/collection_providers)](https://pub.dev/packages/collection_providers)
[![Coverage Status](https://coveralls.io/repos/github/flutter-institute/collection_providers/badge.svg?branch=master)](https://coveralls.io/github/flutter-institute/collection_providers?branch=master)

A wrapper around [Provider](https://pub.dev/packages/provider) to add common dart collection providers for quick and easy use.

The package includes wrappers for `list`, `map`, and `set`. It allows you to use the providers as if they were native dart collections, with all available interface methods.

## Usage

### Exposing a value

You can expose a value just like you normally would with `Provider` or, if you want type safety, you can use the `CollectionProvider` as a drop-in replacement to guarantee that the ChangeNotifier is for one of the Collection types in this library.

### Reading a value

Just like with `Provider`, the easiest way to read a value is by using the extension methods on `BuildContext`.

- `context.watch<T>()`, which makes the widget listen to changes on `T`
- `context.read<T>()`, which returns `T` without listening to it
- `context.select<T, R>(R cb(T value))`, which allows a widget to listen to only a small part of `T`.

Or to use the static method `Provider.of<T>(context)`, which will behave similarly to `watch`/`read`.

You can also use Provider's `Consumer` and `Selector`, or `CollectionConsumer`.

With typed collections, `T` must include the type of the collection as well.

For example, if your provider is created using `CollectionProvider(create: (_) => ListChangeNotifier(['default', 'values']))` or`CollectionProvider(create: (_) => ListChangeNotifier<String>())`  then you will need to use `context.watch<ListChangeNotifier<String>>` as the proper template type to properly look up the provider.

If you do not specify a default collection, or a type, then it defaults to `dynamic` and you can leave ignore the type declaration on the ChangeNotifier.

## Additional Reading

To read more about using `Providers`, see its documentation [here](https://pub.dev/documentation/provider/latest/provider/provider-library.html).