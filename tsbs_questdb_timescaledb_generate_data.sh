# Generate 1 day worth of DevOps data using TSBS for QuestDB and TimescaleDB

# Go to the script library
cd ~/tmp/go/bin/

# Run the following command to generate data for QuestDB
./tsbs_generate_data \
--use-case="devops" --seed=123 --scale=200 \
--timestamp-start="2016-01-01T00:00:00Z" \
--timestamp-end="2016-01-02T00:00:00Z" \
--log-interval="10s" --format="influx" > /tmp/questdb-data

# Run the following command to generate data for TimescaleDB 
./tsbs_generate_data \
   --use-case="devops" --seed=123 --scale=200 \
   --timestamp-start="2016-01-01T00:00:00Z" \
   --timestamp-end="2016-01-02T00:00:00Z" \
   --log-interval="10s" --format="timescaledb" > /tmp/timescaledb-data