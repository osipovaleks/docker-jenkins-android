#!/bin/sh

echo "Start TravisTest.sh"
echo "Waiting 30 second for starting Jenkins"

sleep 30

echo "Check logs"

expected="INFO: Jenkins is fully up and running"
actual=`docker logs --tail "1" jenkins`
#remove last spec symbol
actual=$(echo $actual|tr -d '\r')

echo "Expecting: $expected"
echo "Container says: $actual"

if [ "$expected" = "$actual" ]; then
  echo "Test passed"
  exit 0
else
  echo "Test failed"
  exit 1
fi
