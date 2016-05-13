namespace :nightshift do

  desc "Checking for Panoplies"
  task dig_panoplies: :environment do
    MatchMaker.new
  end

  desc "For around 15 minutes it looks up names of products checking on Decathlon website"
  task minutes_of_names: :environment do
    ProductFinder.nightshift
  end

end
