library consumer;

import 'dart:async';
import 'package:flutter/material.dart';
import './store.dart';

export './store.dart';

/// ## Consumer
///
/// > Consumer is like react.context.consumer style's state manage widget
///
/// builder[required]: use return widget
/// memo[option]: (state) => [], like react.useMemo, only array object is changed, widget can be update
/// shouldWidgetUpdate[option]: (state) => bool, like react.shouldComponentUpdate, intercept update at return false;
/// Consumer listen Store.stream at initState, and cancel listen at widget dispose.
class Consumer<T> extends StatefulWidget {
  final Widget Function(BuildContext ctx, T state) builder;
  final List Function(T state) memo;

  Consumer({@required this.builder, @required this.memo, Key key})
      : super(key: key);

  @override
  _ConsumerState createState() => _ConsumerState<T>(builder, memo);
}

class _ConsumerState<T> extends State<Consumer> {
  StreamSubscription sub;
  List lastMemo;
  final Widget Function(BuildContext ctx, T state) builder;
  final List Function(T state) memo;

  _ConsumerState(this.builder, this.memo);

  @override
  void initState() {
    super.initState();
    lastMemo = [...memo(Store.getState<T>())];

    sub = Store.stream.listen((data) {
      if (lastMemo.length > 0) {
        bool isUpdate = false;
        List nowMemo = [...memo(Store.getState<T>())];
        for (var i = 0; i < lastMemo.length; i++) {
          if (lastMemo[i] != nowMemo[i]) {
            isUpdate = true;
            break;
          }
        }
        if (isUpdate == true) {
          lastMemo = nowMemo;
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return builder(context, Store.getState<T>());
  }
}
