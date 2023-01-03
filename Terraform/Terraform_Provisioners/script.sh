#!/bin/bash
for I in {1..2}
do
echo "${I}"
sleep 1
done
echo "Changed the script file for null_resource example 1"
for I in {3..4}
do
echo "${I}"
sleep 1
done

echo "Changed the script file for null_resource example 2"

apt update
apt install stress
mkdir /tmp/testfile
for I in {1..10}; do
echo $(date) > /tmp/testfile/file-${I}
done
cd /tmp/testfile
ls -al