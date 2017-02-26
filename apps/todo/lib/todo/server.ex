defmodule Todo.Server do
  use GenServer

  # Public API

  def start do
    GenServer.start(__MODULE__, nil)
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

  # GenServer Callbacks

  def init(_) do
    {:ok, Todo.List.new}
  end

  def handle_cast({:add_entry, new_entry}, todo_list) do
    {:noreply, Todo.List.add_entry(todo_list, new_entry)}
  end

  def handle_cast({:update_entry, entry_id, updater_function}, todo_list) do
    {:noreply, Todo.List.update_entry(todo_list, entry_id, updater_function)}
  end

  def handle_cast({:delete_entry, entry_id}, todo_list) do
    {:noreply, Todo.List.delete_entry(todo_list, entry_id)}
  end

  def handle_call({:entries, date}, _, todo_list) do
    {:reply, Todo.List.entries(todo_list, date), todo_list}
  end
end
