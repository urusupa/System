#!/bin/sh

##########################
#CRON.sh
##########################

. ${LIB_DIR}/common.sh

##########################
# 関数
##########################

PECAMOMENTUM(){
	if [ "$1" = "get" ] ; then
		result=`${BIN_DIR}/getyp.sh`
	elif [ "$1" = "cron" ]; then
		result=`/home/nyctea/Desktop/www-nyctea/PecaMomentum/cron.php`
	else
		result=0
	fi
}

LOGLOTATE(){
	msg="LOGLOTATE "
	##########
	# ログフォルダ作成
	##########
	mkdirdate=`date --date "1 day" +%Y%m%d`
	#echo $mkdirdate
	result=`mkdir ${LOG_DIR}/${mkdirdate} 2>/dev/null`
	#echo $result
	msg=${msg}"logフォルダ作成：${mkdirdate} "
	
	##########
	# ログフォルダ削除
	##########
	GET_DEL_LOGDIR_DATE_SQL(){
		mysql -N -s -u${DBUSER} -p${DBPASS} --database=${DBSCHEMA} -e  \
		"SELECT DATA1 FROM M_EAV WHERE CODE = 'DEL_LOGDIR_DATE' AND CODEVALUE = '1' ;"
	}
	del_logdir=`GET_DEL_LOGDIR_DATE_SQL`
	del_logdir_date=`date --date "${del_logdir} days ago" +%Y%m%d`
	result=`rm -rf ${del_logdir_date}`
	msg=${msg}"logフォルダ削除：${del_logdir_date} "
	
	LOG_OUTPUT ${msg}
	
	##########
	# shell_log,cron_logメンテ
	##########
	GET_DEL_LOG_DATE_SQL(){
		mysql -N -s -u${DBUSER} -p${DBPASS} --database=${DBSCHEMA} -e  \
		"SELECT DATA1 FROM M_EAV WHERE CODE = 'DEL_LOG_DATE' AND CODEVALUE = '1' ;"
	}
	del_log_date=`GET_DEL_LOG_DATE_SQL`
	del_log_dateYMD=`date --date "${del_log_date} days ago" +%Y%m%d`

	filename="${LOG_DIR}/shell_log.log"
	sed -i -e "/^${del_log_dateYMD}.*$/d" ${filename}

	filename="${LOG_DIR}/cron_log.log"
	sed -i -e "/^${del_log_dateYMD}.*$/d" ${filename}

	msg="LOGLOTATE shell_log,cron_logメンテナンス 削除対象：${del_log_dateYMD}"
	LOG_OUTPUT ${msg}

}

##########################
# メイン
##########################

flg=$1

if [ "${flg}" = 0 ] ; then
	flg=0
elif [ "${flg}" = "cron active check" ] ; then
	${BIN_DIR}/SENDMAIL.sh nyctea.me 1 "cron active" ${TIMESTMP}
	ECHO_LOG_OUTPUT $? "$*"
elif [ "${flg}" = "restartvnc" ] ; then
	${BIN_DIR}/SENDMAIL.sh nyctea.me 1 "restartvnc" ${TIMESTMP}
	ECHO_LOG_OUTPUT $? "$*"
elif [ "${flg}" = "reboot" ] ; then
	${BIN_DIR}/SENDMAIL.sh nyctea.me 1 "reboot" ${TIMESTMP}
	ECHO_LOG_OUTPUT $? "$*"
elif [ "${flg}" = "pecamomentum_get" ] ; then
	PECAMOMENTUM get
elif [ "${flg}" = "pecamomentum_cron" ] ; then
	PECAMOMENTUM cron
elif [ "${flg}" = "loglotate" ] ; then
	LOGLOTATE
elif [ ${flg} -eq 6 ] ; then
	${BIN_DIR}/OUTPUT_LOG.sh "OUTPUT_LOG" 
elif [ ${flg} -eq 7 ] ; then
	${BIN_DIR}/OUTPUT_LOG.sh "OUTPUT_LOG" 
else
	flg=0
fi

#ECHO_LOG_OUTPUT ${0##*/} "$*"


