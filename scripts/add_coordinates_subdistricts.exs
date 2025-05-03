defmodule AddCoordinates do
  def process_subdistricts do
    # Read the JSON file
    File.read!("data/subdistricts00.json")
    |> Jason.decode!()
    |> Enum.map(fn data ->
      # Convert field names to match what get_coordinates expects
      location = %{
        kecamatan: data["subdistrict_name"],
        kota: data["city"],
        provinsi: data["province"]
      }

      # Add coordinates to each row
      coordinates = WilayahElixir.Coordinates.get_coordinates(location)
      Map.merge(data, %{
        "latitude" => elem(coordinates, 0),
        "longitude" => elem(coordinates, 1)
      })
    end)
    |> Jason.encode!(pretty: true)
    |> then(&File.write!("data/subdistricts_with_coordinates.json", &1))
  end
end

# Run the script
AddCoordinates.process_subdistricts()
