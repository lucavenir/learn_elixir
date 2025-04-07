defmodule Servy.Api.BearController do
  alias Servy.Conv

  def index(%Conv{} = conv) do
    json =
      Servy.Wildthings.list_bears()
      |> Enum.map(&Map.from_struct/1)
      |> JSON.encode!()

    conv = Conv.put_resp_content_type(conv, "application/json")

    %Conv{conv | status: 200, resp_body: json}
  end

  def create(%Conv{} = conv, %{"type" => type, "name" => name}) do
    %Conv{conv | status: 201, resp_body: "Created a #{type} bear named #{name}!"}
  end
end
