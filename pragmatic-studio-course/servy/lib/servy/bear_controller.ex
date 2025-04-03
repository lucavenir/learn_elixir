defmodule Servy.BearController do
  alias Servy.Conv
  alias Servy.Wildthings
  alias Servy.Bear

  def index(%Conv{} = conv) do
    response =
      Wildthings.list_bears()
      |> Stream.filter(&Bear.is_grizzly/1)
      |> Enum.sort(&Bear.sort_by_name/2)
      |> Stream.map(&create_bear_li/1)
      |> Enum.join()

    %Conv{conv | status: 200, resp_body: "<ul>#{response}</ul>"}
  end

  defp create_bear_li(%Bear{} = bear) do
    "<li>#{bear.name} (#{bear.type})</li>"
  end

  def show(%Conv{} = conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)

    %Conv{conv | status: 200, resp_body: "<h1>Bear #{bear.id} is named #{bear.name}</h1>"}
  end

  def create(%Conv{} = conv, %{"type" => type, "name" => name}) do
    %Conv{conv | status: 201, resp_body: "created a #{type} bear named #{name}"}
  end

  def delete(%Conv{} = conv, %{"id" => id}) do
    %Conv{conv | status: 204, resp_body: "bear #{id} is gone"}
  end
end
