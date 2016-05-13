every :day, at: '1am' do
  rake "nightshift:dig_panoplies"
end

every :day, at: '2am' do
  rake "nightshift:minutes_of_names"
end
