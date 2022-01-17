require 'json'
require 'optparse'

options={}
OptionParser.new do |opts|
  opts.banner = "Usage: rb --list playlist output --file file with rompaths input"
  opts.on("-l","--list LIST","playlist name") 
  opts.on("-f","--file FILE","input file")
  opts.on("-ow","--overwrite","overwrite, defaults to false")
end.parse!(into: options)

tojs={"version"=>"1.0","items"=>[]}

(pp "arguments missing, run -h for help";exit) unless (options[:file] && options[:list])

File.exists?(options[:file]) ? inp=File.open(options[:file]).read.split("\n") : (pp "File does not exist";exit)
(File.exists?(options[:list]) && options[:overwrite]==nil) ? (pp "File exists not overwriting";exit) : lname=options[:list]

inp.each do |lol|
  hm={}
  hm["path"]=lol
  File.basename(lol) == "" ? ("Rom does not exist";exit) : hm["label"]=File.basename(lol)
  hm["core_path"]="DETECT"
  hm["core_name"]="DETECT"
  hm["crc32"]="DETECT"
  tojs["items"].push(hm)
end

File.new(lname,"w+").write(JSON::pretty_generate(tojs))
