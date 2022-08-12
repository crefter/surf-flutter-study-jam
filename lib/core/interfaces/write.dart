abstract class IWrite<T> {
  Future<void> write(String key, T value);
}