defmodule Newsletter do
  def read_emails(path), do: File.read!(path) |> String.split("\n", trim: true)
  def open_log(path), do: File.open!(path, [:write])
  def log_sent_email(pid, email), do: IO.puts(pid, email)
  def close_log(pid), do: File.close(pid)

  def send_newsletter(emails_path, log_path, send_fun) do
    file = emails_path |> read_emails()
    pid = open_log(log_path)
    Enum.each(file, &send_email(&1, send_fun, pid))
    close_log(pid)
  end

  defp send_email(email, send_fun, pid) do
    if send_fun.(email) === :ok, do: log_sent_email(pid, email)
  end
end
