#!/bin/sh

N=500

t=$(timeout 5 ssh bsc015557@glogin2.bsc.es "timeout 3 command time -f %e touch /gpfs/projects/bsc15/bsc015557/gpfs.{1..$N} 2>&1; rm -f /gpfs/projects/bsc15/bsc015557/gpfs.{1..$N}")

if [ -z "$t" ]; then
  t="5.00"
fi

cat <<EOF
HTTP/1.1 200 OK
Content-Type: text/plain; version=0.0.4; charset=utf-8; escaping=values

# HELP gpfs_touch_latency Time to create $N files.
# TYPE gpfs_touch_latency gauge
gpfs_touch_latency $t
EOF
