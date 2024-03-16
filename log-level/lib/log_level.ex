defmodule LogLevel do
  def to_label(level, legacy?) do
    cond do
      level == 0 and not legacy? -> :trace
      level == 1 -> :debug
      level == 2 -> :info
      level == 3 -> :warning
      level == 4 -> :error
      level == 5 and not legacy? -> :fatal
      true -> :unknown
    end
  end

  def alert_recipient(level, legacy?) do
    to_label(level, legacy?) |> alert_based_on_level(legacy?)
  end

  defp alert_based_on_level(level, legacy?) do
    cond do
      level == :error or level == :fatal -> :ops
      level == :unknown and legacy? -> :dev1
      level == :unknown and not legacy? -> :dev2
      true -> false
    end
  end
end
