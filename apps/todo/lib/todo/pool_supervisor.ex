defmodule Todo.PoolSupervisor do
  use Supervisor

  # API

  def start_link(db_folder, pool_size) do
    Supervisor.start_link(__MODULE__, {db_folder, pool_size})
  end

  # Callbacks

  def init({db_folder, pool_size}) do
    IO.puts "starting #{__MODULE__}"

    processes = for worker_id <- 1..pool_size do
      worker(
        Todo.DatabaseWorker,
        [db_folder, worker_id],
        id: {:database_worker, worker_id}
      )
    end

    supervise(processes, strategy: :one_for_one)
  end


end
