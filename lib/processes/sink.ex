defmodule SSE.Process.Sink do
  alias Schemas.Tweets, as: Tweets
  alias Schemas.User, as: User
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, [], name: name)
  end

  def init([]) do
    IO.puts("sink process starts up...")
    {:ok, nil}
  end

  def insert_data(tweet_list) do
    sentiment = Enum.filter(tweet_list, fn {k, v} -> k == :sentiment end)
    engagement = Enum.filter(tweet_list, fn {k, v} -> k == :engagement end)
    tweet = Enum.filter(tweet_list, fn {k, v} -> k == :tweet end)
  end

  def handle_cast([:insert, batch: data], _status) do
    # Enum.each(data, fn {key, tweet_list} -> insert_data(tweet_list) end)
    {:noreply, nil}
  end
end
