#!/bin/bash
echo "Content-Type:text/html"
echo ""
echo "hello"
echo $A>1.txt
status=`echo ${A}|awk -F '&' '{for(i=1;i<=NF;i++){print $i;}}'|awk -F '=' '{if ($1=="status"){print $2}}'`
Ftarget=`echo ${A}|awk -F '&' '{for(i=1;i<=NF;i++){print $i;}}'|awk -F '=' '{if ($1=="Ftarget"){print $2}}'`
echo ${status}>>1.txt
echo ${Ftarget}>>1.txt
#数据生效
if [ "${status}" == "reject" ]
then 
   mysql -u root -Dtest -e "delete from t_push_condition where FTarget=\"${Ftarget}\";" 
   mysql -u root -Dtest -e "delete from t_push_interface where FTarget=\"${Ftarget}\";"
   mysql -u root -Dtest -e "delete from t_interface_conf where FLable=\"${Ftarget}\";" 
fi
if [ "${status}" == "accept" ]
then
   mysql -u root -Dtest -e "update t_push_condition set FStatus=1 where FTarget=\"${Ftarget}\";"
   mysql -u root -Dtest -e "update t_push_interface set FStatus=1 where FTarget=\"${Ftarget}\";"
   mysql -u root -Dtest -e "update t_interface_conf set FStatus=1 where FTarget=\"${Ftarget}\";"

fi
