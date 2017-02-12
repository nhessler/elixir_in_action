defimpl Collectable, for: ElixirInActionTodoList.TodoList do
  def into(original) do
    {original, &into_callback/2}
  end


  defp into_callback(todo_list, :done), do: todo_list
  defp into_callback(_todo_list, :halt), do: :ok
  defp into_callback(todo_list, {:cont, entry}) do
    ElixirInActionTodoList.TodoList.add_entry(todo_list, entry)
  end

end
