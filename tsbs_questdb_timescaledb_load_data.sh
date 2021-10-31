# Load a day's worth of data for 9 metrics collected over 200 devices. Use 8 parallel workers to load data.

# Go to the following directory
cd ~/tmp/go/bin

# Create the a config file
./tsbs_load config --target=timescaledb --data-source=FILE

# Edit the config.yaml file
# 1. Change the source file name to /tmp/timescaledb-data
# 2. Change the password for TimescaleDB to password
# 3. Change the number of workers to 8

./tsbs_load load timescaledb --config=./config.yaml

# Load data into QuestDB

./tsbs_load_questdb --file /tmp/questdb-data --workers 8