/// Result type for operations that can fail (no external deps).
/// Use [Result.success] or [Result.failure].
sealed class Result<T, E> {
  const Result();
}

final class Success<T, E> extends Result<T, E> {
  const Success(this.value);
  final T value;
}

final class Failure<T, E> extends Result<T, E> {
  const Failure(this.error);
  final E error;
}

extension ResultExtension<T, E> on Result<T, E> {
  bool get isSuccess => this is Success<T, E>;
  bool get isFailure => this is Failure<T, E>;
  T? get valueOrNull => switch (this) {
        Success(:final value) => value,
        Failure() => null,
      };
  E? get errorOrNull => switch (this) {
        Success() => null,
        Failure(:final error) => error,
      };
  R when<R>({required R Function(T) success, required R Function(E) failure}) {
    return switch (this) {
      Success(:final value) => success(value),
      Failure(:final error) => failure(error),
    };
  }
}
