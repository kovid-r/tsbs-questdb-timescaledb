# Install TSBS, QuestDB (Docker), and TimescaleDB (Docker) for TSBS Benchmarking.

# TSBS - create a temporary directory for the Go binaries
mkdir -p ~/tmp/go/src/github.com/timescale/
cd ~/tmp/go/src/github.com/timescale/

# Clone the TSBS repository, build test and install Go binaries:
git clone git@github.com:questdb/tsbs.git
cd ~/tmp/go/src/github.com/timescale/tsbs/ && git checkout questdb-tsbs-load-new
GOPATH=~/tmp/go go build -v ./...
GOPATH=~/tmp/go go test -v github.com/timescale/tsbs/cmd/tsbs_load_questdb
GOPATH=~/tmp/go go install -v ./...

# Start QuestDB in Docker
docker run -p 9000:9000 -p 9009:9009 questdb/questdb:6.0.4

# Start TimescaleDB in Docker
docker run -d --name timescaledb -p 5432:5432 -e POSTGRES_PASSWORD=password timescale/timescaledb:latest-pg12