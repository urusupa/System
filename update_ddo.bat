@echo off
PATH C:\Windows\System32;C:\Program Files\wget\bin

wget -O data\ddostatus.txt http://free.ddo.jp/dnsupdate.php^?dn=nyctea^&pw=masashi128

rem �擾�����t�@�C������IP�؂�o���ė����炢�����
rem �����Ő��^���Ă��̂܂܎g����`�ɂ���Ƃ���
echo nyctea.ddo.jp
echo 5�b��Ɏ����I�ɕ��܂��B
ping 127.0.0.1 -n 6 > nul