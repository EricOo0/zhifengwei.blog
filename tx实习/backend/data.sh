#!/bin/bash
#QUERY_STRING poar上传的数据，以&分割
#形式：FTarget=&modid=&cmdid=&path=&FOfferID=&checker=&FPushField=ChannelID,ClientVer,OfferID&extra=ZoneId:ori_zoneid
L5_path="*/L5GetRoute1"
#QUERY_STRING="FTarget=111+&modid=222&cmdid=333&path=444&FOfferID=666&checker=777&FPushField=PushServer=realwater;ChannelID,ClientVer,OfferID;TransTime:Time&extra=999"
QUERY_STRING=`cat`
echo $QUERY_STRING>1.txt
#FTarget=`echo $QUERY_STRING|awk -F 'Ftarget=' '{print $2}'|awk -F '&' '{print $1}'`
#modid=`echo $QUERY_STRING|awk -F 'modid=' '{print $2}'|awk -F '&' '{print $1}'`
#cmdid=`echo $QUERY_STRING|awk -F 'cmdid=' '{print $2}'|awk -F '&' '{print $1}'`
#path=`echo $QUERY_STRING|awk -F 'path=' '{print $2}'|awk -F '&' '{print $1}'`
#FOfferID=`echo $QUERY_STRING|awk -F 'FOfferID=' '{print $2}'|awk -F '&' '{print $1}'`
FPushField=`echo $QUERY_STRING|awk -F 'FPushField=' '{print $2}'|awk -F '&' '{print $1}'`
#checker=""
#extra=""
result_code=0
result_info="sucess"
function getparam()
{
    field=(FTarget modid cmdid path FOfferID checker extra)
    for index in ${field[@]}
    do
    	eval $index=`echo ${QUERY_STRING} | awk -F '&' '{for(i=1;i<=NF;i++) { print $i;}}'|awk -F '=' -v key=${index} '{if ($1==key){print $2}}'`

    done
}

getparam
echo ${FTarget} $modid $cmdid $path $FOfferID $checker $extra $FPushField >>1.txt

# 检查FTarget是否已存在,Ftarget是否只包含字母数字和_,是否为空
function check_ftarget(){
	if [ "${FTarget}" == ""  ]
	then
		result_code=-1
                result_info="FTarget is null!"
                return_fun
                exit 0
	fi
	if [[ ! "${FTarget}" =~ ^[a-zA-Z0-9_]+$ ]]
	then
		result_code=1
                result_info="FTarget ${FTarget} unusable!--unrecognized characters"
		return_fun
		exit 0
	fi	
	a=`mysql -u root -Dtest -e "select * from t_push_condition where FTarget=\"${FTarget}\";"` 2>&1 1>/dev/null
	if [ "${a}" != "" ]
	then 
		result_code=1
		result_info="Ftarget ${FTarget} unusable!--repeated"
		return_fun
		exit 0
	fi
}
# 检查L5ID是否可用,是否为空
function check_L5(){
	if [ "${modid}" == "" ] || [ "${cmdid}" == "" ] 
        then
                result_code=-1
                result_info="L5 is null!"
                return_fun
                exit 0
        fi
	b=$(${L5_path} ${modid} ${cmdid} 5)
	ret=`echo ${b}|grep "failed"`
	if [ "${ret}" != "" ]
	then 
		result_code=2
                result_info="L5 addr ${modid}:${cmdid} unsable!"
                return_fun
		exit 0
	fi
}
# offerid检查防止中文逗号
function check_offerid(){
	if [ "${FOfferID}" == "" ]
        then
                result_code=-1
                result_info="FOfferID is null!"
                return_fun
                exit 0
        fi
	c=$(echo ${FOfferID}|grep '，' )
	if [ "${c}"  != "" ]
	then
		result_code=3
                result_info="offerid has chinese ，"
                return_fun 
		exit 0
	fi
}
function return_fun(){
	echo "Content-Type:text/html"
	echo ""
	echo "result_code:$result_code" >>1.txt
	echo "result_info:$result_info" >>1.txt
	echo "result_code:$result_code"
	echo "result_info:$result_info"
	
}
function insert_data(){
	FPushField="PushServer=realwater;${FPushField};TransTime:Time"
	if [ "${extra}" != "" ]
	then
		extra=`echo ${extra}|sed 's/,/|extend,/g'`
		extra="${extra}|extend"
		FPushField="${FPushField},${extra}"
	fi
	interface="insert into t_push_interface set FTarget=\"${FTarget}\",FUserDefType=0,FUserDefSo=\"\",FStandardResultType=\"standard_00\",FService=\"http\",FLable=\"${FTarget}\",FPushField=\"${FPushField}\",FExtraConf=\"\",FNeedRedo=\"Y\",FStatus=0,FCreateTime=now(),FUpdateTime=now(),FSignType=\"\";"
	condition="insert into t_push_condition set FTarget=\"${FTarget}\",FIndex=\"001\",FOfferIDList=\"${FOfferID}\",FLoginTypeList=\"*\",FClientVerList=\"*\",FServiceTypeList=\"*\",FServiceCodeList=\"*\",FPayChannelList=\"*\",FPfChannelList=\"*\",FPfVersionList=\"*\",FSourceList=\"*\",FStatus=0,FCreateTime=now(),FUpdateTime=now(),FFriendsPayFlag=\"*\",FSubCmdCode=\"provide_suc\",FExtCondition1=\"*\",FExtCondition2=\"*\",FExtCondition3=\"*\",FExtCondition4=\"*\",FExtCondition5=\"*\",FPushVer=1;"
	conf="insert into t_interface_conf set FService=\"http\",FLable=\"${FTarget}\",FConf=\"access_mode=l5&modid=${modid}&cmdid=${cmdid}&time_out=2&total_time_out=3&retry_cnt=2&url_path=${path}\",FStatus=0,FCreateTime=now(),FUpdateTime=now();"
	echo $interface >>1.txt
	echo $condition >>1.txt
	echo $conf >>1.txt
	a=`mysql -u root -Dtest -e "begin;"`
	a=`mysql -u root -Dtest -e "${interface}"`
	if [ $? != 0 ]	
	then
		mysql -u root -Dtest -e "rollback;"
		result_code=4
                result_info="insertation erro"
                return_fun
                exit 0		
	fi
	a=`mysql -u root -Dtest -e "${condition}"`
        if [ $? != 0 ]
        then
		mysql -u root -Dtest -e "rollback;"
                result_code=4
                result_info="insertation erro"
                return_fun
                exit 0
        fi
	a=`mysql -u root -Dtest -e "${conf}"`
        if [ $? != 0 ]
        then
		mysql -u root -Dtest -e "rollback;"
                result_code=4
                result_info="insertation erro"
                return_fun
                exit 0
        fi
	mysql -u root -Dtest -e "commit;"
}
check_ftarget
check_L5
check_offerid
insert_data
return_fun
#校验成功 给审核人发送邮件审核
#echo "mysql -u root -Dtest -e "insert into t_push_condition set FTarget="${Ftarget}",FOfferIDList="${FOfferID}""" >>1.txt
#a=`mysql -u root -Dtest -e "insert into t_push_condition set FTarget=\"${Ftarget}\",FOfferIDList=\"${FOfferID}\""`
#if [ $a != "" ]
#then
#        result_code=4
#        result_info="insert mysql error"
#fi
echo "http://zhifengwei.com:8080/verify.sh?FTarget=${FTarget}&Modid=${modid}&Cmdid=${cmdid}&path=${path}&FOfferID=${FOfferID}&FPushField=${FPushField}&extra=${extra}" >mail_$Ftarget
/bin/sendmail2  'zhifengwei' ${checker} 'zhifengwei' 'test' mail_$Ftarget --html 1>/dev/null 2>&1
rm mail_$Ftarget
#echo "Content-Type:text/html"
#echo ""
#echo "hello world!"
#echo $QUERY_STRING
#echo $a
#echo $c
