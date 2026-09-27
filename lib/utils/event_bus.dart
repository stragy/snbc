typedef EventCallback = void Function(dynamic arg);

class EventBus {
  // Private constructor
  EventBus._internal();

  // Singleton instance
  static final EventBus _singleton = EventBus._internal();

  // Factory constructor
  factory EventBus() => _singleton;

  // Map of event name to list of subscribers
  final Map<Object, List<EventCallback>> _eMap = <Object, List<EventCallback>>{};

  // Add a subscriber
  void on(Object eventName, EventCallback f) {
    final list = _eMap.putIfAbsent(eventName, () => <EventCallback>[]);
    list.add(f);
  }

  // Remove a subscriber; if f is null, remove all subscribers of the event
  void off(Object eventName, [EventCallback? f]) {
    final list = _eMap[eventName];
    if (list == null) return;
    if (f == null) {
      _eMap.remove(eventName);
    } else {
      list.remove(f);
      if (list.isEmpty) {
        _eMap.remove(eventName);
      }
    }
  }

  // Emit an event
  void send(Object eventName, [dynamic arg]) {
    final list = _eMap[eventName];
    if (list == null) return;
    // Iterate over a copy to avoid issues if handlers modify subscriptions
    for (final cb in List<EventCallback>.from(list)) {
      cb(arg);
    }
  }
}