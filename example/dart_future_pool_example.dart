import 'dart:math';
import 'package:future_pool/future_pool.dart';

Future<int> future() async {
  int seconds = Random().nextInt(5) + 1;
  await Future.delayed(Duration(seconds: seconds));

  return seconds;
}

void main() async {
  final results = await FuturePool.allSettled(
    List<Future<int> Function()>.filled(10, () => future()),
    maxConcurrency: 3,
    // onFutureCompleted: (result, index) {
    //   if (result.status == SettledStatus.fulfilled) {
    //     print('Future $index fulfilled with value: ${result.value}');
    //   } else {
    //     print('Future $index rejected with reason: ${result.reason}');
    //   }
    // },
    onFutureSuccess: (result, index) {
      print('Future $index fulfilled with value: ${result.value}');
    },
    onFutureFail: (result, index) {
      print('Future $index rejected with reason: ${result.reason}');
    },
  );

  print('Finished all results $results');

  for (var result in results) {
    if (result.status == SettledStatus.fulfilled) {
      print('Fulfilled: ${result.value}');
    } else {
      print('Rejected: ${result.reason}');
    }
  }
}
