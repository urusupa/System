#! ruby -Ku
# encoding: utf-8

require 'rubygems'
require 'mechanize'
require 'kconv'
require 'nkf'
require 'fileutils'
require 'mysql'
$LOAD_PATH.unshift('D:/system/lib')
require 'common'


#thisPGM =$0.gsub( File.dirname(__FILE__) , '' ).gsub( /\// , '')
thisPGM = "update_ieServer.rb"
strGetTime = TIMESTMP

agent = Mechanize.new
puts "\nieServer へ接続"

begin
	filehdl = agent.get("http://ieserver.net/cgi-bin/dip.cgi?username=username&domain=dip.jp&password=password&updatehost=1")
	filehdl.save!(DATADIR + "/ieServerstatus_work.txt")
rescue => ex
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
		strPRM = "domain " + myip
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

puts "\n5秒後に自動的に閉じます\n"
sleep 5

