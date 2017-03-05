defmodule MultiMap do
  def new, do: %{}

  def add(todo_list, date, todo) do
    Map.update(
      todo_list,
      date,
      [todo],
      &[ todo | &1 ])
  end

  def get(todo_list, date), do: Map.get(todo_list, date, [])
end
