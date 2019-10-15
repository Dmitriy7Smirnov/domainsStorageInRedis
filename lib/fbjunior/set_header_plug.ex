defmodule Plug.Header do
  import Plug.Conn
  def init([]), do: false
  def call(conn, _opts) do
    put_resp_content_type(conn, "application/json")
  end
end
