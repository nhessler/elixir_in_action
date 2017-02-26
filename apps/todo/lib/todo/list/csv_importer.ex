defmodule Todo.List.CsvImporter do

  def import!(filename) do
    filename
    |> File.stream!()
    |> Stream.map(&String.replace(&1, ~r/\n/, ""))
    |> Stream.map(&(String.split(&1, ",")))
    |> Stream.map(&build_date_tuple/1)
    |> Enum.to_list()
    |> Todo.List.new()
  end

  defp build_date_tuple([date_string, title]) do
    [y, m, d] = String.split(date_string, "/")
    %{date: {String.to_integer(y), String.to_integer(m), String.to_integer(d)},
      title: title }
  end
end
