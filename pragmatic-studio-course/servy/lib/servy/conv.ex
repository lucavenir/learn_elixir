defmodule Servy.Conv do
  defstruct method: "",
            path: "",
            resp_body: "",
            status: nil,
            params: %{},
            headers: %{},
            resp_headers: %{"Content-Type" => "text/html"}

  def full_status(conv) do
    "#{conv.status} #{status_reason(conv.status)}"
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      204 => "No Content",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end

  def put_resp_content_type(%Servy.Conv{} = conv, content_type) do
    resp_headers = Map.put(conv.resp_headers, "Content-Type", content_type)
    %Servy.Conv{conv | resp_headers: resp_headers}
  end

  def put_content_length(%Servy.Conv{} = conv) do
    content_length = Kernel.byte_size(conv.resp_body)
    resp_headers = Map.put(conv.resp_headers, "Content-Length", content_length)
    %Servy.Conv{conv | resp_headers: resp_headers}
  end
end
