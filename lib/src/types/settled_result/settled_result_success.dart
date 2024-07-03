import 'package:future_pool/src/types/settled_result/settled_result.dart';
import 'package:future_pool/src/types/settled_result/settled_status.dart';

class SettledSuccessResult<T> implements SettledResult<T> {
  @override
  final SettledStatus status = SettledStatus.fulfilled;

  @override
  final T value;

  @override
  final Object? reason = null;

  SettledSuccessResult(this.value);
}
