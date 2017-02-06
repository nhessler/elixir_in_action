defmodule ElixirInActionTodoList.TodoList do
  def new, do: %{}

  def add_entry(todo_list, date, todo) do
    Map.update(
      todo_list,
      date,
      [todo],
      fn(todos) -> [todo | todos] end)
  end

  def entries(todo_list, date), do: Map.get(todo_list, date, [])
end
