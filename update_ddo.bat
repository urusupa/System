@echo off
PATH C:\Windows\System32;C:\Program Files\wget\bin

wget -O data\ddostatus.txt http://free.ddo.jp/dnsupdate.php^?dn=nyctea^&pw=masashi128

rem 取得したファイルからIP切り出して来たらいいんや
rem ここで成型してそのまま使える形にするとかね
echo nyctea.ddo.jp
echo 5秒後に自動的に閉じます。
ping 127.0.0.1 -n 6 > nul