defmodule Servy.Handler do
  @moduledoc """
  Handles HTTP requests
  """

  alias Servy.Plugins
  alias Servy.Parser
  alias Servy.Conv
  alias Servy.Api
  alias Servy.BearController

  @pages_path Path.expand("pages", File.cwd!())

  @doc """
  Transforms a request into a response
  """
  def handle(request) do
    request
    |> Parser.parse()
    |> Plugins.rewrite_path()
    |> Plugins.log()
    |> route()
    |> Plugins.track()
    |> Conv.put_content_length()
    |> format_response()
  end

  def route(%Conv{method: "POST", path: "/pledges"} = conv) do
    Servy.PledgeController.create(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/pledges"} = conv) do
    Servy.PledgeController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/sensors"} = conv) do
    data = Servy.SensorServer.get_sensor_data()
    %{conv | status: 200, resp_body: inspect(data)}
  end

  def route(%Conv{method: "GET", path: "/kaboom"} = _conv) do
    raise "kaboom"
  end

  def route(%Conv{method: "GET", path: "/hibernate" <> time} = conv) do
    time
    |> String.to_integer()
    |> :timer.sleep()

    %Conv{conv | status: 200, resp_body: "ok I'm awake now"}
  end

  def route(%Conv{method: "GET", path: "/pages/" <> page} = conv) do
    @pages_path
    |> Path.join("#{page}.html")
    |> File.read()
    |> case do
      {:ok, contents} -> %{conv | status: 200, resp_body: contents}
      {:error, :enoent} -> %{conv | status: 404, resp_body: "page not found"}
      {:error, reason} -> %{conv | status: 500, resp_body: "page error: #{reason}"}
    end
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read()
    |> case do
      {:ok, contents} -> %{conv | status: 200, resp_body: contents}
      {:error, :enoent} -> %{conv | status: 404, resp_body: "page not found"}
      {:error, reason} -> %{conv | status: 500, resp_body: "page error: #{reason}"}
    end
  end

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/api/bears"} = conv) do
    Api.BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/new"} = conv) do
    @pages_path
    |> Path.expand(__DIR__)
    |> Path.join("form.html")
    |> File.read()
    |> case do
      {:ok, contents} -> %{conv | status: 200, resp_body: contents}
      {:error, :enoent} -> %{conv | status: 404, resp_body: "page not found"}
      {:error, reason} -> %{conv | status: 500, resp_body: "page error: #{reason}"}
    end
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.show(conv, params)
  end

  def route(%Conv{method: "DELETE", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.delete(conv, params)
  end

  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    BearController.create(conv, conv.params)
  end

  def route(%Conv{method: "POST", path: "/api/bears"} = conv) do
    Api.BearController.create(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: path} = conv) do
    %{conv | status: 404, resp_body: "#{path} route not found"}
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    #{format_response_headers(conv)}
    \r
    #{conv.resp_body}
    """
  end

  def format_response_headers(%Conv{} = conv) do
    conv.resp_headers
    |> Stream.map(fn {key, value} -> "#{key}: #{value}\r" end)
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.join("\n")
  end
end
