defmodule Servy.Handler do
  @moduledoc """
  Handles HTTP requests
  """

  alias Servy.Plugins
  alias Servy.Parser
  alias Servy.Conv
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
    |> format_response()
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

  def route(%Conv{method: "GET", path: path} = conv) do
    %{conv | status: 404, resp_body: "#{path} route not found"}
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    Content-Type: text/html\r
    Content-Length: #{Kernel.byte_size(conv.resp_body) + Kernel.byte_size(emojify(conv.status))}\r
    \r
    #{emojify(conv.status)} #{conv.resp_body}
    """
  end

  defp emojify(code) when code >= 200 and code < 300, do: "😃"
  defp emojify(code) when code >= 300 and code < 400, do: "😐"
  defp emojify(code) when code >= 400 and code < 500, do: "😞"
  defp emojify(code) when code >= 500, do: "😱"
end
