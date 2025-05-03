defmodule WilayahElixir.RajaOngkir do
  @moduledoc """
  Service for interacting with RajaOngkir API
  """

  use HTTPoison.Base

  @base_url "https://pro.rajaongkir.com/api"
  @api_key Application.get_env(:wilayah_elixir, :raja_ongkir_api_key)

  def process_url(url) do
    @base_url <> url
  end

  def process_request_headers(headers) do
    headers
    |> Keyword.put(:"key", @api_key)
    |> Keyword.put(:"content-type", "application/x-www-form-urlencoded")
  end

  @doc """
  Fetches all provinces from RajaOngkir API
  """
  def get_provinces do
    case get("/province") do
      {:ok, %{status_code: 200, body: body}} ->
        {:ok, Jason.decode!(body)}
      {:ok, %{status_code: status_code, body: body}} ->
        {:error, "API returned status #{status_code}: #{body}"}
      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  Fetches a specific province by ID from RajaOngkir API
  """
  def get_province(id) do
    case get("/province?id=#{id}") do
      {:ok, %{status_code: 200, body: body}} ->
        {:ok, Jason.decode!(body)}
      {:ok, %{status_code: status_code, body: body}} ->
        {:error, "API returned status #{status_code}: #{body}"}
      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  Fetches all cities from a specific province
  """
  def get_cities(province_id) do
    case get("/city?province=#{province_id}") do
      {:ok, %{status_code: 200, body: body}} ->
        {:ok, Jason.decode!(body)}
      {:ok, %{status_code: status_code, body: body}} ->
        {:error, "API returned status #{status_code}: #{body}"}
      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  Fetches all cities from RajaOngkir API
  """
  def get_all_cities do
    case get("/city") do
      {:ok, %{status_code: 200, body: body}} ->
        {:ok, Jason.decode!(body)}
      {:ok, %{status_code: status_code, body: body}} ->
        {:error, "API returned status #{status_code}: #{body}"}
      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  Fetches all subdistricts from a specific city
  """
  def get_subdistricts(city_id) do
    case get("/subdistrict?city=#{city_id}") do
      {:ok, %{status_code: 200, body: body}} ->
        {:ok, Jason.decode!(body)}
      {:ok, %{status_code: status_code, body: body}} ->
        {:error, "API returned status #{status_code}: #{body}"}
      {:error, error} ->
        {:error, error}
    end
  end
end
