defmodule Servy.BearController do
  alias Servy.Conv
  alias Servy.Wildthings
  alias Servy.Bear
  alias Servy.View

  def index(%Conv{} = conv) do
    bears =
      Wildthings.list_bears()
      |> Enum.sort(&Bear.sort_by_name/2)

    View.render(conv, "index.eex", bears: bears)
  end

  def show(%Conv{} = conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)
    View.render(conv, "show.eex", bear: bear)
  end

  def create(%Conv{} = conv, %{"type" => type, "name" => name}) do
    %Conv{conv | status: 201, resp_body: "created a #{type} bear named #{name}"}
  end

  def delete(%Conv{} = conv, %{"id" => id}) do
    %Conv{conv | status: 204, resp_body: "bear #{id} is gone"}
  end
end
