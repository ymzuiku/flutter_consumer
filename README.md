# consumer

[中文文档](./README-CN.md)

consumer is like [react-consumer](https://github.com/ymzuiku/react-consumer) state manage, use Stream at dart.

## Feature

- consumer not need Provider at root Widget.
- consumer can ease create sub StateManager at detail modules.
- consumer use memo to intercept update, like react.Hooks.
- consumer is tiny and ease use, only 3 API:
  - getState
  - setState
  - build

API Document:

- [https://pub.dev/packages/consumer](https://pub.dev/packages/consumer)
- [https://pub.dev/documentation/consumer/latest/](https://pub.dev/documentation/consumer/latest/)

If your need use old API, please use `consumer: 0.1.4`;

### Install consumer

Change `pubspec.yaml`:

```yaml
dependencies:
  consumer: ^1.0.2
```

## Getting Started

It's Flutter default example, we use Consumer change StateFulWidget to StatelessWidget:

```dart
import 'package:flutter/material.dart';
void main() => runApp(MyApp());

// *** definition a state ***
class ExampleState {
  int counter = 0;
}

// *** create a consumer ***
var consumer = Consumer(ExampleState());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Consumer Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  _incrementCounter() {
    // *** Update some widget ***
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
            // *** Use consumer.build connect to widget ***
            consumer.build(
              memo: (state) => [state.counter],
              builder: (ctx, state) {
                print('Update when state.counter change');
                return Text(
                  '$state.counter',
                  style: Theme.of(context).textTheme.display1,
                );
              },
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

```

# That's all

Thank you read and use consumer
