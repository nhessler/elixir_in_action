defmodule Todo.Supervisor do
  use Supervisor

  # API

  def start_link do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  # Callbacks

  def init(_) do
    IO.puts "starting #{__MODULE__}"

    processes = [worker(Todo.Cache, [])]
    supervise(processes, strategy: :one_for_one)
  end
end
