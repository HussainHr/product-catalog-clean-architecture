import 'package:product_catalog_application/core/error/failures.dart';

sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

final class ErrorResult<T> extends Result<T> {
  const ErrorResult(this.failure);

  final Failure failure;
}

extension ResultExtension<T> on Result<T> {
  bool get isSuccess => this is Success<T>;

  bool get isError => this is ErrorResult<T>;

  T? get valueOrNull => switch (this) {
        Success<T>(:final value) => value,
        ErrorResult<T>() => null,
      };

  Failure? get failureOrNull => switch (this) {
        Success<T>() => null,
        ErrorResult<T>(:final failure) => failure,
      };
}
