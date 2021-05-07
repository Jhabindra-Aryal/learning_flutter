import 'package:flutter/material.dart';
import 'package:learning/counter.dart';
import 'package:get/get.dart';

void main() {
  runApp(GetMaterialApp(
    home: MyHomePage(),
  ));
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Counter c = Get.put(Counter());
    // final count = Provider.of<Counter>(context, listen: false);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              () => Column(
                children: [
                  Text('count1: ${c.count1.value}'),
                  Text('count2: ${c.count2.value}'),
                  Text('sum: ${c.sum}'),
                  ElevatedButton(
                    onPressed: c.count1Increment,
                    child: Text('Increase Count1'),
                  ),
                  ElevatedButton(
                    onPressed: c.count2Increment,
                    child: Text('Increase Count2'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
