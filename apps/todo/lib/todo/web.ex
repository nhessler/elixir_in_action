defmodule Todo.Web do

  def start_server do
    IO.puts "starting #{__MODULE__}"
    Plug.Adapters.Cowboy.http(__MODULE__, nil, port: 5454)
  end

  def init(_), do: nil
end
