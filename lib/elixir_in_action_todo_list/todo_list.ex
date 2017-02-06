defmodule ElixirInActionTodoList.TodoList do
  alias ElixirInActionTodoList.{MultiMap}

  def new, do: MultiMap.new

  def add_entry(todo_list, entry) do
    MultiMap.add(todo_list, entry.date, entry.title)
  end

  def entries(todo_list, date), do: MultiMap.get(todo_list, date)
end
