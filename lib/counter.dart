import 'package:flutter/cupertino.dart';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class Counter extends GetxController {
  RxInt count1 = 0.obs;
  RxInt count2 = 0.obs;
  count1Increment() => count1.value++;
  count2Increment() => count2.value++;
  int get sum => count1.value + count2.value;
}
