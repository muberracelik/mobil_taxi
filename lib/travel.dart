class Travel {
  int VendorID;
  String tpep_pickup_datetime;
  String tpep_dropoff_datetime;
  int passenger_count;
  double trip_distance;
  int RatecodeID;
  String store_and_fwd_flag;
  int PULocationID;
  int DOLocationID;
  int payment_type;
  double mta_tax;
  double fare_amount;
  double tip_amount;
  double tolls_amount;

  @override
  String toString() {
    return 'Travel{tpep_pickup_datetime: $tpep_pickup_datetime, tpep_dropoff_datetime: $tpep_dropoff_datetime, passenger_count: $passenger_count, trip_distance: $trip_distance, PULocationID: $PULocationID, DOLocationID: $DOLocationID}';
  }

  double extra;
  double congestion_surcharge;
  double improvement_surcharge;
  double total_amount;

  Travel(
      this.VendorID,
      this.tpep_pickup_datetime,
      this.tpep_dropoff_datetime,
      this.passenger_count,
      this.trip_distance,
      this.RatecodeID,
      this.store_and_fwd_flag,
      this.PULocationID,
      this.DOLocationID,
      this.payment_type,
      this.mta_tax,
      this.fare_amount,
      this.tip_amount,
      this.tolls_amount,
      this.extra,
      this.congestion_surcharge,
      this.improvement_surcharge,
      this.total_amount);

  Travel.db(
      this.tpep_pickup_datetime,
      this.tpep_dropoff_datetime,
      this.passenger_count,
      this.trip_distance,
      this.PULocationID,
      this.DOLocationID);
}
