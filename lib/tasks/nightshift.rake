namespace :nightshift do
  desc "Checking for Panoplies"
  task :dig_panoplies do
    MatchMaker.new
  end
end
