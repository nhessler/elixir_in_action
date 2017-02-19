defmodule ElixirInActionTodoList.TodoServer do
  alias ElixirInActionTodoList.{TodoList}

  use GenServer

  # Public API

  def start do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def add_entry(new_entry) do
    GenServer.cast(__MODULE__, {:add_entry, new_entry})
  end

  def update_entry(entry_id, updater_function) do
    GenServer.cast(__MODULE__, {:update_entry, entry_id, updater_function})
  end

  def delete_entry(entry_id) do
    GenServer.cast(__MODULE__, {:delete_entry, entry_id})
  end

  def entries(date) do
    GenServer.call(__MODULE__, {:entries, date})
  end

  # GenServer Callbacks

  def init(_) do
    {:ok, TodoList.new}
  end

  def handle_cast({:add_entry, new_entry}, todo_list) do
    {:noreply, TodoList.add_entry(todo_list, new_entry)}
  end

  def handle_cast({:update_entry, entry_id, updater_function}, todo_list) do
    {:noreply, TodoList.update_entry(todo_list, entry_id, updater_function)}
  end

  def handle_cast({:delete_entry, entry_id}, todo_list) do
    {:noreply, TodoList.delete_entry(todo_list, entry_id)}
  end

  def handle_call({:entries, date}, _, todo_list) do
    {:reply, TodoList.entries(todo_list, date), todo_list}
  end
end
