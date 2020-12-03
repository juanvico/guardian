#!/bin/sh
./bin/guardian eval "Guardian.ReleaseTasks.migrate"
./bin/guardian start
