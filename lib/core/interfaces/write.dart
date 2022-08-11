abstract class IWrite<T> {
  Future<void> write(T value);
}