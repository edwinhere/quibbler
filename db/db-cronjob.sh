#!/bin/bash
echo "================================================================================"
date
source /root/.pgvm/pgvm_env
pgvm use 11.1
cd "$(dirname "$0")"
PGPASSWORD=password psql -h localhost -p 6543 -U lovegood -d quibbler < periodic-db-tasks.sql
