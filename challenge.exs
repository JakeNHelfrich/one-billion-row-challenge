file_data = File.stream!("./data/weather_stations.csv", :line)

parse_csv_line = fn csv_line ->
    String.split(List.first(String.split(csv_line, "\n")), ";")
end

stations = Enum.reduce(file_data, Map.new(), fn line, stations_map ->
  [station, string_temp] = parse_csv_line.(line)
  temp = String.to_float(string_temp)

  Map.update(stations_map, station, [temp], fn arr -> arr ++ [temp] end)
end)
