#!/bin/bash
set -e
pg_restore -h localhost -p 6543 -d quibbler -U lovegood -W -Ft $1
