import 'package:future_pool/src/types/settled_result/settled_result_success.dart';

typedef OnFutureSuccessCallback<T> = void Function(SettledSuccessResult<T> result, int index);
