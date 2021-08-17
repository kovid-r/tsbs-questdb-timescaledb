
# [QuestDB vs. TimescaleDB](https://medium.com/@kovidrathee/questdb-vs-timescaledb-38160a361c0e)

Use the following GitHub Gists to follow along the TSBS tutorial for running a benchmark:

 1. [Install TSBS, QuestDB (Docker), and TimescaleDB (Docker) for TSBS Benchmarking](https://gist.github.com/kovid-r/1be0984ac96ae0f7403e2688a6e8737d).
 2. [Generate 1 day worth of DevOps data using TSBS for QuestDB and TimescaleDB for 200 devices](https://gist.github.com/kovid-r/4999cde900cc570601ccdb4fb5401998).
 3. [Load a day's worth of data for 9 metrics collected over 200 devices. Use 8 parallel workers to load data](https://gist.github.com/kovid-r/d8ce5d300c8fa94dcb3c80a5e67f2b41).
 4. [Generate queries for QuestDB and TimescaleDB for benchmarking](https://gist.github.com/kovid-r/3d7e7fb0dbfc7c689ce4e761a03df839).
 5. [Read benchmarking TSBS commands for QuestDB and TimescaleDB](https://gist.github.com/kovid-r/ed58699001cb75ba4a54b3d6874b97b8).

Here's the output I got when I ran the read and write workload on TimescaleDB and QuestDB using TSBS on 16-core Intel(R) Xeon(R) Platinum 8175M CPU @ 2.50GHz with 128 GB RAM on AWS EC2:

## Load Data into TimescaleDB

```
[root@benchmark-machine bin]# ./tsbs_load config --target=timescaledb --data-source=FILE
Wrote example config to: ./config.yaml
[root@benchmark-machine bin]# vi config.yaml
[root@benchmark-machine bin]# ./tsbs_load load timescaledb --config=./config.yaml
Using config file: ./config.yaml
time,per. metric/s,metric total,overall metric/s,per. row/s,row total,overall row/s
1629196079,3343710.56,3.343880E+07,3343710.56,297984.90,2.980000E+06,297984.90
1629196089,3175564.14,6.519620E+07,3259637.15,282984.33,5.810000E+06,290484.60
1629196099,2648673.83,9.168160E+07,3055996.77,236011.93,8.170000E+06,272328.29
1629196109,2940420.40,1.210848E+08,3027103.82,262008.95,1.079000E+07,269748.56
1629196119,2614684.97,1.472316E+08,2944620.53,233000.44,1.312000E+07,262398.98
Summary:
loaded 174528000 metrics in 59.376sec with 8 workers (mean rate 2939386.10 metrics/sec)
loaded 15552000 rows in 59.376sec with 8 workers (mean rate 261925.49 rows/sec)
```

## Load Data into QuestDB

```
[root@benchmark-machine bin]# ./tsbs_load_questdb --file /tmp/questdb-data --workers 8
time,per. metric/s,metric total,overall metric/s,per. row/s,row total,overall row/s
1629196151,9492502.44,9.494000E+07,9492502.44,845866.55,8.460000E+06,845866.55
Summary:
loaded 174528000 metrics in 18.223sec with 8 workers (mean rate 9577373.06 metrics/sec)
loaded 15552000 rows in 18.223sec with 8 workers (mean rate 853429.28 rows/sec)
```

## Generate Queries for TimescaleDB

```
[root@benchmark-machine bin]# ./tsbs_generate_queries --use-case="devops" --seed=123 --scale=200 \
> --timestamp-start="2016-01-01T00:00:00Z" \
> --timestamp-end="2016-01-02T00:00:01Z" \
> --queries=1000 --query-type="high-cpu-all" --format="timescaledb" \
>  > /tmp/timescaledb-queries-high-cpu-all
TimescaleDB CPU over threshold, all hosts: 1000 points
```
  
## Generate Queries for QuestDB

```
[root@benchmark-machine bin]# ./tsbs_generate_queries --use-case="devops" --seed=123 --scale=200 \
> --timestamp-start="2016-01-01T00:00:00Z" \
> --timestamp-end="2016-01-02T00:00:01Z" \
> --queries=1000 --query-type="high-cpu-all" --format="questdb" \
>  > /tmp/queries_questdb-high-cpu-all
QuestDB CPU over threshold, all hosts: 1000 points
```

## Run Queries on TimescaleDB

```
[root@benchmark-machine bin]# cat /tmp/timescaledb-queries-high-cpu-all | ./tsbs_run_queries_timescaledb --workers=8 \
> --postgres="host=localhost user=postgres password=password sslmode=disable" --print-interval 500
After 500 queries with 8 workers:
Interval query rate: 25.74 queries/sec Overall query rate: 25.74 queries/sec
TimescaleDB CPU over threshold, all hosts:
min: 224.93ms, med: 273.57ms, mean: 309.01ms, max: 580.13ms, stddev: 76.37ms, sum: 154.5sec, count: 500
all queries :
min: 224.93ms, med: 273.57ms, mean: 309.01ms, max: 580.13ms, stddev: 76.37ms, sum: 154.5sec, count: 500

After 1000 queries with 8 workers:
Interval query rate: 25.85 queries/sec Overall query rate: 25.80 queries/sec
TimescaleDB CPU over threshold, all hosts:
min: 222.49ms, med: 274.94ms, mean: 308.60ms, max: 580.13ms, stddev: 73.70ms, sum: 308.6sec, count: 1000
all queries :
min: 222.49ms, med: 274.94ms, mean: 308.60ms, max: 580.13ms, stddev: 73.70ms, sum: 308.6sec, count: 1000

Run complete after 1000 queries with 8 workers (Overall query rate 25.78 queries/sec):
TimescaleDB CPU over threshold, all hosts:
min: 222.49ms, med: 274.94ms, mean: 308.60ms, max: 580.13ms, stddev: 73.70ms, sum: 308.6sec, count: 1000
all queries :
min: 222.49ms, med: 274.94ms, mean: 308.60ms, max: 580.13ms, stddev: 73.70ms, sum: 308.6sec, count: 1000
wall clock time: 38.827242sec
```

## Run Queries on QuestDB

```
[root@benchmark-machine bin]# ./tsbs_run_queries_questdb --file /tmp/queries_questdb-high-cpu-all --workers=8 --print-interval 500
Added index to hostname column of cpu table
After 500 queries with 8 workers:
Interval query rate: 69.12 queries/sec Overall query rate: 69.12 queries/sec
QuestDB CPU over threshold, all hosts:
min: 92.71ms, med: 109.10ms, mean: 115.26ms, max: 382.57ms, stddev: 24.44ms, sum: 57.6sec, count: 500
all queries :
min: 92.71ms, med: 109.10ms, mean: 115.26ms, max: 382.57ms, stddev: 24.44ms, sum: 57.6sec, count: 500

After 1000 queries with 8 workers:
Interval query rate: 71.60 queries/sec Overall query rate: 70.34 queries/sec
QuestDB CPU over threshold, all hosts:
min: 92.71ms, med: 109.10ms, mean: 113.32ms, max: 382.57ms, stddev: 19.34ms, sum: 113.3sec, count: 1000
all queries :
min: 92.71ms, med: 109.10ms, mean: 113.32ms, max: 382.57ms, stddev: 19.34ms, sum: 113.3sec, count: 1000

Run complete after 1000 queries with 8 workers (Overall query rate 70.18 queries/sec):
QuestDB CPU over threshold, all hosts:
min: 92.71ms, med: 109.10ms, mean: 113.32ms, max: 382.57ms, stddev: 19.34ms, sum: 113.3sec, count: 1000
all queries :
min: 92.71ms, med: 109.10ms, mean: 113.32ms, max: 382.57ms, stddev: 19.34ms, sum: 113.3sec, count: 1000
wall clock time: 14.275811sec
```

## License
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)