#!/bin/bash
# author: 码农朱哲
# url: https://ext.dcloud.net.cn/publisher?id=9053

path=$1
files=$(ls $path)
for filename in $files
do
    if [[ "${filename##*.}"x = "framework"x ]];then
        libName=$filename/${filename%.*}
        lipoInfo=$(lipo -info $libName)
        fileInfo=$(file $libName)
        temp1=${lipoInfo%% are:*}
        temp2=${fileInfo%%dynamically*}
        pinfoIdx=$((${#temp1}+6))
        fileIdx=$((${#temp2}+1))
        fileLength=${#fileInfo}
        echo -e "\033[31m$filename \033[0m"
        echo -e "架      构：\033[33m ${lipoInfo:pinfoIdx} \033[0m"
        if [[ $fileIdx -lt $fileLength ]];then
            echo -e "是否动态库：\033[31m YES \033[0m"
        else
            echo "是否动态库：NO"
        fi
        echo "------------------------------------"
    fi
done