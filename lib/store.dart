import 'dart:async';

/// ## Store
///
/// > Store is like redux store
///
/// Store is only one at project; it's single class.
/// Store have getState, and setState.
/// setState is trigger all stream listen, update state and call all Consumer widget update.
class Store<T> {
  static dynamic _state;
  static StreamController controller;
  static Stream stream;

  static T getState<T>() {
    return _state;
  }

  static T setState<T>(Function(T state) fn) {
    fn(_state);
    controller.add(_state);
    return _state;
  }

  static void initState<T>(T state) {
    _state = state;
    controller = StreamController.broadcast();
    stream = controller.stream;
    stream.listen((data) {
      _state = data;
    });
  }
}
