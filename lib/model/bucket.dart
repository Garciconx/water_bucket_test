// Bucket Model.

class Bucket {
  int volume;
  int value;

  Bucket({
    required this.volume,
    required this.value,
  });

  fill() {
    value = volume;
  }

  empty() {
    value = 0;
  }

  transfer_from_this({
    required Bucket another_bucket,
  }) {
    value = (value - (another_bucket.volume - another_bucket.value))
        .clamp(0, volume);
  }

  transfer_to_this({
    required int another_bucket_value,
  }) {
    value = (value + another_bucket_value).clamp(value, volume);
  }
}
