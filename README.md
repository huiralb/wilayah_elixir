# WilayahElixir
Daftar Wilayah administras Indonesia. Data diambil dari Raja Ongkir. Jadi id wilayah sudah sesuai.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `wilayah_elixir` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:wilayah_elixir, "~> 0.1.0"}
  ]
end
```

## Usage Fetch Wilayah
```bash
# fetch provinces
mix run scripts/fetch_provinces.exs
# fetch cities
mix run scripts/fetch_cites.exs
# fetch subdistricts
mix run scripts/fetch_subdistricts.exs
```

## Usage Generate Agent/Toko
```bash
# generate 100 agent
elixir scripts/generate_agents.exs 100
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/wilayah_elixir>.

