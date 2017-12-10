defmodule Todo.Web do
  use Plug.Router

  plug :match
  plug :dispatch


  post "/add_entry" do
    conn
    |> Plug.Conn.fetch_query_params
    |> add_entry
    |> respond
  end

  get "/entries" do
    conn
    |> Plug.Conn.fetch_query_params
    |> get_entries
    |> respond
  end

  def start_server do
    IO.puts "starting #{__MODULE__}"
    case Application.get_env(:todo, :port) do
      nil  -> raise("Todo port not specified")
      port -> Plug.Adapters.Cowboy.http(__MODULE__, nil, port: port)
    end
  end

  def init(_), do: nil

  defp add_entry(conn) do
    entry = %{
      date: parse_date(conn.params["date"]),
      title: conn.params["title"]
    }

    conn.params["list"]
    |> String.to_atom
    |> Todo.Cache.server_process
    |> Todo.Server.add_entry(entry)

    Plug.Conn.assign(conn, :response, "OK")
  end

  defp get_entries(conn) do
    entries =
      conn.params["list"]
      |> String.to_atom
      |> Todo.Cache.server_process
      |> Todo.Server.entries(parse_date(conn.params["date"]))

    Plug.Conn.assign(conn, :response, build_entries_response(entries))
  end

  defp respond(conn) do
    conn
    |> Plug.Conn.put_resp_content_type("text/plain")
    |> Plug.Conn.send_resp(200, conn.assigns[:response])
  end

  defp parse_date(date) do
    {
      parse_date_unit(date, 0..3),
      parse_date_unit(date, 4..5),
      parse_date_unit(date, 6..7)
    }
  end

  defp parse_date_unit(date, range) do
    date
    |> String.slice(range)
    |> String.to_integer
  end

  defp build_entries_response(entries, response \\ [])
  defp build_entries_response([ entry | rest], response) do
     build_entries_response(rest, [ build_entry_response(entry) | response])
  end

  defp build_entries_response([], response) do
     response
    |> Enum.reverse
    |> Enum.join("\n")
  end

  defp build_entry_response(entry) do
    "#{build_date_response(entry[:date])}\t#{entry[:title]}"
  end

  defp build_date_response(date) do
    "#{elem(date, 0)}-#{elem(date, 1)}-#{elem(date, 2)}"
  end
end
