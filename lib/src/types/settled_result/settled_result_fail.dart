import 'package:future_pool/src/types/settled_result/settled_result.dart';
import 'package:future_pool/src/types/settled_result/settled_status.dart';

class SettledFailResult<T> implements SettledResult<T> {
  @override
  final SettledStatus status = SettledStatus.rejected;

  @override
  final T? value = null;

  @override
  final Object reason;

  SettledFailResult(this.reason);
}
