library consumer;

import 'dart:async';
import 'package:flutter/material.dart';

/// ## Consumer
///
/// > Consumer is like react.Consumer
///
/// Consumer is only one at project; it's single class.
/// Consumer have getState, and setState.
/// setState is trigger all stream listen, update state and call all Consumer widget update.
/// build is use _ConsumerWidget create a StatefulWidget, and subscribe consumer at _ConsumerWidget.
class Consumer<T> {
  final T state;
  late StreamController _controller;
  late Stream stream;

  Consumer(this.state) {
    _controller = StreamController.broadcast();
    stream = _controller.stream;
  }

  Widget build(Widget Function(BuildContext ctx, T state) builder,
      {required List<dynamic> Function(T s) memo}) {
    return _ConsumerWidget<T>(this, builder, memo);
  }

  // @Deprecated('remove getState to v2.2.0, use consumer.state replace consumer.getState()')
  // T getState() {
  //   return state;
  // }
  setState(Function(T state) fn) {
    fn(state);
    _controller.add(state);
  }
}

/// ## _ConsumerWidget
///
/// > _ConsumerWidget is like react.context.consumer style's state manage widget
///
/// builder[required]: use return widget
/// memo[required]: (state) => [], like react.useMemo, only array object is changed, widget can be update
/// _ConsumerWidget listen Store.stream at initState, and cancel listen at widget dispose.
class _ConsumerWidget<T> extends StatefulWidget {
  final Consumer<T> ctrl;
  final List<dynamic> Function(T state) memo;
  final Widget Function(BuildContext ctx, T state) builder;

  _ConsumerWidget(this.ctrl, this.builder, this.memo, {Key? key})
      : super(key: key);

  @override
  _ConsumerWidgetState createState() =>
      _ConsumerWidgetState<T>(ctrl, memo, builder);
}

class _ConsumerWidgetState<T> extends State<_ConsumerWidget> {
  late StreamSubscription _sub;
  late List<dynamic> _lastMemo;
  final Consumer<T> _ctrl;
  final List<dynamic> Function(T state) _memo;
  final Widget Function(BuildContext ctx, T state) _builder;

  _ConsumerWidgetState(this._ctrl, this._memo, this._builder);

  @override
  void initState() {
    super.initState();
    _lastMemo = [..._memo(_ctrl.state)];

    _sub = _ctrl.stream.listen((data) {
      if (_lastMemo.length > 0) {
        bool isUpdate = false;
        List nowMemo = [..._memo(_ctrl.state)];
        for (var i = 0; i < _lastMemo.length; i++) {
          if (_lastMemo[i] != nowMemo[i]) {
            isUpdate = true;
            break;
          }
        }
        if (isUpdate == true) {
          if (mounted) {
            _lastMemo = nowMemo;

            setState(() {});
          }
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return _builder(context, _ctrl.state);
  }
}
