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

  update_bucket(int bucket_index, bool add_volume) {
    clear_values();

    if (add_volume) {
      if (bucket_index == 0) {
        bucket_x.volume = (bucket_x.volume + 1).clamp(0, 20);
      } else if (bucket_index == 1) {
        bucket_y.volume = (bucket_y.volume + 1).clamp(0, 20);
      } else if (bucket_index == 2) {
        bucket_z.volume = (bucket_z.volume + 1).clamp(0, 20);
      }
    } else {
      if (bucket_index == 0) {
        bucket_x.volume = (bucket_x.volume - 1).clamp(0, 20);
      } else if (bucket_index == 1) {
        bucket_y.volume = (bucket_y.volume - 1).clamp(0, 20);
      } else if (bucket_index == 2) {
        bucket_z.volume = (bucket_z.volume - 1).clamp(0, 20);
      }
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
      if (operation_cycles < 31) {
        operation_cycles++;

        if (bucket_x.volume < bucket_z.volume &&
            bucket_y.volume < bucket_z.volume) {
          // No solution
          no_solution = true;
        } else {
          if (bucket_z.volume % bucket_x.volume == 0 ||
              bucket_z.volume % bucket_y.volume == 0) {
            // Proceed
            await proceed_to_operation();
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
      }
    } else {
      operations.add("There is no solution");
      print(operations.last);
      setState(() {});
    }
  }

  Future<String> proceed_to_operation() async {
    if (bucket_x.volume < bucket_y.volume) {
      if (bucket_x.value == 0) {
        bucket_x.fill();
      } else {
        int bucket_x_value = bucket_x.value;
        bucket_x.transfer_from_this(another_bucket: bucket_y);
        bucket_y.transfer_to_this(another_bucket_value: bucket_x_value);
      }
    } else {
      if (bucket_y.value == 0) {
        bucket_y.fill();
      } else {
        int bucket_y_value = bucket_y.value;
        bucket_y.transfer_from_this(another_bucket: bucket_x);
        bucket_x.transfer_to_this(another_bucket_value: bucket_y_value);
      }
    }

    String new_operation =
        "|Bucket X: ${bucket_x.value} | Bucket Y: ${bucket_y.value}|\n";

    operations.add(new_operation);
    //operations.add("-----------------------------------------\n");

    return await "result";
  }

  @override
  Widget build(BuildContext context) {
    double screen_height = MediaQuery.of(context).size.height;
    double screen_width = MediaQuery.of(context).size.width;

    return Scaffold(
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
                        maxLines: 24,
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
    );
  }
}
