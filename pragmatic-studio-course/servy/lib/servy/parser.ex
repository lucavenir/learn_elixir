defmodule Servy.Parser do
  alias Servy.Conv

  def parse(request) do
    [top, params] = String.split(request, "\n\n", parts: 2)
    [request | headers] = String.split(top, "\n")
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

  defp parse_params(headers, params) do
    do_parse_params(headers["Content-Type"], params)
  end

  defp do_parse_params("application/x-www-form-urlencoded", params) do
    params
    |> String.trim()
    |> URI.decode_query()
  end

  defp do_parse_params(_, _), do: %{}

  defp parse_headers(headers) do
    Enum.reduce(headers, %{}, &parse_header/2)
  end

  defp parse_header(input, acc) do
    [key, value] = String.split(input, ": ")
    Map.put(acc, key, value)
  end
end
