#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting Redis Cluster Setup...${NC}"

# Create redis_conf directory if it doesn't exist
mkdir -p redis_conf

# Function to create Redis config file
create_redis_conf() {
    local port=$1
    cat > redis_conf/redis-$port.conf << EOF
port $port
cluster-enabled yes
cluster-config-file nodes-$port.conf
cluster-node-timeout 5000
appendonly yes
dir ./
daemonize yes
protected-mode no
bind 0.0.0.0
EOF
}

# Create configurations for all nodes
echo -e "${GREEN}Creating Redis configurations...${NC}"
for port in 6379 6380 6381 6382 6383 6384; do
    create_redis_conf $port
done

# Kill any existing Redis processes
echo -e "${GREEN}Cleaning up existing Redis processes...${NC}"
pkill -f redis-server

# Start Redis servers
echo -e "${GREEN}Starting Redis servers...${NC}"
for port in 6379 6380 6381 6382 6383 6384; do
    redis-server redis_conf/redis-$port.conf
    sleep 1
done

# Wait for servers to start
echo -e "${GREEN}Waiting for servers to start...${NC}"
sleep 5

# Check if all servers are running
echo -e "${GREEN}Verifying Redis servers are running...${NC}"
for port in 6379 6380 6381 6382 6383 6384; do
    if ! redis-cli -p $port ping > /dev/null 2>&1; then
        echo -e "${RED}Redis server on port $port is not running${NC}"
        exit 1
    fi
done

# Create Redis Cluster
echo -e "${GREEN}Creating Redis Cluster...${NC}"
redis-cli --cluster create 127.0.0.1:6379 127.0.0.1:6380 127.0.0.1:6381 127.0.0.1:6382 127.0.0.1:6383 127.0.0.1:6384 --cluster-replicas 1 --cluster-yes

# Wait for cluster to stabilize
echo -e "${GREEN}Waiting for cluster to stabilize...${NC}"
sleep 5

# Verify cluster status
echo -e "${GREEN}Verifying cluster status...${NC}"
redis-cli -p 6379 cluster nodes

# Test master-slave replication
echo -e "${GREEN}Testing master-slave replication...${NC}"

# Test first pair (6379 -> 6382)
echo -e "${GREEN}Testing first pair (6379 -> 6382)...${NC}"
redis-cli -c -p 6379 SET test:0 "Hello from master 6379"
redis-cli -c -p 6382 GET test:0

# Test second pair (6380 -> 6383)
echo -e "${GREEN}Testing second pair (6380 -> 6383)...${NC}"
redis-cli -c -p 6380 SET test:5461 "Hello from master 6380"
redis-cli -c -p 6383 GET test:5461

# Test third pair (6381 -> 6384)
echo -e "${GREEN}Testing third pair (6381 -> 6384)...${NC}"
redis-cli -c -p 6381 SET test:10923 "Hello from master 6381"
redis-cli -c -p 6384 GET test:10923

echo -e "${GREEN}Redis Cluster setup completed successfully!${NC}" 