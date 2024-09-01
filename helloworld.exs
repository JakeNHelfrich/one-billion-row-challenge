file_data = File.stream!("./data/10_weather_stations.csv", :line)
{:ok, num_weather_stations} = Enumerable.count(file_data)

IO.puts(num_weather_stations)
