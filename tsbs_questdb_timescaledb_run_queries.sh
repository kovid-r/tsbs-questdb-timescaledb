# Read benchmarking TSBS commands for QuestDB and TimescaleDB.

# Go to the following directory
cd ~/tmp/go/bin/

# Run the read benchmarking queries for TimescaleDB
cat /tmp/timescaledb-queries-high-cpu-all | ./tsbs_run_queries_timescaledb --workers=8 \
  --postgres="host=localhost user=postgres password=password sslmode=disable" --print-interval 500
  
# Run the read benchmarking queries for QuestDB
./tsbs_run_queries_questdb --file /tmp/queries_questdb-high-cpu-all --workers=8 --print-interval 500