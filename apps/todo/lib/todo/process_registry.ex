defmodule Todo.ProcessRegistry do
  use GenServer
  import Kernel, except: [send: 2]

  # API

  def start_link do
    IO.puts "starting #{__MODULE__}"
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def register_name(complex_name, pid) do
    case :ets.lookup(:process_registry, complex_name)  do
      [{^complex_name, _}] -> :no
      _ ->
        GenServer.call(__MODULE__, {:register_name, complex_name, pid})
    end
  end

  def unregister_name(complex_name) do
    GenServer.call(__MODULE__, {:unregister_name, complex_name})
  end

  def whereis_name(complex_name) do
    case :ets.lookup(:process_registry, complex_name)  do
      [{^complex_name, value}] -> value
      _ ->
        :undefined
    end
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

  def init(_) do
    :ets.new(:process_registry, [:set, :named_table, :protected])
    {:ok, nil}
  end

  def handle_call({:register_name, key, pid}, _, registry) do
    case :ets.lookup(:process_registry, key)  do
      [{^key, _}] ->
        {:reply, :no, registry}
      _ ->
        Process.monitor(pid)
        :ets.insert(:process_registry, {key, pid})
        {:reply, :yes, registry}
    end
  end

  def handle_call({:unregister_name, key}, _, registry) do
    :ets.delete(:process_registry, key)
    {:reply, key, registry}
  end

  def handle_info({:DOWN, _, :process, pid, _}, registry) do
    {:noreply, deregister_pid(registry, pid)}
  end

  def handle_info(_, registry), do: {:noreply, registry}

  defp deregister_pid(registry, pid) do
    :ets.match_delete(:process_registry, {:_, pid})
    registry
  end
end
