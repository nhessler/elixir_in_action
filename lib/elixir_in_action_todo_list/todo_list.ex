defmodule ElixirInActionTodoList.TodoList do
  alias ElixirInActionTodoList.{MultiMap}

  def new, do: MultiMap.new

  def add_entry(todo_list, date, todo) do
    MultiMap.add(todo_list, date, todo)
  end

  def entries(todo_list, date), do: MultiMap.get(todo_list, date)
end
