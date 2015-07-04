#! ruby -Ku
# encoding: utf-8

require 'rubygems'
require 'mechanize'
require 'kconv'
require 'nkf'
require 'fileutils'
require 'mysql'
#$LOAD_PATH.unshift(LIBDIR)
require 'common'


#thisPGM =$0.gsub( File.dirname(__FILE__) , '' ).gsub( /\// , '')
thisPGM = "update_ieServer.rb"
strGetTime = TIMESTMP

agent = Mechanize.new
puts "\nieServer へ接続"

begin
	filehdl = agent.get("http://ieserver.net/cgi-bin/dip.cgi?username=nyctea&domain=dip.jp&password=doseisan128&updatehost=1")
	filehdl.save!(DATADIR + "/ieServerstatus_work.txt")
rescue => ex
=begin
	connection = Mysql::new(DBHOST, DBUSER, DBPASS , DBSCHEMA)
		result = connection.prepare("INSERT INTO C_PARTS_CTRL(PARTS_ID,PARTS_KBN,PRM,STATUS,KSN_USER,RCD_KSN_TIME,RCD_TRK_TIME) VALUES(?,?,?,?,?,?,?)")
		result.execute(thisPGM , '1' , 'Access Error ieServer.net' , '1' , thisPGM , strGetTime , strGetTime)
	connection.close
=end
	PARCON_SQL.abnormal('Access Error ieServer.net')

	puts "Access Error ieServer.net"
	exit
else
	puts "接続完了\n\nファイルへ保存"
end

ieServerstatus = []
open(DATADIR + "ieServerstatus_work.txt", :encoding => Encoding::EUC_JP){|fhdl|
	ieServerstatus = fhdl.readlines
}

=begin
if /nochg/.match( ieServerstatus[0] ) then
	#agent = Mechanize.new
	myip = agent.get("http://ipcheck.ieserver.net")
	myip = agent.page.body
	ieServerstatus[0] = ieServerstatus[0] + " " + myip
end
=end

begin
	File.delete(DATADIR + "ieServerstatus.txt")
	File.delete(DATADIR + "ieServerstatus_tmp.txt")
rescue => ex
	p ex
	puts "ファイル削除失敗"
	sleep 5
else
end

begin
	filehdl = open(DATADIR + "ieServerstatus_tmp.txt","a+")
		#strPRM = ieServerstatus[2].gsub(/のIPアドレスは現在\s/, '')
		#p strPRM
		#p strPRM[68..101]
		
		myip = agent.get("http://ipcheck.ieserver.net")
		myip = agent.page.body
		strPRM = DOMAIN_HOME + " " + myip
		filehdl.puts strPRM
		filehdl.puts strGetTime
	filehdl.close

	FileUtils.cp(DATADIR + "ieServerstatus_tmp.txt", DATADIR + "ieServerstatus.txt")
rescue => ex
	puts "ファイル書込失敗"
	sleep 5
else
	puts "保存完了"
end

puts "\nsakuraVPSへコピー中"
begin
	FileUtils.cp( DATADIR + "ieServerstatus.txt", SHAREDIR + "ieServerstatus.txt")
rescue => ex
=begin
	connection = Mysql::new(DBHOST, DBUSER, DBPASS , DBSCHEMA)
		result = connection.prepare("INSERT INTO C_PARTS_CTRL(PARTS_ID,PARTS_KBN,PRM,STATUS,KSN_USER,RCD_KSN_TIME,RCD_TRK_TIME) VALUES(?,?,?,?,?,?,?)")
		result.execute(thisPGM , '1' , 'SHEREDIR is disconnected' , '1' , thisPGM , strGetTime , strGetTime)
	connection.close
=end
	PARCON_SQL.abnormal('SHEREDIR is disconnected')
	puts "SHEREDIR is disconnected"
	puts "コピー失敗"
	sleep 5
else 
	puts "コピー完了"
end

puts "\nPARTS_CTRLへ書込中"
	PARCON_SQL.normal(strPRM)
puts "書込完了"

#アプデートするたびにnyctea_me.mysql.userにホスト名を書き込めばいいんだ
#ここからしかアクセスできなくなる、いいね


puts "\n5秒後に自動的に閉じます\n"
sleep 5

