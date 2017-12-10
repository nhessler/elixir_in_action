defmodule Todo.Server do
  use GenServer

  # Public API

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: global_tuple(name))
  end

  def whereis(name) do
    :global.whereis_name({:todo_server, name})
  end

  def add_entry(server_pid, new_entry) do
    GenServer.cast(server_pid, {:add_entry, new_entry})
  end

  def update_entry(server_pid, entry_id, updater_function) do
    GenServer.cast(server_pid, {:update_entry, entry_id, updater_function})
  end

  def delete_entry(server_pid, entry_id) do
    GenServer.cast(server_pid, {:delete_entry, entry_id})
  end

  def entries(server_pid, date) do
    GenServer.call(server_pid, {:entries, date})
  end

  defp global_tuple(name) do
    {:global, {:todo_server, name}}
  end

  # GenServer Callbacks

  def init(name) do
    IO.puts "starting #{__MODULE__} #{name}"

    new_todo_list = Todo.Database.get(name) || Todo.List.new
    {:ok, {name, new_todo_list}}
  end

  def handle_cast({:add_entry, new_entry}, {name, todo_list}) do
    new_todo_list = Todo.List.add_entry(todo_list, new_entry)
    Todo.Database.store(name, new_todo_list)
    {:noreply, {name, new_todo_list}}
  end

  def handle_cast({:update_entry, entry_id, updater_function}, {name, todo_list}) do
    new_todo_list = Todo.List.update_entry(todo_list, entry_id, updater_function)
    Todo.Database.store(name, new_todo_list)
    {:noreply, {name, new_todo_list}}
  end

  def handle_cast({:delete_entry, entry_id}, {name, todo_list}) do
    new_todo_list = Todo.List.delete_entry(todo_list, entry_id)
    Todo.Database.store(name, new_todo_list)
    {:noreply, {name, new_todo_list}}
  end

  def handle_call({:entries, date}, _, {name, todo_list}) do
    {:reply, Todo.List.entries(todo_list, date), {name, todo_list}}
  end
end
