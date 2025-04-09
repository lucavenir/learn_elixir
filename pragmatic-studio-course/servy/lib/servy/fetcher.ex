defmodule Servy.Fetcher do
  def fetch_async(fetcher) do
    parent = self()
    spawn(fn -> send(parent, {:ok, {self(), fetcher.()}}) end)
  end

  def get_result(pid) do
    receive do
      {:ok, {^pid, value}} -> value
    after
      4000 -> raise "time out baby"
    end
  end
end
