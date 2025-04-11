defmodule Servy do
  use Application

  @impl true
  def start(_type, _args) do
    IO.puts("Starting the application...")
    Servy.Supervisor.start_link()
  end
end
