#!/bin/bash
h="0"
N=-1
s="0"
minsize=1
opt="0"
for arg in "$@" ; do
	if [ $arg = '--help' ] ;
	then
		echo "topsize [--help] [-h] [-N] [-s minsize] [--] [dir...]"
		echo " Выводит список N самых больших по размеру файлов из заданного каталога и всех его подкаталогов, размер которых превышает заданный размер minsize."
		echo "--help - вывод справки о формате и выход"
		echo "-N - количество файлов, если не задано - все файлы (N - число, например -10)"
		echo "minsize - минимальный размер, если не задан - 1 байт"
		echo '-h - вывод размера в "человекочитаемом формате" (оптимальный выбор единиц измерения размера - байты, килобайты, мегабайты и т.д.)'
		echo "dir... - каталог(и) поиска, если не заданы - текущий каталог (.)"
		echo "-- - разделение опций и каталога (поддержка каталогов, начинающихся с минуса)"
		exit 0
	elif [ $arg = "--" ] ;
	then
		opt="1"
	elif [ $opt = "0" ] ;
	then 	
		if [ $s = '1' ] ;
		then	
			if [[ $arg =~ ^[0-9]+$ ]];
			then
				minsize=$arg
				s='0'
			else
				echo 'Error: wrong format for minsize'>&2
				exit 1
			fi

		elif [ $arg = '-s' ] ;
		then
			s='1'
		elif [ $arg = "-h" ] ;
		then
			h="1"
		elif [ ${arg:0:1} = "-" ] ;
		then
			echo "Error: no option $arg">&2
			exit 1
		fi
	fi
done

