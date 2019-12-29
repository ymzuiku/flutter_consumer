consumer 是一个参考 [react-consumer](https://github.com/ymzuiku/react-consumer) 方式的状态管理, 使用 dart 的 `Stream` 做发布订阅.

类 react 项目，当项目到一定程度，必不可少需要一个状态管理器，flutter 有着不少状态管理库，BLOC、Provider、redux 等等；但是他们现有的问题是没有给出很便捷的状态管理优化方案。

consumer 的特点是仅仅是发布订阅模式加 StateFulWidget，这比市面上基于 InheritedWidget 进行封装的状态管理器的优势是它不需要一个顶层的提供者模式的包裹。基于此，consumer 可以让项目更简单创建子模块的独立的状态管理，当然你也可以使用 consumer 的单一模式管理整个项目的状态。

在这个前提下，我们会发现若项目足够大，我们需要切分多个子状态管理，或者一些局部的状态管理，这样可以有效减少事件派发的影响范围，从而提高性能；consumer 另一个特点是强制使用者描述每个订阅所使用的对象，这样 consumer 可以帮助优化性能，拦截不必要的更新。

## Feature

- consumer 不需要一个顶层的 Provider 包裹对象；
- consumer 可以很轻松的给子模块设置独立的状态管理；
- consumer 使用 `memo` 拦截不必要的更新，从 react.Hooks 得到的灵感;
- consumer 非常易于使用, 仅有 3 个 API:
  - getState
  - setState
  - build

API 文档:

- [https://pub.flutter-io.cn/packages/consumer](https://pub.flutter-io.cn/packages/consumer)
- [https://pub.flutter-io.cn/documentation/consumer/latest/](https://pub.flutter-io.cn/documentation/consumer/latest/)

### 安装 consumer

修改 `pubspec.yaml`:

```yaml
dependencies:
  consumer: ^1.0.2
```

## 入门指南

这是一个 Flutter 默认的初始化项目，我们使用 consumer 改造它，移除 StateFulWidget，替换成 StatelessWidget：

```dart
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

// *** 定义一个类，描述状态 ***
class ExampleState {
  int counter = 0;
}

// *** 创建一个 consumer ***
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
    // *** 使用 setState ，触发订阅的组件更新 ***
    consumer.setState((state) => state.counter++);
  }

  @override
  Widget build(BuildContext context) {
    print('整个对象仅更新一次，更新时仅更新订阅的组件');

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
            // *** 使用 consumer.build 订阅一个组件 ***
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

## FAQ

### 参数 `memo` 的作用是什么？

`memo` 参数是可选的； 如果我们不设置此参数，consumer 只要执行 setState，就都会更新组件；

如果你项目有着非常多的状态订阅，使用 `memo` 可以大幅度提高性能；所以 `memo` 设计为必须定义的参数。

`memo` 的概念是来自于 react.Hooks, 它用来描述监听变化的对象，仅有监听对象变化时，才会派发更新。

一个原则是，我们在 builder 对象中需要使用什么属性，`memo` 返回的数组就定义什么属性, 我们这里有一些例子：

如果我们由 consumer.build 创建的两个 widget：

```dart
// *** definition a state ***
class ExampleState {
  List<String> animates = [];
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
      memo: (state) => [state.age, state.animates],
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

然后我们更新 state.name:

```dart
consumer.setState((state){
  state.name = 'cat';
});
```

此时，当我们更新 `state.name`，只有订阅了 `memo: (state) => [state.name]` 的 widget 会更新，其他 Widget 的更新都会被 consumer 拦截。

### 为什么我的使用了 `consumer.setState` 之后 Widget 并没有更新？

或许你在 `builder` 中使用了 `state.name`, 不过 `memo` 返回的数组未包含 `state.name`:

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

或许你的 `memo` 未监听任何对象:

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

或许你仅仅是改变了 List 或 Map 内的对象，但是没有重新设定一个新的 List 或 Map：

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

// 错误的更新:
Consumer.setState((state){
  state.names[0] = 'fish'
});

// 正确的更新:
Consumer.setState((state){
  List<String> names = [...state.names];
  names[0] = 'fish'
  state.names = names;
});
```

### State 小技巧

如果你需要在更新之前做一些计算, 或者更方便处理数组之类的更新，你可以创建一些函数属性给 State：

这里有一个修改 List 数据的例子：

```dart
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

// 轻松更新 names 和 lastChangeNamesIndex
consumer.setState((state){
  state.changeNameAt(0, 'monkey');
})
```

# That's all

感谢你阅读本文档和使用 `consumer`.
