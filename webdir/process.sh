
#!/bin/sh

[ -e /tmp/fd1 ]|| mkfifo /tmp/fd1
exec 5<>/tmp/fd1
rm -rf /tmp/fd1 
for i in `seq 1 10`
do
	echo ''>&5
done

for ((i=0;i<50;i++))
do
	read -u5
{
	echo "process $i is running"
	sleep 5
	echo ''>&5 
}&
done

wait
echo "total time consume is $SECONDS"
exec 5<&-
exec 5>&-

