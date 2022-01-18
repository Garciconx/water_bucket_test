import 'package:flutter/material.dart';
import 'package:water_bucket_test/model/bucket.dart';

class BucketContainer extends StatefulWidget {
  const BucketContainer({
    required this.bucket,
    required this.update_bucket_function,
    required this.bucket_index,
    required this.title,
  });

  final Bucket bucket;
  final Function update_bucket_function;
  final int bucket_index;
  final String title;

  @override
  State<BucketContainer> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<BucketContainer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screen_height = MediaQuery.of(context).size.height;
    double screen_width = MediaQuery.of(context).size.width;
    double bucket_border_radius_1 = (screen_width / 10);
    double bucket_border_radius_2 = (screen_width / 3);

    return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(3.0),
      height: screen_width / 2,
      width: screen_width / 3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.blueAccent,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(5.0),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(bucket_border_radius_1),
                    color: Colors.grey,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  height: screen_width / 10,
                  width: screen_width / 4.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(bucket_border_radius_2),
                    color: Colors.blue,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  alignment: Alignment.center,
                  child: Text(
                    widget.bucket.volume.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.remove,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        widget.update_bucket_function(
                            widget.bucket_index, false);
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        widget.update_bucket_function(
                            widget.bucket_index, true);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
