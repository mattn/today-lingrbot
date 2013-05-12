# -*- coding: utf-8 -*-
require "json"
require "sinatra"
require "rexml/document"
require "open-uri"
require "time"

#set :bind, 'tonic-water.com'
set :port, 10086

def today(*args)
  if args.size == 0
    md = Time.now.strftime("%m%d")
  else
    md = "%02d%02d" % [args[0], args[1]]
  end
  url = "http://www.mizunotomoaki.com/wikipedia_daytopic/api.cgi/#{md}"
  ret = ""
  open(url) do |f|
    doc = REXML::Document.new f
    doc.elements.each("//kinenbi/item") do |elem|
      ret += "#{elem.text}\n"
    end
  end
  return ret
end

get '/' do
  "hello"
end

post '/lingr' do
  json = JSON.parse(request.body.string)
  ret = ""
  json["events"].each do |e|
    text = e['message']['text']
    if text =~ /^今日は何の日[?？]$/
      ret += today
    elsif text =~ /^(\d+)月(\d+)日は何の日[?？]$/
      ret += today($1, $2)
    elsif text =~ /^今日は何の日$/
      ret += "ふっふー\n"
    end
  end
  ret.rstrip
end
