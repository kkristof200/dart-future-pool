import 'dart:async';
import 'dart:collection';

import 'package:future_pool/src/types/callbacks/complete_callback.dart';
import 'package:future_pool/src/types/callbacks/fail_callback.dart';
import 'package:future_pool/src/types/callbacks/success_callback.dart';
import 'package:future_pool/src/types/settled_result/settled_result.dart';
import 'package:future_pool/src/types/settled_result/settled_result_fail.dart';
import 'package:future_pool/src/types/settled_result/settled_result_success.dart';
import 'package:future_pool/src/utils/locked_var.dart';

class FuturePool {
  static Future<List<SettledResult<T>>> allSettled<T>(
    List<Future<T> Function()> futures,
    {
      int maxConcurrency = 5,

      OnCompleteCallback<T>?      onFutureCompleted,
      OnFutureSuccessCallback<T>? onFutureSuccess,
      OnFutureFailCallback<T>?    onFutureFail
    }
  ) async {
    final results = List<SettledResult<T>?>.filled(futures.length, null);
    final completer = Completer<List<SettledResult<T>>>();

    final tasksToDo = Queue<MapEntry<int, Future<T> Function()>>.from(futures.asMap().entries);
    final LockedVar<int> lockedRunCount = LockedVar(0);

    Future<int> runCount() async {
      return await lockedRunCount.get();
    }
    Future<int> addRunCount(int toAdd) async {
      return lockedRunCount.update((value) => value + toAdd);
    }

    void runNext() async {
      if (tasksToDo.isEmpty && await runCount() == 0) {
        completer.complete(results.cast<SettledResult<T>>());
        return;
      }

      while (await runCount() < maxConcurrency && tasksToDo.isNotEmpty) {
        await addRunCount(1);
        final task = tasksToDo.removeFirst();
        final index = task.key;

        task.value().then((value) {
          final result = SettledSuccessResult<T>(value);
          results[index] = result;
          onFutureCompleted?.call(result, index);
          onFutureSuccess?.call(result, index);
        }).catchError((error) {
          final result = SettledFailResult<T>(error);
          results[index] = result;
          onFutureCompleted?.call(result, index);
          onFutureFail?.call(result, index);
        }).whenComplete(() {
          addRunCount(-1).then((_) {
            runNext();
          });
        });
      }
    }

    runNext();
    return completer.future;
  }
}
