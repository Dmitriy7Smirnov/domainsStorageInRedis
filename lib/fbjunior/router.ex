# Для веб сервера нужен маршрутизатор, место ему именно тут.
defmodule Router do
  use Plug.Router
  require Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Jason

  plug Plug.Header
  plug(:match)
  plug(:dispatch)


  # Submit links
  post "/visited_links" do
    #IO.inspect conn.body_params
    {status, body} = case conn.body_params do
      %{"links" => links} when is_list(links) ->
        now = Utils.timestamp()
        domains = for link <- links do
                    {:ok, domain} = Utils.domain(link)
                    domain
                  end
        Utils.set_domains(domains, now)
        {200, Jason.encode!(%{status: "ok"})}
      _ ->
        body = Jason.encode!(%{error: "Bad Request"})
        {400, body}
    end
    conn.send_resp(status, body)
  end

  # Get unique domains
  get "/visited_domains" do
    {status, body} = case conn.query_params do
      %{"from" => from0, "to" => to0} ->
        {from, _} = Integer.parse(from0)
        {to, _} = Integer.parse(to0)
        domains = Utils.get_domains(from, to)
        my_status = "ok"
        body = Jason.encode!(%{domains: domains, status: my_status})
        {200, body}
      _ ->
        body = Jason.encode!(%{error: "Bad Request"})
        {400, body}
      end
      conn.send_resp(status, body)
  end

  # Catch-up
  match _ do
    status = 404
    body = Jason.encode!(%{error: "Not found"})
    conn.send_resp(status, body)
  end
end

