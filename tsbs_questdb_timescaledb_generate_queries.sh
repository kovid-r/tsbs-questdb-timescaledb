# Generate queries for QuestDB and TimescaleDB for benchmarking.

# Go to the following directory
cd ~/tmp/go/bin
    
# Generate QuestDB queries for query-type high-cpu-all     
./tsbs_generate_queries --use-case="devops" --seed=123 --scale=200 \
    --timestamp-start="2016-01-01T00:00:00Z" \
    --timestamp-end="2016-01-02T00:00:01Z" \
    --queries=1000 --query-type="high-cpu-all" --format="questdb" \
    > /tmp/queries_questdb-high-cpu-all
     
# Generate TimescaleDB queries for query-type high-cpu-all     
./tsbs_generate_queries --use-case="devops" --seed=123 --scale=200 \
    --timestamp-start="2016-01-01T00:00:00Z" \
    --timestamp-end="2016-01-02T00:00:01Z" \
    --queries=1000 --query-type="high-cpu-all" --format="timescaledb" \
    > /tmp/timescaledb-queries-high-cpu-all