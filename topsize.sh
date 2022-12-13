#!/bin/bash
h="0"
N='all'
s="0"
minsize=1
opt="0"
for arg in "$@" ; do
	if [ $arg = "--" ] ;
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
		elif [ $arg = '--help' ] ;
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
		
		elif [ $arg = '-s' ] ;
		then
			s='1'
		elif [ $arg = "-h" ] ;
		then
			h="1"
		elif [[ $arg =~ ^-[0-9]+$ ]] ;
		then
			N=$arg
		elif [ ${arg:0:1} = "-" ] ;
		then
			echo "Error: no option $arg">&2
			exit 1
		fi
	fi
done
if [ $s = 1 ] ;
then
echo 'Error: no minsize given'>&2
exit 1
fi
#echo 'minsize is '$minsize
#echo 'N is '$N
directs="0"
opt="0"
for arg in "$@" ; do
	if [ $arg = "--" ] ;
	then
		opt="1"
	elif [ $opt = "0" ] ;
	then 	
		if [ $s = '1' ] ;
		then	
			s='0'
		elif [ $arg = '-s' ]; 
		then
			s='1'
		elif ! [ ${arg:0:1} = "-" ] ;
		then
			new_dir=$arg
			directs='1'
			#echo $new_dir
			if [ $h = '0' ];
			then
				if [ $N = 'all' ] ;
				then 
					find $new_dir -size +$minsize'c' -type f  -printf '%s %P\n' | sort -r -n
				else
					find $new_dir -size +$minsize'c' -type f -printf '%s %P\n'   | sort -r -n | head $N
				fi
			else
				if [ $N = 'all' ] ;
				then 
					find -size +$minsize'c' -type f -printf '%s %P\n'  | sort -r -n 
				else
					find -size +$minsize'c' -type f -printf '%s %P\n'  | sort -r -n | head $N
				fi	
			fi
		fi
			
	else
		new_dir=$arg
		directs='1'
		#echo $new_dir
		if [ $h = '0' ];
		then
			if [ $N = 'all' ] ;
			then 
				find $new_dir -size +$minsize'c' -type f -printf '%s %P\n'  | sort -r -n
			else
				find $new_dir -size +$minsize'c' -type f -printf '%s %P\n'  | sort -r -n | head $N
			fi
		else
			if [ $N = 'all' ] ;
			then 
				find -size +$minsize'c' -type f -printf '%s %P\n'  | sort -r -n 
			else
				find -size +$minsize'c' -type f -printf '%s %P\n'  | sort -r -n | head $N
			fi	
		fi
	fi
done
if [ $directs = "0" ] ;
then
	#echo $PWD
	if [ $h = '0' ];
	then
		if [ $N = 'all' ] ;
		then 
			find -size +$minsize'c' -type f -printf '%s %P\n'  | sort -r -n 
		else
			find -size +$minsize'c' -type f -printf '%s %P\n'  | sort -r -n | head $N
		fi	
	else
		if [ $N = 'all' ] ;
		then 
			find -size +$minsize'c' -type f -printf '%s %P\n'  | sort -r -n 
			
		else
			find -size +$minsize'c' -type f -printf '%s %P\n'  | sort -r -n | head $N
				
		fi	
	fi
fi
