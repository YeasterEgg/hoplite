## Removes old logs
Dir.glob(Rails.root.join('public','log','*')).map{|logfile| File.delete(logfile)}

## Creates basicInfo
helps_yaml = YAML.load_file(Rails.root.join('config','locales','help.yml'))
helps_yaml.map{|help| Help.create(title: help.first, text: help.second['text'])}

## Parse through basic sales file, looks for its Panoplies and runs a 1 minute long name search
Parser.new(File.new(Rails.root.join('public','seed.txt')))
MatchMaker.new
ProductFinder.nightshift(1)
