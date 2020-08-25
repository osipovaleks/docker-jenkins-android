#!/bin/sh

echo "Start TravisTest.sh"
echo "Waiting 60 second for starting Jenkins"

sleep 60

echo "Check logs"

expected="Jenkins is fully up and running"
actual=`docker logs --tail "1" jenkins`
#remove last spec symbol
actual=$(echo $actual|tr -d '\r')

echo "Expecting: $expected"
echo "Container says: $actual"

if [[$actual == *"$expected"*]]; then
  echo "Test passed"
  exit 0
else
  echo "Test failed"
  exit 1
fi
