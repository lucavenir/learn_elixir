defmodule Servy.Plugins do
  @doc """
  Logs 404 requests
  """
  alias Servy.Conv

  require Logger

  def track(%Conv{status: 404, path: path} = conv) do
    if Mix.env() != :test do
      Logger.warning("Error: #{path} not found")
    end

    conv
  end

  def track(%Conv{} = conv), do: conv

  def rewrite_path(%Conv{path: "/wildlife"} = conv) do
    %Conv{conv | path: "/wildthings"}
  end

  def rewrite_path(%Conv{path: path} = conv) do
    ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    |> Regex.named_captures(path)
    |> do_rewrite_path(conv)
  end

  defp do_rewrite_path(%{"thing" => thing, "id" => id}, conv) do
    %{conv | path: "/#{thing}/#{id}"}
  end

  defp do_rewrite_path(nil, conv), do: conv

  def log(%Conv{} = conv) do
    if Mix.env() == :dev do
      IO.inspect(conv)
    end

    conv
  end
end
