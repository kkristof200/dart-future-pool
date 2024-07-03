import 'package:future_pool/src/types/settled_result/settled_result_fail.dart';

typedef OnFutureFailCallback<T> = void Function(SettledFailResult<T> result, int index);
