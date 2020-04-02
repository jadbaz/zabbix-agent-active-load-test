# Zabbix agent-active load test

## Description
Run N zabbix agent-active Docker containers on the same host in order to perform a load test for a remote server

## Instructions
- Set configuration (below)
- Start load test: `sh start_load_test.sh <start> <end>`
- Stop load test: `sh stop_load_test.sh <start> <end>`

## Configuration
- Mandatory: copy the .env.default to .env and change configuration according to your environment
- Optional: override variables in vars file
