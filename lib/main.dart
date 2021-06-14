import './widgets/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import './widgets/new_transaction.dart';
import 'package:flutter/material.dart';
import './modals/transaction.dart';
import './widgets/chart.dart';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kharcha',
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.amber,
        colorScheme: ColorScheme.fromSwatch(
          accentColor: Colors.teal[600],
        ),
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: const TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: const TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                button: const TextStyle(
                  color: Colors.white,
                ),
              ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Tx> _userTxs = [
    // Tx(
    //   id: 't1',
    //   title: 'condoms',
    //   amount: 69.69,
    //   dateTime: DateTime.now(),
    // ),
    // Tx(
    //   id: 't2',
    //   title: 'lube',
    //   amount: 169.69,
    //   dateTime: DateTime.now(),
    // ),
  ];

  bool _showChart = false;

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifeCycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  List<Tx> get _recentTxs {
    return _userTxs.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTx(String title, double amount, DateTime chosenDate) {
    final newTx = Tx(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: DateTime.now(),
    );

    setState(() {
      _userTxs.add(newTx);
    });
  }

  void _startNewTx(BuildContext Ctx) {
    showModalBottomSheet(
      context: Ctx,
      builder: (_) {
        return GestureDetector(
          child: NewTx(_addNewTx),
          onTap: () {},
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _delTx(String id) {
    setState(() {
      _userTxs.removeWhere((tx) => tx.id == id);
    });
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Show Chart',
            style: Theme.of(context).textTheme.headline6,
          ),
          Switch.adaptive(
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          )
        ],
      ),
      _showChart
          ? SizedBox(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.8,
              child: Chart(_recentTxs),
            )
          : txListWidget,
    ];
  }

  List<Widget> _buildPotraitContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      SizedBox(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTxs),
      ),
      txListWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    print('build() MyHomePageState');
    final mediaQuery = MediaQuery.of(context);

    final isType = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar;
    if ((Platform.isIOS)) {
      appBar = CupertinoNavigationBar(
        middle: const Text(
          'Kharcha',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
              child: const Icon(CupertinoIcons.add),
              onTap: () => _startNewTx(context),
            )
          ],
        ),
      );
    } else {
      appBar = AppBar(
        title: const Text(
          'Kharcha',
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () => _startNewTx(context),
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          )
        ],
      );
    }

    final txListWidget = SizedBox(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.8,
      child: TxList(_userTxs, _delTx),
    );

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isType)
              ..._buildLandscapeContent(
                  mediaQuery, appBar as AppBar, txListWidget),
            if (!isType)
              ..._buildPotraitContent(
                  mediaQuery, appBar as AppBar, txListWidget),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar as ObstructingPreferredSizeWidget,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButton: FloatingActionButton(
              onPressed: () => _startNewTx(context),
              child: const Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          );
  }
}
