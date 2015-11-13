#! ruby -Ku
# encoding: utf-8

require 'rubygems'
require 'mechanize'

YParray = ["http://bayonet.ddo.jp/sp/uptest/","http://temp.orz.hm/yp/uptest/","http://games.himitsukichi.com/hktv/uptest/"]

result = `title YPcheck`

YParray.each{|ypurl|
	begin
		agent = Mechanize.new
		agent.keep_alive = false
		agent.get(ypurl)
		agent.page.link_with(:text => 'Normal POST version').click

		form = agent.page.forms[0]
		button = agent.page.forms[0].button_with(:type => 'submit')
		agent.submit(form, button)
	rescue Mechanize::ResponseCodeError => ex
		puts ex.response_code + " " + ypurl
		next
	rescue => ex
		puts ex
		next
	else
		puts "OK " + ypurl
		next
	end
}

puts "\n5秒後に自動的に閉じます\n"
sleep 5

