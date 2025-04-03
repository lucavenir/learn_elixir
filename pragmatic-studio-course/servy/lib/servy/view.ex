defmodule Servy.View do
  alias Servy.Conv

  @templates_path Path.expand("templates", File.cwd!())

  def render(%Conv{} = conv, template, bindings) do
    content =
      @templates_path
      |> Path.expand(__DIR__)
      |> Path.join(template)
      |> EEx.eval_file(bindings)

    %Conv{conv | status: 200, resp_body: content}
  end
end
