defmodule Todo.ProcessRegistry do
  use GenServer
  import Kernel, except: [send: 2]

  # API

  def start_link do
    IO.puts "starting #{__MODULE__}"
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def register_name(complex_name, pid) do
    GenServer.call(__MODULE__, {:register_name, complex_name, pid})
  end

  def unregister_name(complex_name) do
    GenServer.call(__MODULE__, {:unregister_name, complex_name})
  end

  def whereis_name(complex_name) do
    GenServer.call(__MODULE__, {:whereis_name, complex_name})
  end

  def send(key, message) do
    case whereis_name(key) do
      :undefined -> {:badarg, {key, message}}
      pid ->
        Kernel.send(pid, message)
        pid
    end
  end

  # Callbacks

  def handle_call({:register_name, key, pid}, _, registry) do
    case Map.get(registry, key) do
      nil ->
        Process.monitor(pid)
        {:reply, :yes, Map.put(registry, key, pid)}
      _ ->
        {:reply, :no, registry}
    end
  end

  def handle_call({:whereis_name, key}, _, registry) do
    {:reply, Map.get(registry, key, :undefined), registry}
  end

  def handle_call({:unregister_name, key}, _, registry) do
    {:reply, key, Map.delete(registry, key)}
  end

  def handle_info({:DOWN, _, :process, pid, _}, registry) do
    {:noreply, deregister_pid(registry, pid)}
  end

  def handle_info(_, registry), do: {:noreply, registry}

  defp deregister_pid(registry, pid) do
    registry
    |> Enum.reject(fn {_, v} -> v == pid end)
    |> Enum.into(%{})
  end
end
