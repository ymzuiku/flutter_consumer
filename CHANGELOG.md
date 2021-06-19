## [2.3.1] - Use next package Obx

## [2.3.0] - Change to null-safety

move to null-safety

## [2.2.0] - API CHANGES

memo: change to required

`consumer.build`:

Before:

```dart
Widget build(
  Widget Function(BuildContext ctx, T state) builder,
  {List<dynamic> Function(T s) memo}
);
```

After:

```dart
Widget build(
  Widget Function(BuildContext ctx, T state) builder,
  {@required List<dynamic> Function(T s) memo}
);
```

`consumer.getState`: remove the API.

## [2.0.2] - Update readme

## [2.0.1] - Add Deprecated to getState

@Deprecated('remove getState to v2.2.0, use consumer.state replace consumer.getState()')

## [2.0.0] - Change build API

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

## [1.0.6] - memo param is option

## [1.0.5] - Public Consumer.state

## [1.0.4] - Update Dart DOC

## [1.0.3] - Update readme

- Add FAQ

## [1.0.2] - Add Chinese README-CN.md

## [1.0.1] - Update readme

## [1.0.0] - Update readme

## [0.2.2] - Update readme

## [0.2.1] - Update readme

## [0.2.0] - Change to New API, We can create sub consumer

## [0.1.4] - Delete shouldWidgetUpdate API

## [0.1.3] - Update readme

## [0.1.2] - Update readme

## [0.1.1] - Add code documents

## [0.1.0] - Init package

- Update this state manage, use react-consumer style
