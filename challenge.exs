file_data = File.stream!("./data/weather_stations.csv", :line)

parse_csv_line = fn csv_line ->
    String.split(List.first(String.split(csv_line, "\n")), ";")
end

defmodule Station do
  def new(name, initial_temp) do
    # Couldn't work out how to define and use struct in same module.
    # Returning map instead.
    %{
      name: name,
      min: initial_temp,
      max: initial_temp,
      mean: initial_temp,
      sum: initial_temp,
      num_recordings: 1
    }
  end

  def add_temp(station, new_temp) do
    sum = station.sum + new_temp
    num_recordings = station.num_recordings + 1

    %{
        name: station.name,
        min: min(station.min, new_temp),
        max: max(station.max, new_temp),
        mean: sum / num_recordings,
        sum: sum,
        num_recordings: num_recordings,
    }
  end
end


stations = Enum.reduce(file_data, Map.new(), fn line, stations_map ->
  [station_name, string_temp] = parse_csv_line.(line)
  temp = String.to_float(string_temp)


  updated_station = case Map.fetch(stations_map, station_name) do
      { :ok, station } -> Station.add_temp(station, temp)
      :error -> Station.new(station_name, temp)
  end

  Map.put(stations_map, station_name, updated_station)
end)


print_result = fn ->
  stations
  |> Map.values
  |> Enum.sort_by(fn s -> s.name end, :asc)
end
