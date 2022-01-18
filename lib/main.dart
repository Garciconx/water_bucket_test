import 'package:flutter/material.dart';
import 'package:water_bucket_test/model/bucket.dart';
import 'package:water_bucket_test/view/bucket_container.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Water Bucket Challenge',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> operations = [];

  Bucket bucket_x = Bucket(volume: 0, value: 0);
  Bucket bucket_y = Bucket(volume: 0, value: 0);
  Bucket bucket_z = Bucket(volume: 0, value: 0);

  int operation_cycles = 0;
  bool no_solution = false;

  int bucket_volume_upper_limit = 1000;

  update_bucket(int bucket_index, int new_bucket_volume) {
    clear_values();

    new_bucket_volume = new_bucket_volume.clamp(0, bucket_volume_upper_limit);

    if (bucket_index == 0) {
      bucket_x.volume = new_bucket_volume;
    } else if (bucket_index == 1) {
      bucket_y.volume = new_bucket_volume;
    } else if (bucket_index == 2) {
      bucket_z.volume = new_bucket_volume;
    }

    setState(() {});
  }

  clear_values() {
    operations.clear();
    operation_cycles = 0;
    bucket_x.value = 0;
    bucket_y.value = 0;
    bucket_z.value = 0;
    no_solution = false;
    setState(() {});
  }

  init_calculate_operations() {
    clear_values();
    calculate_operations();
  }

  calculate_operations() async {
    if (bucket_x.volume != 0 && bucket_y.volume != 0 && bucket_z.volume != 0) {
      if (operation_cycles < bucket_volume_upper_limit * 3) {
        if (bucket_x.volume < bucket_z.volume &&
            bucket_y.volume < bucket_z.volume) {
          // No solution
          no_solution = true;
        } else {
          if (bucket_z.volume % bucket_x.volume == 0 ||
              bucket_z.volume % bucket_y.volume == 0) {
            // Proceed
            await proceed_with_strategy(strategy_index: 0);
          } else if (bucket_z.volume %
                  (bucket_x.volume - bucket_y.volume).abs() ==
              0) {
            // Proceed
            await proceed_with_strategy(strategy_index: 1);
          } else {
            // No solution
            no_solution = true;
          }
        }

        if (no_solution) {
          operations.add("There is no solution");
          print(operations.last);
          setState(() {});
        } else {
          print(operations.last);

          if (bucket_x.value == bucket_z.volume ||
              bucket_y.value == bucket_z.volume) {
            // Show result
            setState(() {});
          } else {
            // Repeat process
            calculate_operations();
          }
        }
        operation_cycles++;
      }
    } else {
      operations.add("There is no solution");
      print(operations.last);
      setState(() {});
    }
  }

  Future<String> proceed_with_strategy({
    required int strategy_index,
  }) async {
    Bucket smaller_bucket = Bucket(volume: 0, value: 0);
    Bucket bigger_bucket = Bucket(volume: 0, value: 0);

    if (bucket_x.volume < bucket_y.volume) {
      smaller_bucket = bucket_x;
      bigger_bucket = bucket_y;
    } else {
      bigger_bucket = bucket_x;
      smaller_bucket = bucket_y;
    }

    List<Bucket> buckets = [];

    if (smaller_bucket.volume == bucket_z.volume) {
      smaller_bucket.fill();
      buckets = [smaller_bucket, bigger_bucket];
    } else if (bigger_bucket.volume == bucket_z.volume) {
      bigger_bucket.fill();
      buckets = [smaller_bucket, bigger_bucket];
    } else {
      if (strategy_index == 0) {
        buckets = await strategy_1(
          smaller_bucket: smaller_bucket,
          bigger_bucket: bigger_bucket,
        );
      } else {
        buckets = await strategy_2(
          smaller_bucket: smaller_bucket,
          bigger_bucket: bigger_bucket,
        );
      }
    }

    if (bucket_x.volume < bucket_y.volume) {
      bucket_x = buckets[0];
      bucket_y = buckets[1];
    } else {
      bucket_x = buckets[1];
      bucket_y = buckets[0];
    }

    String new_operation =
        "|Bucket X: ${bucket_x.value} | Bucket Y: ${bucket_y.value}|\n";

    operations.add(new_operation);
    return await "result";
  }

  Future<List<Bucket>> strategy_1({
    required Bucket smaller_bucket,
    required Bucket bigger_bucket,
  }) async {
    if (smaller_bucket.value == 0) {
      smaller_bucket.fill();
    } else {
      int smaller_bucket_value = smaller_bucket.value;
      smaller_bucket.transfer_from_this(another_bucket: bigger_bucket);
      bigger_bucket.transfer_to_this(
          another_bucket_value: smaller_bucket_value);
    }

    return [smaller_bucket, bigger_bucket];
  }

  Future<List<Bucket>> strategy_2({
    required Bucket smaller_bucket,
    required Bucket bigger_bucket,
  }) async {
    if (smaller_bucket.value == 0 && bigger_bucket.value == 0) {
      bigger_bucket.fill();
    } else if (smaller_bucket.value == 0 && bigger_bucket.value != 0) {
      int bigger_bucket_value = bigger_bucket.value;
      bigger_bucket.transfer_from_this(another_bucket: smaller_bucket);
      smaller_bucket.transfer_to_this(
          another_bucket_value: bigger_bucket_value);
    } else if (smaller_bucket.value != 0 && bigger_bucket.value != 0) {
      if (bigger_bucket.value == bigger_bucket.volume) {
        int bigger_bucket_value = bigger_bucket.value;
        bigger_bucket.transfer_from_this(another_bucket: smaller_bucket);
        smaller_bucket.transfer_to_this(
            another_bucket_value: bigger_bucket_value);
      } else {
        smaller_bucket.empty();
      }
    } else if (smaller_bucket.value != 0 && bigger_bucket.value == 0) {
      bigger_bucket.fill();
    }

    return [smaller_bucket, bigger_bucket];
  }

  @override
  Widget build(BuildContext context) {
    double screen_height = MediaQuery.of(context).size.height;
    double screen_width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Water Bucket Challenge',
          ),
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              width: screen_width / 3,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BucketContainer(
                        bucket: bucket_x,
                        update_bucket_function: update_bucket,
                        bucket_index: 0,
                        title: "Bucket X",
                      ),
                      BucketContainer(
                        bucket: bucket_y,
                        update_bucket_function: update_bucket,
                        bucket_index: 1,
                        title: "Bucket Y",
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Target Volume",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  BucketContainer(
                    bucket: bucket_z,
                    update_bucket_function: update_bucket,
                    bucket_index: 2,
                    title: "Bucket Z",
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              alignment: Alignment.center,
              child: operations.length > 0
                  ? Column(
                      children: [
                        Text(
                          "Operations:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          operations.join(),
                          maxLines: bucket_volume_upper_limit * 3,
                        )
                      ],
                    )
                  : Container(),
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: init_calculate_operations,
          tooltip: 'Calculate Operations',
          child: const Icon(Icons.play_arrow_rounded),
        ),
      ),
    );
  }
}
