# Script to fetch provinces from RajaOngkir and save to file
require Logger

defmodule FetchProvinces do
  def run do
    Logger.info("Fetching provinces from RajaOngkir...")

    # Start HTTPoison
    {:ok, _} = Application.ensure_all_started(:httpoison)

    case WilayahElixir.RajaOngkir.get_provinces() do
      {:ok, response} ->
        provinces = response["rajaongkir"]["results"]
        json = Jason.encode!(provinces, pretty: true)

        File.write!("provinces.json", json)
        Logger.info("Successfully saved #{length(provinces)} provinces to provinces.json")

      {:error, reason} ->
        Logger.error("Failed to fetch provinces: #{inspect(reason)}")
    end
  end
end

FetchProvinces.run()
