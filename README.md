# consumer

flutter consumer is like [react-consumer](https://github.com/ymzuiku/react-consumer) state manage, use Stream at dart, consumer have memo and shoudWidgetUpdate function to intercept update.

API Document:

- [https://pub.flutter-io.cn/documentation/consumer/latest/](https://pub.flutter-io.cn/documentation/consumer/latest/)
- [https://pub.dev/documentation/consumer/latest/](https://pub.dev/documentation/consumer/latest/)

### Install consumer

Change `pubspec.yaml`:

```yaml
dependencies:
  consumer: ^0.1.2
```

## Getting Started

### 1. Register Stream use state:

```dart
// Create app's state, one project only need one app's state
class AppState {
  String name = '';
}

void main() async {
  // Use app's state init stream.
  Store.initState(AppState());

  runApp(MyApp());
}

```

### 2. Linsten state:

```dart
class SomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Welcome use consumer'),
            // Only update this widget
            Consumer<AppState>(
              // [option] only at state.name changed, need update this widget.
              memo: (state) => [state.name],
              // [option] if return true, need update this widget.
              shouldWidgetUpdate: (state) => state.length > 3,
              builder: (ctx, state) {
                return Text('name ${state.name}');
              },
            ),
            TextField(
              onChanged: (v) {
                // Triggle stream listen
                // At business project, move this function to actions scripts fold, please.
                Store.setState<AppState>((state) {
                  state.name = v;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

### 3. break Single data flow

```dart
class SomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Welcome use consumer'),
            Consumer<AppState>(
              // only listen filter = 'onlyUser'
              filter: 'onlyUser',
              builder: (ctx, state) {
                return Text('name ${state.name}');
              },
            ),
            TextField(
              onChanged: (v) {
                // Triggle stream listen
                Store.setState<AppState>((state) {
                  state.name = v;
                }, filter: 'onlyUser');
              },
            ),
          ],
        ),
      ),
    );
  }
}

```

# That's all

Thank you read and use consumer
