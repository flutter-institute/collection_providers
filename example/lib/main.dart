// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars
import 'package:flutter/material.dart';
import 'package:collection_providers/collection_providers.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    // Making providers globally accessible, even to tests
    MultiProvider(
      providers: [
        CollectionProvider(
          create: (_) => ListChangeNotifier(['list 1', 'list 2', 'list 3']),
        ),
        CollectionProvider(create: (_) => CustomMapChangeNotifier()),
        CollectionProvider(
          create: (_) => SetChangeNotifier({'set 1', 'set 2', 'set 3'}),
        ),
      ],
      child: MyApp(),
    ),
  );
}

/// By extending one of the CollectionChangeNotifiers you can add custom
/// methods that can the interact with the underlying dataset, and you can
/// interact with it as if it were the underlying dataset.
class CustomMapChangeNotifier extends MapChangeNotifier {
  CustomMapChangeNotifier() : super({'map 1': 1, 'map 2': 2, 'map 3': 3});
  void addCountString(String key) {
    this[key] = length + 1;
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Collection Providers Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _currentPage = 0;

  void _onChangePage(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _onAdd(BuildContext context) async {
    if (_currentPage == 0) {
      final value = await _showTextDialog(context);
      /* @@ */
      print('New List Value: $value');
      /* ## */
      if (value != null && value.isNotEmpty) {
        CollectionProvider.of<ListChangeNotifier<String>>(context,
                listen: false)
            .add(value);
      }
    } else if (_currentPage == 1) {
      final value = await _showTextDialog(context);
      if (value != null && value.isNotEmpty) {
        CollectionProvider.of<SetChangeNotifier<String>>(context, listen: false)
            .add(value);
      }
    } else if (_currentPage == 2) {
      final value = await _showTextDialog(context);
      if (value != null && value.isNotEmpty) {
        final customMapProvider =
            CollectionProvider.of<CustomMapChangeNotifier>(context,
                listen: false);
        customMapProvider[value] = customMapProvider.length + 1;
      }
    }
  }

  Widget _renderChild(BuildContext context) {
    if (_currentPage == 0) return ListBody();
    if (_currentPage == 1) return SetBody();
    if (_currentPage == 2) return MapBody();
    return Container();
  }

  Future<String> _showTextDialog(BuildContext context) async {
    final ctrl = TextEditingController();

    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: TextField(
            autofocus: true,
            controller: ctrl,
            decoration: InputDecoration(
              hintText: 'Enter a name',
            ),
          ),
          actions: [
            RaisedButton(
              child: Text('Save'),
              onPressed: () {
                var value = ctrl.text;
                Navigator.of(context).pop(value);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Collection Provider Example'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: _renderChild(context),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.add),
        onPressed: () => _onAdd(context),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: _onChangePage,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('List'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Set'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text('Map'),
          )
        ],
      ),
    );
  }
}

class ListBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Use a CollectionConsumer (or just a Consumer) to watch the provider
    return CollectionConsumer<ListChangeNotifier<String>>(
      builder: (context, listProvider, child) {
        return ListView.builder(
          itemCount: listProvider.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Item[$index] = ${listProvider[index]}'),
            );
          },
        );
      },
    );
  }
}

class SetBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Use context to watch the provider instead
    final setProvider = context.watch<SetChangeNotifier<String>>();

    final asList = setProvider.toList(growable: false);
    return ListView.builder(
      itemCount: setProvider.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Item[$index] = ${asList[index]}'),
        );
      },
    );
  }
}

class MapBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Use context to watch provider
    final customMapProvider = context.watch<CustomMapChangeNotifier>();

    final asList = customMapProvider.entries.toList(growable: false);
    return ListView.builder(
      itemCount: customMapProvider.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Item[${asList[index].key}] = ${asList[index].value}'),
        );
      },
    );
  }
}
