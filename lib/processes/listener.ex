defmodule SSE.Process.Listener do
  @moduledoc """
  a process for listening the tweet1 and tweet2 feeds of the SSE Streaming API
  """
  use GenServer
  @aggregator :aggregator

  def start_link([url, disp_list]) do
    GenServer.start_link(__MODULE__, [url, disp_list])
  end

  def init([url, disp_list]) do
    IO.puts("listener process starts up on #{url}...")
    GenServer.cast(self(), :start_stream)

    {:ok, [url, disp_list]}
  end

  @doc """
  processes incoming info and sends the main data to dispatcher process
  """
  def handle_info(%HTTPoison.AsyncChunk{chunk: chunk}, [url, disp_list]) do
    [type, tweet] = SSE.Utils.TweetParser.process(chunk)

    if type == :panic do
      Enum.map(disp_list, fn disp_proc -> GenServer.cast(disp_proc, [type, tweet]) end)
    end

    if type == :tweet and tweet do
      Enum.map(disp_list, fn disp_proc ->
        GenServer.cast(disp_proc, [tweet["id"], [type, tweet]])
      end)

      GenServer.cast(@aggregator, [:aggregate, tweet: tweet, tweet_id: tweet["id"]])

      if tweet["retweeted_status"] do
        Enum.map(disp_list, fn disp_proc ->
          GenServer.cast(disp_proc, [
            tweet["retweeted_status"]["id"],
            [type, tweet["retweeted_status"]]
          ])
        end)

        GenServer.cast(@aggregator, [
          :aggregate,
          tweet: tweet["retweeted_status"],
          tweet_id: tweet["retweeted_status"]["id"]
        ])
      end
    end

    {:noreply, [url, disp_list]}
  end

  def handle_info(%HTTPoison.AsyncStatus{} = status, [url, disp_list]) do
    IO.puts("Connection status #{inspect(self())}: #{inspect(status)}")

    {:noreply, [url, disp_list]}
  end

  def handle_info(%HTTPoison.AsyncHeaders{} = headers, [url, disp_list]) do
    IO.puts("Connection headers #{inspect(self())}: #{inspect(headers)}")

    {:noreply, [url, disp_list]}
  end

  def handle_info(%HTTPoison.AsyncEnd{}, [url, disp_list]) do
    IO.puts("Connection to the stream feed ends...")
    GenServer.cast(self(), :start_stream)
    {:noreply, [url, disp_list]}
  end

  def handle_cast(:start_stream, [url, disp_list]) do
    HTTPoison.get!(url, [],
      recv_timeout: 10_000,
      timeout: 10_000,
      stream_to: self(),
      hackney: [pool: :default]
    )

    {:noreply, [url, disp_list]}
  end
end
