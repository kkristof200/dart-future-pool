import 'package:future_pool/src/types/settled_result/settled_status.dart';

class SettledResult<T> {
  final SettledStatus status = SettledStatus.rejected;

  final T?            value = null;
  final Object?       reason = null;
}
