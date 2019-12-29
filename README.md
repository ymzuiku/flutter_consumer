# consumer

[中文文档](./README-CN.md)

consumer is like [react-consumer](https://github.com/ymzuiku/react-consumer) state manage, use Stream at dart.

## Feature

- consumer not need Provider at root Widget.
- consumer can ease create sub StateManager at detail modules.
- consumer use `memo` to intercept update, like react.Hooks.
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
  consumer: ^2.0.0
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
            consumer.build((ctx, state) {
              return Text(
                '$state.counter',
                style: Theme.of(context).textTheme.display1,
              );
            }),
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

## About `memo` detail

If your project have very many state's subscribe, use `memo` can significantly improved performance.

`memo` param is learn by react.Hooks, there have some example:

If we have two consumer.build widget:

```dart
// *** definition a state ***
class ExampleState {
  int age = 0;
  String name = 'dog';
}

// *** create a consumer ***
var consumer = Consumer(ExampleState());

Column(
  children: <Widget>[
    consumer.build((ctx, state) {
        print('Update when state.age change');
        return Text(
          '$state.age',
          style: Theme.of(context).textTheme.display1,
        );
      },
      memo: (state) => [state.age],
    ),
    consumer.build((ctx, state) {
        print('Update when state.name change');
        return Text(
          state.name,
          style: Theme.of(context).textTheme.display1,
        );
      },
      memo: (state) => [state.name],
    ),
  ],
);
```

We update state.name, Only update use `memo: (state) => [state.name]` the widget:

```dart
consumer.setState((state){
  state.name = 'cat';
});
```

## Why not update widget before `consumer.setState`?

Maybe your use `state.name`, bug `memo` not subscribe `state.name`:

```dart
Center(
  child: consumer.build((ctx, state) {
      return Text(
        state.name,
        style: Theme.of(context).textTheme.display1,
      );
    },
    memo: (state) => [state.age],
  ),
);
```

Maybe `memo` not return anything:

```dart
Center(
  child: consumer.build((ctx, state) {
      return Text(
        state.name,
        style: Theme.of(context).textTheme.display1,
      );
    },
    memo: (state) => [],
  ),
);
```

Maybe your only change List or Map, bu not set new List or Map:

```dart
class ExampleState {
  List<String> names = ['dog', 'cat'];
}

var consumer = Consumer(ExampleState());

Center(
  child: consumer.build((ctx, state) {
      return Text(
        state.names[0],
        style: Theme.of(context).textTheme.display1,
      );
    },
    memo: (state) => [state.names],
  ),
);

// Error update:
Consumer.setState((state){
  state.names[0] = 'fish'
});

// right update:
Consumer.setState((state){
  List<String> names = [...state.names];
  names[0] = 'fish'
  state.names = names;
});
```

## State Skills

If your need change data before update, you can add function props at State.

This have change List data's example:

```dart
// *** definition a state ***
class ExampleState {
  int lastChangeNamesIndex;
  List<String> names = ['dog', 'cat'];

  changeNameAt(int index, String name) {
    lastChangeNamesIndex = index;
    List<String> nextNames = [...names];
    nextNames[index] = name;
    names = nextNames;
  }
}

var consumer = Consumer(ExampleState());

Center(
  child: consumer.build((ctx, state) {
      return Text(
        state.names[state.lastChangeNamesIndex],
        style: Theme.of(context).textTheme.display1,
      );
    },
    memo: (state) => [state.names, state.lastChangeNamesIndex],
  ),
);

// ease update names and lastChangeNamesIndex
consumer.setState((state){
  state.changeNameAt(0, 'monkey');
})
```

## 2.0.0 API change:

`consumer.build`:

Before:

```dart
Widget build({
  List<dynamic> Function(T s) memo,
  @required Widget Function(BuildContext ctx, T state) builder,
});
```

After:

```dart
Widget build(Widget Function(BuildContext ctx, T state) builder, {List<dynamic> Function(T s) memo});
```

# That's all

Thank you read and use consumer
