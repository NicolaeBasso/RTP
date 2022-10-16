defmodule SSE.Process.EngagementWorker do
  @moduledoc """
  describes a process which handles the incoming data
  from the dispatcher
  """
  use GenServer
  @worker_idle 50..500
  @aggregator :aggregator

  def start_link(scaler_proc) do
    GenServer.start_link(__MODULE__, scaler_proc, [])
  end

  def init(scaler_proc) do
    {:ok, scaler_proc}
  end

  def calculate_engagement(favorites, retweets, followers) when followers != 0 do
    (favorites + retweets) / followers
  end

  def calculate_engagement(favorites, retweets, followers) when followers == 0 do
    0.0
  end

  @doc """
  async function to handle common data and event errors
  """
  def handle_cast([tweet_id, [:tweet, msg]], scaler_proc) do
    favorites = msg["favorite_count"]
    retweets = msg["retweet_count"]
    followers = msg["user"]["followers_count"]

    engagement = calculate_engagement(favorites, retweets, followers)

    GenServer.cast(@aggregator, [:aggregate, engagement: engagement, tweet_id: tweet_id])

    Enum.random(@worker_idle)
    |> Process.sleep()

    GenServer.cast(scaler_proc, :dec)

    {:noreply, scaler_proc}
  end

  def handle_cast([:panic, msg], scaler_proc) do
    Enum.random(@worker_idle)
    |> Process.sleep()

    GenServer.cast(scaler_proc, [:killonce, self()])

    {:noreply, scaler_proc}
  end
end
