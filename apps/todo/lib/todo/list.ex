defmodule Todo.List do

  defstruct auto_id: 1, entries: Map.new

  def new(entries \\ []) do
    Enum.reduce(
      entries,
      %Todo.List{},
      fn(entry, list) -> add_entry(list, entry) end)
  end

  def add_entry(%Todo.List{entries: entries, auto_id: auto_id}, entry) do
    entry = Map.put(entry, :id, auto_id)
    new_entries = Map.put(entries, auto_id, entry)
    %Todo.List{ entries: new_entries, auto_id: auto_id + 1 }
  end

  def entries(%Todo.List{entries: entries}, date) do
    entries
    |> Stream.filter(fn({_, entry}) -> entry.date == date end)
    |> Enum.map(fn({_, entry}) -> entry end)
  end

  def update_entry(%Todo.List{entries: entries} = todo_list, entry_id, updater_function) do
    case entries[entry_id] do
      nil -> todo_list
      old_entry ->
        new_entry = %{id: ^entry_id} = updater_function.(old_entry)
        new_entries = Map.put(entries, entry_id, new_entry)
        %Todo.List{ todo_list | entries: new_entries}
    end
  end

  def delete_entry(%Todo.List{entries: entries} = todo_list, entry_id) do
    new_entries = Map.delete(entries, entry_id)
    %{todo_list | entries: new_entries}
  end
end
