import 'package:future_pool/src/types/settled_result/settled_result.dart';

typedef OnCompleteCallback<T> = void Function(SettledResult<T> result, int index);
