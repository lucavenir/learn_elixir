defmodule Servy.Parser do
  alias Servy.Conv

  def parse(request) do
    [top, params] = String.split(request, "\r\n\r\n", parts: 2)
    [request | headers] = String.split(top, "\r\n")
    [method, path, _http_version] = String.split(request, " ")

    parsed_headers = parse_headers(headers)
    parsed_params = parse_params(parsed_headers, params)

    %Conv{
      method: method,
      path: path,
      params: parsed_params,
      headers: parsed_headers
    }
  end

  @doc """
  Parses the given param string of the form `key1=value1&key2=value2`
  into a map of key-value pairs.

  ## Examples
      iex> parse_params(%{"Content-Type" => "application/x-www-form-urlencoded"}, "key1=value1&key2=value2")
      %{"key1" => "value1", "key2" => "value2"}
      iex> parse_params(%{"Content-Type" => "multipart/form-data"}, "some-bytes")
      %{}
  """
  def parse_params(headers, params) do
    do_parse_params(headers["Content-Type"], params)
  end

  defp do_parse_params("application/x-www-form-urlencoded", params) do
    params
    |> String.trim()
    |> URI.decode_query()
  end

  defp do_parse_params(_, _), do: %{}

  @doc false
  def parse_headers(headers) do
    Enum.reduce(headers, %{}, &parse_header/2)
  end

  @doc false
  def parse_header(input, acc) do
    [key, value] = String.split(input, ": ")
    Map.put(acc, key, value)
  end
end
