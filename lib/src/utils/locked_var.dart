import 'package:synchronized/synchronized.dart';

class LockedVar<T> {
  T _value;
  final Lock _lock = Lock();

  LockedVar(
    T initialValue
  ): _value = initialValue;

  Future<T> get() async {
    return await _lock.synchronized(() async {
      return _value;
    });
  }

  set(T value) async {
    return await _lock.synchronized(() async {
      _value = value;
    });
  }

  Future<T> update(T Function(T oldValue) updateFunc) async {
    return await _lock.synchronized(() async {
      _value = updateFunc(_value);

      return _value;
    });
  }
}
