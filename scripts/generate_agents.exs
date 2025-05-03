defmodule AgentGenerator do
  def read_csv do
    "data/agen_wilayah.csv"
    |> File.read!()
    |> String.split("\n")
    |> Enum.drop(1)  # Skip header
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(fn line ->
      [kecamatan, kota, provinsi] = String.split(line, "\t")
      %{
        kecamatan: kecamatan,
        kota: kota,
        provinsi: provinsi
      }
    end)
  end

  def generate_uuid do
    UUID.uuid4()
  end

  def generate_phone do
    numbers = for _ <- 1..9, do: Enum.random(0..9)
    "628#{Enum.join(numbers)}"
  end

  def toko_names do
    [
      "Sumber Rejeki", "Makmur Jaya", "Sejahtera", "Barokah", "Abadi",
      "Maju Jaya", "Berkah", "Sentosa", "Mulia", "Indah",
      "Rahayu", "Damai", "Subur", "Lestari", "Mekar",
      "Jaya Abadi", "Bersama", "Sukses", "Mandiri", "Utama"
    ]
  end

  def get_coordinates(location) do
    # Format the search query
    query = "#{location.kecamatan}, #{location.kota}, #{location.provinsi}, Indonesia"
    |> URI.encode()

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

  def generate_agent(location) do
    {latitude, longitude} = get_coordinates(location)
    alamat = "#{location.kecamatan}, #{location.kota}, #{location.provinsi}, Indonesia"

    %{
      kode: generate_uuid(),
      nama: "Toko #{Enum.random(toko_names())}",
      no_hp: generate_phone(),
      kecamatan: location.kecamatan,
      kecamatan_id: "#{:rand.uniform(9999999)}",  # Placeholder ID
      kota: location.kota,
      kota_id: "#{:rand.uniform(9999)}",          # Placeholder ID
      provinsi: location.provinsi,
      provinsi_id: "#{:rand.uniform(99)}",        # Placeholder ID
      latitude: latitude,
      longitude: longitude,
      alamat: alamat
    }
  end

  def generate_agents(count) do
    locations = read_csv()
    agents = for _ <- 1..count do
      location = Enum.random(locations)
      generate_agent(location)
    end

    json = Jason.encode!(agents, pretty: true)
    File.write!("data/agents.json", json)

    IO.puts("Generated #{count} agents in data/agents.json")
  end
end

# Add required dependencies
Mix.install([
  {:uuid, "~> 1.1"},
  {:jason, "~> 1.4"},
  {:httpoison, "~> 2.1"}
])

# Get count from command line arguments or default to 5
count = case System.argv() do
  [count_str] -> String.to_integer(count_str)
  _ -> 5
end

# Generate agents
AgentGenerator.generate_agents(count)
