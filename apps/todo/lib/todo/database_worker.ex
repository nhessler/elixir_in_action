defmodule Todo.DatabaseWorker do
  use GenServer

  # API

  def start_link(db_folder) do
    GenServer.start_link(__MODULE__, db_folder)
  end

  def store(worker, key, data) do
    GenServer.cast(worker, {:store, key, data} )
  end

  def get(worker, key, caller) do
    GenServer.cast(worker, {:get, key, caller})
  end

  # Callbacks

  def init(db_folder) do
    IO.puts "starting #{__MODULE__}"

    File.mkdir_p(db_folder)
    {:ok, db_folder}
  end

  def handle_cast({:store, key, data}, db_folder) do
    file_name(db_folder, key)
    |> File.write!(:erlang.term_to_binary(data))

    {:noreply, db_folder}
  end

  def handle_cast({:get, key, caller}, db_folder) do
    data = case File.read(file_name(db_folder, key)) do
             {:ok, contents} -> :erlang.binary_to_term(contents)
             _ -> nil
           end

    GenServer.reply(caller, data)

    {:noreply, db_folder}
  end

  defp file_name(folder, file), do: "#{folder}/#{file}"
end
