defmodule SSE.Process.Aggregator do
  use GenServer
  @batch_size 100
  @timeframe 1_000

  def start_link(name) do
    GenServer.start_link(__MODULE__, [], name: name)
  end

  def init([]) do
    IO.puts("aggregator process starts up...")
    Process.send_after(self(), :batch, @timeframe)

    {:ok, %{tweet: %{}, engagement: %{}, sentiment: %{}}}
  end

  def handle_cast([:aggregate, tweet: data, tweet_id: id], %{
        tweet: tm,
        engagement: _em,
        sentiment: _sm
      }) do
    key = String.to_atom("#{id}")

    tm = Map.put_new(tm, key, %{tweet: data})

    {:noreply, %{tweet: tm, engagement: _em, sentiment: _sm}}
  end

  def handle_cast([:aggregate, engagement: data, tweet_id: id], %{
        tweet: _tm,
        engagement: em,
        sentiment: _sm
      }) do
    key = String.to_atom("#{id}")

    em = Map.put_new(em, key, %{engagement: data})

    {:noreply, %{tweet: _tm, engagement: em, sentiment: _sm}}
  end

  def handle_cast([:aggregate, sentiment: data, tweet_id: id], %{
        tweet: _tm,
        engagement: _em,
        sentiment: sm
      }) do
    key = String.to_atom("#{id}")

    sm = Map.put_new(sm, key, %{sentiment: data})

    {:noreply, %{tweet: _tm, engagement: _em, sentiment: sm}}
  end

  def batch_complete(batch_map) do
    Map.filter(batch_map, fn {k, vals} -> Enum.count(vals) == 3 end)
  end

  def update_rem(first, second, third) do
    Map.filter(first, fn {k, vals} -> !Map.has_key?(second, k) end)
    |> Map.filter(fn {k, vals} -> !Map.has_key?(third, k) end)
  end

  def handle_info(:batch, %{tweet: tm, engagement: em, sentiment: sm}) do
    first = Map.merge(sm, em, fn _k, val1, val2 -> [val1, val2] end)
    second = Map.merge(first, tm, fn _k, val1, val2 -> List.flatten([val1, val2]) end)

    sentiment_update = update_rem(sm, em, tm)
    engagement_update = update_rem(em, sm, tm)
    tweet_update = update_rem(tm, em, sm)

    completed = batch_complete(second)

    IO.inspect("current tweets: #{Enum.count(tm)}")
    IO.inspect("current engagement: #{Enum.count(em)}")
    IO.inspect("current sentiment: #{Enum.count(sm)}")
    IO.inspect(first)
    Process.send_after(self(), :batch, @timeframe)

    {:noreply, %{tweet: tweet_update, engagement: engagement_update, sentiment: sentiment_update}}
  end
end
