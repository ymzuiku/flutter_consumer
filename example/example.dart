import 'package:flutter/material.dart';

import '../lib/consumer.dart';

void main() => runApp(MyApp());

// definition a state
class ExampleState {
  int counter = 0;
}

// create a consumer

var consumer = Consumer(ExampleState());

// Flutter base example, StateFulWidget change to StatelessWidget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  _incrementCounter() {
    consumer.setState((state) => state.counter++);
  }

  @override
  Widget build(BuildContext context) {
    print('only run once');

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            consumer.build(
              // use memo, we can subscribe to valid changes
              (ctx, state) {
                print('update when state.counter change');
                return Text(
                  '$state.counter',
                  style: Theme.of(context).textTheme.headline4,
                );
              },
              memo: (state) => [state.counter],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
