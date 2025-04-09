defmodule Servy.PledgeServer do
  # client interface
  def start(initial_state \\ []) do
    pid = spawn(__MODULE__, :listen_loop, [initial_state])
    Process.register(pid, __MODULE__)
    {:ok, pid}
  end

  def create_pledge(name, amount) do
    send(__MODULE__, {self(), :create, name, amount})

    receive do
      {:ok, status} -> status
    end
  end

  def recent_pledges() do
    send(__MODULE__, {self(), :read})

    receive do
      {:ok, cached_pledges} -> cached_pledges
    end
  end

  def total_pledged() do
    send(__MODULE__, {self(), :total})

    receive do
      {:ok, total} -> total
    end
  end

  # server logic
  def listen_loop(state) do
    receive do
      {creator, :create, name, amount} ->
        {:ok, id} = send_pledge_to_service(name, amount)
        most_recent = Enum.take(state, 2)
        new_state = [{name, amount} | most_recent]
        send(creator, {:ok, id})
        listen_loop(new_state)

      {requester, :read} ->
        send(requester, {:ok, state})
        listen_loop(state)

      {requester, :total} ->
        total = Enum.sum_by(state, fn {_name, amount} -> amount end)
        send(requester, {:ok, total})
        listen_loop(state)

      unexpected ->
        IO.puts("Unexpected message: #{inspect(unexpected)}")
        listen_loop(state)
    end
  end

  defp send_pledge_to_service(_name, _amount) do
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end
