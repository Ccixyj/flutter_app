import 'package:event_bus/event_bus.dart';

EventBus eventBus = new EventBus();

class ThemeEvent {}

class ToastEvent {
  String content;

  ToastEvent(this.content);

  @override
  String toString() {
    return 'ToastEvent{content: $content}';
  }


}

