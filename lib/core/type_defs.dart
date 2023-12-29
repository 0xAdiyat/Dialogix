import 'package:dialogix/core/failure.dart';
import 'package:fpdart/fpdart.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef NotFutureEither<T> = Either<Failure, T>;
typedef FutureVoid = FutureEither<void>;
