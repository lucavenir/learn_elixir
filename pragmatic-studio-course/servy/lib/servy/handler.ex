defmodule Servy.Handler do
  require Logger

  def handle(request) do
    request
    |> parse()
    |> rewrite_path()
    |> log()
    |> route()
    |> track()
    |> format_response()
  end

  def track(%{status: 404, path: path} = conv) do
    Logger.warning("Error: #{path} not found")
    conv
  end

  def track(conv), do: conv

  def rewrite_path(%{path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

  def rewrite_path(%{path: path} = conv) do
    ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    |> Regex.named_captures(path)
    |> do_rewrite_path(conv)
  end

  defp do_rewrite_path(%{"thing" => thing, "id" => id}, conv) do
    %{conv | path: "/#{thing}/#{id}"}
  end

  defp do_rewrite_path(nil, conv), do: conv

  def log(conv), do: IO.inspect(conv)

  def parse(request) do
    [method, path, _version] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{
      method: method,
      path: path,
      resp_body: "",
      status: nil
    }
  end

  def route(%{method: "GET", path: "/pages/" <> page} = conv) do
    "../pages"
    |> Path.expand(__DIR__)
    |> Path.join("#{page}.html")
    |> File.read()
    |> case do
      {:ok, contents} -> %{conv | status: 200, resp_body: contents}
      {:error, :enoent} -> %{conv | status: 404, resp_body: "page not found"}
      {:error, reason} -> %{conv | status: 500, resp_body: "page error: #{reason}"}
    end
  end

  def route(%{method: "GET", path: "/about"} = conv) do
    "../pages"
    |> Path.expand(__DIR__)
    |> Path.join("about.html")
    |> File.read()
    |> case do
      {:ok, contents} -> %{conv | status: 200, resp_body: contents}
      {:error, :enoent} -> %{conv | status: 404, resp_body: "page not found"}
      {:error, reason} -> %{conv | status: 500, resp_body: "page error: #{reason}"}
    end
  end

  def route(%{method: "GET", path: "/wildthings"} = conv) do
    %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%{method: "GET", path: "/bears"} = conv) do
    %{conv | status: 200, resp_body: "Teddy, Smokey, Paddington"}
  end

  def route(%{method: "GET", path: "/bears/new"} = conv) do
    "../pages"
    |> Path.expand(__DIR__)
    |> Path.join("form.html")
    |> File.read()
    |> case do
      {:ok, contents} -> %{conv | status: 200, resp_body: contents}
      {:error, :enoent} -> %{conv | status: 404, resp_body: "page not found"}
      {:error, reason} -> %{conv | status: 500, resp_body: "page error: #{reason}"}
    end
  end

  def route(%{method: "GET", path: "/bears/" <> id} = conv) do
    %{conv | status: 200, resp_body: "#{id} is a bear, apparently"}
  end

  def route(%{method: "DELETE", path: "/bears/" <> id} = conv) do
    %{conv | status: 204, resp_body: "bear #{id} is gone"}
  end

  def route(%{method: "GET", path: path} = conv) do
    %{conv | status: 404, resp_body: "#{path} route not found"}
  end

  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{Kernel.byte_size(conv.resp_body) + Kernel.byte_size(emojify(conv.status))}

     #{emojify(conv.status)} #{conv.resp_body}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      204 => "No Content",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end

  defp emojify(code) when code >= 200 and code < 300, do: "😃"
  defp emojify(code) when code >= 300 and code < 400, do: "😐"
  defp emojify(code) when code >= 400 and code < 500, do: "😞"
  defp emojify(code) when code >= 500, do: "😱"
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts(response)

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts(response)

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts(response)

request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts(response)

request = """
DELETE /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts(response)

request = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts(response)

request = """
GET /bears?id=1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts(response)

request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts(response)

request = """
GET /bears/new HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts(response)
