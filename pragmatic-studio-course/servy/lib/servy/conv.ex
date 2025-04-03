defmodule Servy.Conv do
  defstruct method: "", path: "", resp_body: "", status: nil, params: %{}, headers: %{}

  def full_status(conv) do
    "#{conv.status} #{status_reason(conv.status)}"
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      204 => "No Content",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end
end
