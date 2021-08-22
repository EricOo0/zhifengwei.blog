#!/bin/bash
#A="ftarget=dda&Modid=*&Cmdid=*&path=*&FOfferID=6&FPushField=*"
#echo $A>1.txt
FTarget=""
Modid=""
Cmdid=""
FPushField=`echo "$A" |awk -F 'FPushField=' '{print $2}'`
FOfferID=""
path=`echo "$A" |awk -F '&' '{for(i=1;i<=NF;i++){print $i;}}'|awk -F'=' -v key="path" '{if ($1==key){print $2}}'`
path=$(echo ${path} |sed 's/\//\\\//g')
function getParam()
{
    key=$1
    tmp=$(echo "$A" |awk -F '&' '{for(i=1;i<=NF;i++){print $i;}}'|awk -F'=' -v key=${key} '{if ($1==key){print $2}}')
    eval ${key}=${tmp}
}

function getfield()
{
    field=(* * * *)
    for i in ${field[@]}
    do
	tmp=`echo ${FPushField}|grep "${i}"`
	if [ "${tmp}" == "" ]
        then 
	    	
		html=`echo "${html}" | sed "s/id=\"${i}\" checked/id=\"${i}\"/g"`
	fi
    done
}

getParam 'FTarget'
getParam 'Modid' 
getParam 'Cmdid'
getParam 'FOfferID'
getParam 'extra'
extra=$(echo ${extra} |sed 's/%7C/\|/g')
echo $A >1.txt
echo $extra >>1.txt
echo "Content-Type:text/html"
echo ""
html=`cat verify.html | sed "s/业务名/"${FTarget}"/g"|sed "s/L5 id/${Modid}:${Cmdid}/g" |sed "s/推送路径/${path}/g"|sed "s/offerid/${FOfferID}/g"|sed "s/extra/${extra}/g"`
getfield
echo "${html}"


