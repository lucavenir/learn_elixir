defmodule NameBadge do
  def print(id, name, department) do
    prefix = if id, do: "[#{id}] - ", else: ""
    suffix = if(department, do: "#{department |> String.upcase()}", else: "OWNER")
    prefix <> "#{name} - " <> suffix
  end
end
