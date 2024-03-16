defmodule TakeANumber do
  def start() do
    spawn(&f/0)
  end

  defp f(state \\ 0) do
    receive do
      :stop ->
        nil

      {:report_state, sender_pid} ->
        send(sender_pid, state)
        f(state)

      {:take_a_number, sender_pid} ->
        send(sender_pid, state + 1)
        f(state + 1)

      _ ->
        f(state)
    end
  end
end
