defmodule ElixirInActionTodoList.TodoList do
  alias ElixirInActionTodoList.{TodoList}

  defstruct auto_id: 1, entries: Map.new

  def new, do: %TodoList{}

  def add_entry(%TodoList{entries: entries, auto_id: auto_id}, entry) do
    entry = Map.put(entry, :id, auto_id)
    new_entries = Map.put(entries, auto_id, entry)
    %TodoList{ entries: new_entries, auto_id: auto_id + 1 }
  end

  def entries(%TodoList{entries: entries}, date) do
    entries
    |> Stream.filter(fn({_, entry}) -> entry.date == date end)
    |> Enum.map(fn({_, entry}) -> entry end)
  end
end
