defmodule Todo.Database do
  use GenServer
  alias Todo.DatabaseWorker, as: Worker

  # API

  def start(db_folder) do
    GenServer.start(__MODULE__, db_folder, name: __MODULE__)
  end

  def store(key, data) do
    GenServer.cast(__MODULE__, {:store, key, data})
  end

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  # Callbacks

  def init(db_folder) do
    workers = 0..2
    |> Enum.map(&(start_worker(&1, db_folder)))
    |> Enum.into(%{})

    {:ok, workers}
  end

  def handle_cast({:store, key, data}, workers) do
    Worker.store(get_worker(workers, key), key, data)
    {:noreply, workers}
  end

  def handle_call({:get, key}, caller, workers) do
    Worker.get(get_worker(workers, key), key, caller)
    {:noreply, workers}
  end

  def handle_info({:workers, caller}, workers) do
    send(caller, {:workers, workers})
    {:noreply, workers}
  end

  defp start_worker(index, db_folder) do
    {:ok, worker_pid} = Worker.start(db_folder)
    {index, worker_pid}
  end

  defp get_worker(workers, key) do
    Map.get(workers, :erlang.phash2(key, 3))
  end
end
