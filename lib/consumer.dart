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
  final Widget Function(BuildContext context, T state) builder;
  final List Function(T state) memo;
  final bool Function(T state) shouldWidgetUpdate;

  Consumer(
      {@required this.builder, this.memo, this.shouldWidgetUpdate, Key key})
      : super(key: key);

  @override
  _ConsumerState createState() =>
      _ConsumerState<T>(builder, memo, shouldWidgetUpdate);
}

class _ConsumerState<T> extends State<Consumer> {
  StreamSubscription sub;
  List lastMemo;
  final Widget Function(BuildContext context, T state) builder;
  final List Function(T state) memo;
  final bool Function(T state) shouldWidgetUpdate;

  _ConsumerState(this.builder, this.memo, this.shouldWidgetUpdate);

  @override
  void initState() {
    super.initState();
    if (memo != null) {
      lastMemo = [...memo(Store.getState<T>())];
    }

    sub = Store.stream.listen((data) {
      if (shouldWidgetUpdate != null) {
        if (shouldWidgetUpdate(Store.getState<T>()) == true) {
          setState(() {});
        }
      } else if (memo != null) {
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
      } else {
        setState(() {});
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
