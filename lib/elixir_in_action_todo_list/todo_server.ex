defmodule ElixirInActionTodoList.TodoServer do
  alias ElixirInActionTodoList.{TodoList, ServerProcess}

  # Public API

  def start do
    ServerProcess.start(__MODULE__)
  end

  def add_entry(new_entry) do
    ServerProcess.cast(__MODULE__, {:add_entry, new_entry})
  end

  def update_entry(entry_id, updater_function) do
    ServerProcess.cast(__MODULE__, {:update_entry, entry_id, updater_function})
  end

  def delete_entry(entry_id) do
    ServerProcess.cast(__MODULE__, {:delete_entry, entry_id})
  end

  def entries(date) do
    ServerProcess.call(__MODULE__, {:entries, date})
  end

  # ServerProcess Callbacks


  def init() do
    TodoList.new
  end

  def handle_cast({:add_entry, new_entry}, todo_list) do
    TodoList.add_entry(todo_list, new_entry)
  end

  def handle_cast({:update_entry, entry_id, updater_function}, todo_list) do
    TodoList.update_entry(todo_list, entry_id, updater_function)
  end

  def handle_cast({:delete_entry, entry_id}, todo_list) do
    TodoList.delete_entry(todo_list, entry_id)
  end

  def handle_call({:entries, date}, todo_list) do
    {TodoList.entries(todo_list, date), todo_list}
  end
end
