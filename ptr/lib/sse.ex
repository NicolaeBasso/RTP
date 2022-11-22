# Run:
# SSE.Reader.start("localhost:4000/tweets/1")
# SSE.Reader.start("localhost:4000/tweets/1")
# SSE.Reader.start()

defmodule SSE.Reader do
  use GenServer

  def start() do
    stream_1_link = "localhost:4000/tweets/1"
    stream_2_link = "localhost:4000/tweets/1"
    GenServer.start_link(__MODULE__, url: stream_1_link)
  end

  def init([url: url]) do
    IO.puts "Connecting to stream..."
    HTTPoison.get!(url, [], [recv_timeout: :infinity, stream_to: self()])
    {:ok, nil}
  end

  def handle_info(%HTTPoison.AsyncChunk{chunk: chunk}, _state) do
    case Regex.run(~r/^event:(\w+)\ndata:({.+})\n\n$/, chunk) do
      [_, event, data] ->
        _json = Jason.decode!(data)
		IO.puts chunk
      nil ->
        raise "Don't know how to parse received chunk: \"#{chunk}\""
    end

    {:noreply, nil}
  end

  # In addition to message chunks, we also may receive status changes etc.
  def handle_info(%HTTPoison.AsyncStatus{} = status, _state) do
    IO.puts "Connection status: #{inspect status}"
    {:noreply, nil}
  end

  def handle_info(%HTTPoison.AsyncHeaders{} = headers, _state) do
    IO.puts "Connection headers: #{inspect headers}"
    {:noreply, nil}
  end
end
