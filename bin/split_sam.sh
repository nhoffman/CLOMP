#!/bin/bash


linenum=`cat sorted.sam | wc -l`
splitnum=`echo $(( $linenum / 6 ))`

echo "lines to split: "$splitnum 

split -d -a 3  -l $splitnum sorted.sam $1

basename=$1

files=($basename*)

echo $files

total=${#files[@]}
total=$((total-2))

echo "basename "$basename
echo "total "$total

fixSplit() {
        inum=$(printf %03d $i)
        last_record=$(tail -1 $basename$inum | cut -f1)
        j=$((i + 1))
        j=$(printf %03d $j)
        echo "Last record in "$basename$inum" is "$last_record". Grepping in "$basename$j"."
        head -n 30000 $basename$j | grep $last_record >> $basename$inum
        echo "Removing "$last_record" from "$basename$j"."
        /usr/bin/vim -e +:g/$last_record/d -cwq $basename$j
        echo "Done."
}

for i in $(seq 0 $total); do fixSplit & done

wait