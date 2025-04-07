defmodule Servy.Wildthings do
  alias Servy.Bear

  @db_path Path.expand("db", File.cwd!())

  def get_bear(id) when is_binary(id) do
    id
    |> String.to_integer()
    |> get_bear()
  end

  def get_bear(id) when is_integer(id) do
    Enum.find(list_bears(), fn bear -> bear.id == id end)
  end

  def list_bears() do
    @db_path
    |> Path.join("bears.json")
    |> File.read!()
    |> JSON.decode!()
    |> Map.fetch!("bears")
    |> Enum.map(fn map ->
      %Bear{
        id: map["id"],
        name: map["name"],
        type: map["type"],
        hibernating: map["hibernating"] || false
      }
    end)
  end
end
