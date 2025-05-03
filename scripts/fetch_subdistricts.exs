# Script to fetch subdistricts from RajaOngkir and save to file
require Logger

defmodule FetchSubdistricts do
  def run do
    Logger.info("Fetching subdistricts from RajaOngkir...")

    # Start HTTPoison
    {:ok, _} = Application.ensure_all_started(:httpoison)

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
              # Add address field to each subdistrict
              Enum.map(subdistricts, fn subdistrict ->
                address = "#{subdistrict["subdistrict_name"]}, #{city["city_name"]}, #{city["province"]}"
                Map.put(subdistrict, "address", address)
              end)
            {:error, reason} ->
              Logger.error("Failed to fetch subdistricts for city #{city["city_name"]}: #{inspect(reason)}")
              []
          end
        end)

        # Save to file
        json = Jason.encode!(subdistricts, pretty: true)
        File.write!("subdistricts.json", json)
        Logger.info("Successfully saved #{length(subdistricts)} subdistricts to subdistricts.json")

      {:error, reason} ->
        Logger.error("Failed to fetch cities: #{inspect(reason)}")
    end
  end
end

FetchSubdistricts.run()
