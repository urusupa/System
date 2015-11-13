#!/bin/sh
#################
# SENDMAIL.sh
# 
# SENDMAIL.sh subject mailto text
###############

. ${LIB_DIR}/common.sh


#################
# �֐�
###############

GET_MAILTO_SQL(){
	mysql -N -s -u${DBUSER} -p${DBPASS} --database=${DBSCHEMA} -e  \
	"SELECT DATA1 FROM M_EAV WHERE CODE = 'MAIL_TO' AND CODEVALUE = '$1' ;"
}

GET_SUBJECT_SQL(){
	mysql -N -s -u${DBUSER} -p${DBPASS} --database=${DBSCHEMA} -e  \
	"SELECT DATA1 FROM M_EAV WHERE CODE = 'MAIL_SUBJECT' AND CODEVALUE = '$1' ;"
}

MAKE_MAILTEXT(){
	mailtext1="`cat ${TMP_DIR}/MAIL_TEXT1.txt`"
	mailtext2="`cat ${TMP_DIR}/MAIL_TEXT2.txt`"
	mailtext3="`cat ${TMP_DIR}/MAIL_TEXT3.txt`"
	mailtext="${mailtext1}""\n""\n""${mailtext2}""\n""\n""${mailtext3}""\n"
	mailtext_exist=`echo $mailtext | sed -e "/^$/d"`

}

#################
# ���C��
###############

prm_tmp=$*
#�����̐��ŕ���
if [ $# -eq 2 ] ; then 
	subject=$1
	mailto=$2

	address=`GET_MAILTO_SQL ${mailto}`
	
	MAKE_MAILTEXT

	#������2����MAIL_TEXT����
	if [ -z "${mailtext_exist}" ] ; then #�����񒷂�0�Ȃ�^
		mailtext=$*
	fi
	
elif [ $# -ge 3 ] ; then
	subject=$1
	mailto=$2
		
	shift
	shift

	address=`GET_MAILTO_SQL ${mailto}`

	MAKE_MAILTEXT
	
	#����3�ȏ�ł�MAILTEXT�����݂���ΒǋL����
	if [ -z "${mailtext_exist}" ] ; then #�����񒷂�0�Ȃ�^
		mailtext=$*
	else
		mailtext=$*"\n"${mailtext}
	fi

else
	subject=`GET_SUBJECT_SQL 0`
	address=`GET_MAILTO_SQL 1`
	
	MAKE_MAILTEXT

	#����1�ȉ��ł�MAILTEXT�����݂���ΒǋL����
	if [ -z "${mailtext_exist}" ] ; then #�����񒷂�0�Ȃ�^
		mailtext=$*
	else
		mailtext=$*"\n"${mailtext}
	fi

fi

#���M
result=`echo "${mailtext}" | mail -s ${subject} ${address}`

result="`cp -f ${TMP_DIR}/MAIL_TEXT1.txt ${TMP_DIR}/MAIL_TEXT1_bkup.txt`"
result="`cp -f ${TMP_DIR}/MAIL_TEXT2.txt ${TMP_DIR}/MAIL_TEXT2_bkup.txt`"
result="`cp -f ${TMP_DIR}/MAIL_TEXT3.txt ${TMP_DIR}/MAIL_TEXT3_bkup.txt`"

result="`echo -n > ${TMP_DIR}/MAIL_TEXT1.txt`"
result="`echo -n > ${TMP_DIR}/MAIL_TEXT2.txt`"
result="`echo -n > ${TMP_DIR}/MAIL_TEXT3.txt`"

if [ -z "${mailtext_exist}" ] ; then
	LOG_OUTPUT "${prm_tmp}"
	PARCON_OUTPUT "$prm_tmp"
else
	mailtext=`echo $mailtext_exist | tr '\n' ' ' | tr '\r' ' '`
	LOG_OUTPUT "${prm_tmp} ${mailtext}"
	PARCON_OUTPUT "$prm_tmp" "MAILTEXT"
fi

