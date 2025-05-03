defmodule AgentGenerator do
  @allowed_subdistricts [
    "Mapanget", "Sukmajaya", "Jiwan", "Sawahan", "Sukajadi", "Natar",
    "Indihiang", "Tulis", "Ujungberung", "Cempaka Putih", "Cibinong",
    "Curug", "Cipayung", "Denpasar Selatan", "Tanah Abang", "Mimika baru",
    "Jeruklegi", "Krembung", "Mertoyudan", "Kramat", "Penjaringan", "Sungai Raya"
  ]

  def read_subdistricts do
    "data/subdistricts.json"
    |> File.read!()
    |> Jason.decode!()
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

  def generate_agent(subdistrict) do
    alamat = "#{subdistrict["subdistrict_name"]}, #{subdistrict["city"]}, #{subdistrict["province"]}, Indonesia"
    {latitude, longitude} = WilayahElixir.Coordinates.get_coordinates(alamat)

    %{
      code: generate_uuid(),
      name: "#{Enum.random(toko_names())}",
      phone_number: generate_phone(),
      subdistrict_name: subdistrict["subdistrict_name"],
      subdistrict_id: subdistrict["subdistrict_id"],
      city: subdistrict["city"],
      city_id: subdistrict["city_id"],
      province: subdistrict["province"],
      province_id: subdistrict["province_id"],
      latitude: latitude,
      longitude: longitude,
      address: alamat
    }
  end

  def generate_agents(count) do
    subdistricts = read_subdistricts()
    |> Enum.filter(fn subdistrict ->
      subdistrict["subdistrict_name"] in @allowed_subdistricts
    end)

    if Enum.empty?(subdistricts) do
      IO.puts("Error: No matching subdistricts found in the data")
      exit(1)
    end

    agents = for _ <- 1..count do
      subdistrict = Enum.random(subdistricts)
      generate_agent(subdistrict)
    end

    json = Jason.encode!(agents, pretty: true)
    File.write!("data/agents.json", json)

    IO.puts("Generated #{count} agents in data/agents.json")
  end
end

# Get count from command line arguments or default to 5
count = case System.argv() do
  [count_str] -> String.to_integer(count_str)
  _ -> 5
end

# Generate agents
AgentGenerator.generate_agents(count)
