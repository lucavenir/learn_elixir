defmodule Servy.GenericServer do
  def start(module, initial_state, name) do
    pid = spawn(__MODULE__, :listen_loop, [initial_state, module])
    Process.register(pid, name)
    {:ok, pid}
  end

  def call(pid, message) do
    send(pid, {:call, self(), message})

    receive do
      {:response, response} -> response
    end
  end

  def cast(pid, message) do
    send(pid, {:cast, message})
  end

  def listen_loop(state, module) do
    receive do
      {:call, sender, message} when is_pid(sender) ->
        {response, new_state} = module.handle_call(message, state)
        send(sender, {:response, response})
        listen_loop(new_state, module)

      {:cast, message} ->
        new_state = module.handle_cast(message, state)
        listen_loop(new_state, module)

      info ->
        new_state = module.handle_info(info, state)
        listen_loop(new_state, module)
    end
  end
end
