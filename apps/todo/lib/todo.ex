defmodule Todo do
  use Application

  @moduledoc """
  This is the todo list app that is built in Elixir in Action

  All uses of `HashDict` have been changed to use `Map`
  """

  def start(_type,  _arguments) do
    Todo.Supervisor.start_link
  end
end
