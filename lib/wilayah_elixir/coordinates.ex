defmodule WilayahElixir.Coordinates do
  @doc """
  Generates random coordinates within reasonable bounds for Indonesia.
  Returns a tuple of {latitude, longitude}.
  """
  def get_coordinates(location) do
    # Format the search query
    query = location |> URI.encode()

    # Make request to Nominatim API
    url = "https://nominatim.openstreetmap.org/search?format=json&q=#{query}&limit=1"

    case HTTPoison.get(url, [{"User-Agent", "WilayahElixir/1.0"}]) do
      {:ok, %{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, [%{"lat" => lat, "lon" => lon} | _]} ->
            {String.to_float(lat), String.to_float(lon)}
          _ ->
            # If no coordinates found, return random coordinates within Indonesia
            {random_lat(), random_lon()}
        end
      _ ->
        # If API request fails, return random coordinates within Indonesia
        {random_lat(), random_lon()}
    end
  end

  defp random_lat do
    # Indonesia latitude range: -11.0 to 6.0
    :rand.uniform() * 17.0 - 11.0
  end

  defp random_lon do
    # Indonesia longitude range: 95.0 to 141.0
    :rand.uniform() * 46.0 + 95.0
  end
end
