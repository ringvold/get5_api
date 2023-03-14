defmodule Get5Api.RconServerMock do
  use ThousandIsland.Handler

  require Logger

  alias RCON.Packet

  @terminator_part <<0, 0>>
  @size_part_len 4
  @id_part_len 4
  @kind_part_len 4

  @max_id 2_147_483_647
  @max_body_len 1413
  @min_size @id_part_len + @kind_part_len + byte_size(@terminator_part)

  @type raw :: binary

  @type size :: integer
  @type id :: integer
  @type kind :: :exec | :exec_resp | :auth | :auth_resp
  @type kind_code :: 0 | 2 | 3
  @type body :: binary
  @type from :: :client | :server

  @impl ThousandIsland.Handler
  def handle_data(data, socket, state) do
    handle_packet(socket, data)
    {:continue, state}
  end

  defp handle_packet(socket, <<
         size::32-signed-integer-little,
         id::32-signed-integer-little,
         kind_code::32-signed-integer-little,
         body::binary-size(size - @min_size),
         @terminator_part
       >>) do
    IO.puts("handle_packet")

    with {:ok, kind} <- Packet.kind_from_code(kind_code, :client) do
      case {kind, id, body} do
        {:exec_resp, packet_id, "" = body} ->
          log_command(body)
          send_packet(socket, :exec_resp, packet_id, "", :server)

        {:exec_resp, packet_id, body = body} ->
          dbg(body)
          log_command(body)
          send_packet(socket, :exec_resp, packet_id, 1, :server)

        {:exec, packet_id, body} ->
          log_command(body)
          send_packet(socket, :exec_resp, packet_id, "Command recieved", :server)

        # Handle auth
        {:auth, packet_id, body} ->
          log_command(body)
          send_packet(socket, :exec_resp, packet_id, "", :server)
          send_packet(socket, :auth_resp, packet_id, "ok", :server)

        {bad_kind, bad_id, _body} ->
          {:error, unexpected_packet_error(bad_kind, bad_id)}
      end
    else
      {:error, err} ->
        {:error, err}
    end
  end

  defp handle_packet(
         socket,
         <<size::32-signed-integer-little, id::32-signed-integer-little,
           kind_code::32-signed-integer-little, body::binary>>
       ) do
    IO.inspect size, label: "size"
    IO.inspect id, label: "id"
    IO.inspect kind_code, label: "kind_code"
    IO.inspect body, label: "body"
    send_packet(socket, :exec_resp, id, "Command recieved", :server)
  end

  # @spec send_packet(:gen_tcp.socket(), Packet.t()) :: {:ok, Packet.id()}
  def send_packet(socket, kind, id, body, from) do
    IO.inspect({kind, id, body, from}, label: "sending packet")

    with {:ok, packet_raw} <- encode({kind, id, body, from}),
         :ok <- ThousandIsland.Socket.send(socket, packet_raw),
         do: :ok
  end

  def encode(packet) do
    with {:ok, {kind, id, body, from}} <- check_packet(packet),
         {:ok, kind_code} <- Packet.kind_to_code(kind, from) do
      size = byte_size(body) + @min_size

      header = <<
        size::32-signed-integer-little,
        id::32-signed-integer-little,
        kind_code::32-signed-integer-little
      >>

      {:ok, header <> body <> @terminator_part}
    end
  end

  defp check_packet(packet) do
    cond do
      Packet.body_len(packet) > @max_body_len ->
        {:error, @packet_body_len_error}

      true ->
        {:ok, packet}
    end
  end

  defp log_command(cmd) do
    IO.puts("Received command: #{cmd}")
  end

  defp unexpected_packet_error(kind, id) do
    "Unexpected packet" <> ": kind=#{kind}, id=#{id}"
  end
end
