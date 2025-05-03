# Script to fetch subdistricts from RajaOngkir and save to file
require Logger

defmodule FetchSubdistricts do
  def run do
    Logger.info("Fetching subdistricts from RajaOngkir...")

    # Start HTTPoison
    {:ok, _} = Application.ensure_all_started(:httpoison)

    # Create data directory if it doesn't exist
    File.mkdir_p!("data")

    # First, get all cities
    case WilayahElixir.RajaOngkir.get_all_cities() do
      {:ok, cities_response} ->
        cities = cities_response["rajaongkir"]["results"]
        Logger.info("Found #{length(cities)} cities, fetching subdistricts...")

        # Process each city and get its subdistricts
        subdistricts = Enum.flat_map(cities, fn city ->
          case WilayahElixir.RajaOngkir.get_subdistricts(city["city_id"]) do
            {:ok, response} ->
              subdistricts = response["rajaongkir"]["results"]
              # Add address and coordinates to each subdistrict
              Enum.map(subdistricts, fn subdistrict ->
                address = "#{subdistrict["subdistrict_name"]}, #{city["city_name"]}, #{city["province"]}"
                location = %{
                  kecamatan: subdistrict["subdistrict_name"],
                  kota: city["city_name"],
                  provinsi: city["province"]
                }
                {latitude, longitude} = WilayahElixir.Coordinates.get_coordinates(location)

                subdistrict
                |> Map.put("address", address)
                |> Map.put("latitude", latitude)
                |> Map.put("longitude", longitude)
              end)
            {:error, reason} ->
              Logger.error("Failed to fetch subdistricts for city #{city["city_name"]}: #{inspect(reason)}")
              []
          end
        end)

        # Save to file
        json = Jason.encode!(subdistricts, pretty: true)
        File.write!("data/subdistricts.json", json)
        Logger.info("Successfully saved #{length(subdistricts)} subdistricts to data/subdistricts.json")

      {:error, reason} ->
        Logger.error("Failed to fetch cities: #{inspect(reason)}")
    end
  end
end

FetchSubdistricts.run()
