defmodule ElixirInActionTodoList.TodoServer do
  alias ElixirInActionTodoList.{TodoList}
  def start do
    pid = spawn(fn -> loop(TodoList.new) end)
    Process.register(pid, __MODULE__)
  end

  def add_entry(new_entry) do
    send(__MODULE__, {:add_entry, new_entry})
  end

  def update_entry(entry_id, updater_function) do
    send(__MODULE__, {:update_entry, entry_id, updater_function})
  end

  def delete_entry(entry_id) do
    send(__MODULE__, {:delete_entry, entry_id})
  end

  def entries(date) do
    send(__MODULE__, {:entries, self, date})
    receive do
      {:todo_entries, entries} -> entries
      after 5000 -> {:error, :timeout}
    end
  end

  defp loop(todo_list) do
    new_todo_list = receive do
      {:add_entry, new_entry} ->
        TodoList.add_entry(todo_list, new_entry)
      {:update_entry, entry_id, updater_function} ->
        TodoList.update_entry(todo_list, entry_id, updater_function)
      {:delete_entry, entry_id} ->
        TodoList.delete_entry(todo_list, entry_id)
      {:entries, caller, date} ->
        send(caller, {:todo_entries, TodoList.entries(todo_list, date)})
        todo_list
    end

    loop(new_todo_list)
  end
end
