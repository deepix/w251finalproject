#!/bin/bash
# Script to select images with ground truth "Good" or "OK"

for f in $(find ground_truth -name *_good.txt -o -name *_ok.txt) ; do
    images=$(cat ${f})
    for i in ${images} ; do
        dir=$(echo ${i} | cut -d"_" -f2)
        img=images/${dir}/${i}.jpg
        ls ${img}
        newdir=selected/${dir}
        mkdir -p ${newdir}
        cp ${img} ${newdir}
    done
done
