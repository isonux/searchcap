#!/bin/bash

# C 2014-2016 Emerson dos Santos Queiroz <son.queiroz@gmail.com>
# Last-Update: 2016-01-05

ARQ_READ=$1
ARQ_WRITE=arq_com$(date +%d-%m-%y_%Hh%Mmin%S).log
N_ARQ=$0
PWD=$(which pwd)
AWK=$(which awk)
TOUCH=$(which touch)
CAT=$(which cat)

if [ -f $ARQ_READ ];then 
	echo "The $ARQ_READ file is ready to start reading"
	sleep 1
	echo "Processing"
else
	echo "File does not exist"
	sleep 1
	echo "Leaving the Terminal"
	sleep 2
	exit 1
fi

$TOUCH $ARQ_WRITE

if [ -f $ARQ_WRITE ];then 
	echo "Current Directory: `$PWD`"
	echo "created file: $ARQ_WRITE"
else
	echo "Could not create the file $ARQ_WRITE"
fi

echo "Reading Files $ARQ_READ"
sleep 2

while read line
do
	echo $line | egrep -q "Major failure in SIP component|Minor failure in SIP component"
	if [ $? -eq 0 ];then
		echo $line >> $ARQ_WRITE
	fi

done < $ARQ_READ

echo -e "\n\n" 
echo "Report of Ocorrencias by Date and Time"
echo -e "\n\n" 

numline=`cat $ARQ_WRITE | wc -l`

if [ $numline -eq 0 ];then
echo "There are no occurrences in this file"
exit 0
fi

while read linha
do
	echo $linha | $AWK -F" " '{print $1,$2}' 
done < $ARQ_WRITE
