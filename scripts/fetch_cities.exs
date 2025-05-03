# Script to fetch cities from RajaOngkir and save to file
require Logger

defmodule FetchCities do
  def run do
    Logger.info("Fetching cities from RajaOngkir...")

    # Start HTTPoison
    {:ok, _} = Application.ensure_all_started(:httpoison)

    case WilayahElixir.RajaOngkir.get_all_cities() do
      {:ok, response} ->
        cities = response["rajaongkir"]["results"]
        json = Jason.encode!(cities, pretty: true)

        File.write!("cities.json", json)
        Logger.info("Successfully saved #{length(cities)} cities to cities.json")

      {:error, reason} ->
        Logger.error("Failed to fetch cities: #{inspect(reason)}")
    end
  end
end

FetchCities.run()
