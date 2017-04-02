defmodule Todo.Supervisor do
  use Supervisor

  # API

  def start_link do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  # Callbacks

  def init(_) do
    IO.puts "starting #{__MODULE__}"

    processes = [
      worker(Todo.ProcessRegistry, []),
      supervisor(Todo.SystemSupervisor, [])
    ]

    supervise(processes, strategy: :rest_for_one)
  end
end
