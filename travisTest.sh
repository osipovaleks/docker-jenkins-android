#!/bin/sh

echo "Start TravisTest.sh"
echo "Waiting 20 second for starting Jenkins"

sleep 20

running=$(docker container inspect -f '{{.State.Running}}' jenkins)

if [ $running == "true" ]; then
  echo "Test passed"
  exit 0
else
  echo "Test failed"
  exit 1
fi
