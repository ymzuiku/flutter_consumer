# consumer

consumer 是一个参考 [react-consumer](https://github.com/ymzuiku/react-consumer) 方式的状态管理, 使用 `Stream` 做发布订阅.

类 react 项目，当项目到一定程度，必不可少需要一个状态管理器，flutter 有着不少状态管理库，BLOC、Provider、redux 等等；但是他们现有的问题是没有给出很便捷的状态管理优化方案。

在这个前提下，我们会发现若项目足够大，我们需要切分多个子状态管理，或者一些局部的状态管理，这样可以有效减少事件派发的影响范围，从而提高性能；consumer 另一个特点是强制使用者描述每个订阅所使用的对象，这样 consumer 可以帮助优化性能，拦截不必要的更新。

consumer 的特点是仅仅是发布订阅模式加 StateFulWidget，这比市面上基于 InheritedWidget 进行封装的状态管理器的优势是它不需要一个顶层的提供者模式的包裹。基于此，consumer 可以让项目更简单创建子模块的独立的状态管理，当然你也可以使用 consumer 的单一模式管理整个项目的状态。

- consumer 不需要一个顶层的 Provider 包裹对象；
- consumer 可以很轻松的给子模块设置独立的状态管理；
- consumer 使用 memo 拦截不必要的更新，从 react.Hooks 得到的灵感;
- consumer 非常易于使用, 仅有 3 个 API:
  - getState
  - setState
  - build

API 文档:

- [https://pub.flutter-io.cn/documentation/consumer/latest/](https://pub.flutter-io.cn/documentation/consumer/latest/)
- [https://pub.dev/documentation/consumer/latest/](https://pub.dev/documentation/consumer/latest/)

### 安装 consumer

修改 `pubspec.yaml`:

```yaml
dependencies:
  consumer: ^1.0.1
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
            consumer.build(
              memo: (state) => [state.counter],
              builder: (ctx, state) {
                print('仅有 memo 返回值中的对象改变了，builder 对象才会更新');
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

感谢你阅读本文档和使用 `consumer`.
