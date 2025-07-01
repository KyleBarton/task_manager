// Taken from https://github.com/initialcapacity/flutter-starter
sealed class Result<T, E> {}

final class Ok<T, E> implements Result<T, E> {
  const Ok(this.value);

  final T value;
}

final class Err<T, E> implements Result<T, E> {
  const Err(this.error);

  final E error;
}

extension ResultExtensions<T,E> on Result<T,E> {
  T expect() => switch (this) {
    Ok(:final value) => value,
    Err(:final error) => throw Exception("Expected ok, got $error"),
  };
}