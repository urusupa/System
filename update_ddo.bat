@echo off
PATH C:\Windows\System32;C:\Program Files\wget\bin

wget -O data\ddostatus.txt http://free.ddo.jp/dnsupdate.php^?dn=domainname^&pw=password

echo nyctea.ddo.jp
echo 5�b��Ɏ����I�ɕ��܂��B
ping 127.0.0.1 -n 6 > nul