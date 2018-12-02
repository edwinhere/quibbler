#!/bin/bash
set -e
pg_dump -h localhost -p 6543 -d quibbler -U lovegood -W -Ft > backup.tar
