#!/bin/bash
f="0"
opt="0"
filename="/etc/passwd"
uid=-1

for arg in "$@" ; do
	if [ $arg = "--" ] ;
	then
		opt="1"
		f="0"
	elif [ $opt = "0" ] ;
	then 
		if [ $arg = "-f" ] ;
		then
			f="1"
		elif [ $f = "1" ] ;
		then
			filename=$arg
			f="0"
		elif [ ${arg:0:1} = "-" ] ;
		then
			echo "Error: no option $arg">&2
			exit 2
		else
			uid=$arg
		fi
	else
		uid=$arg	
	fi
done

#echo $uid
#echo $filename
if ! [ -f "$filename" ];
then
	echo "No such file: $filename">&2
	exit 2
	
fi
if [ $uid = -1 ] ;
then
	echo 'No uid given'>&2
	exit 2
fi

count=`grep -c "^[^:]*:[^:]*:$uid:" "$filename"`
if [ $count = 1 ] ;
then
	line=`grep "^[^:]*:[^:]*:$uid:" "$filename"`
	line=${line%%:*}
	echo $line
else	
	echo "No such uid: $uid">&2
	exit 1
fi
