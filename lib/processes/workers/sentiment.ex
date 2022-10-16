defmodule SSE.Process.SentimentWorker do
  @moduledoc """
  describes a process which handles the incoming data
  from the dispatcher
  """
  use GenServer
  require SSE.Utils.EmotionParser
  @aggregator :aggregator

  @worker_idle 50..500
  @emotion_url "http://localhost:4000/emotion_values"

  def start_link(scaler_proc) do
    GenServer.start_link(__MODULE__, scaler_proc, [])
  end

  def init(scaler_proc) do
    emotion_dict = HTTPoison.get!(@emotion_url).body |> SSE.Utils.EmotionParser.process()
    {:ok, [scaler_proc, emotion_dict]}
  end

  def emotional_val(word, emotion_dict) do
    cond do
      Map.has_key?(emotion_dict, word) -> String.to_integer(emotion_dict[word])
      true -> 0.0
    end
  end

  @doc """
  async function to handle common data and event errors
  """
  def handle_cast([tweet_id, [:tweet, msg]], [scaler_proc, emotion_dict]) do
    msg_arr = String.split(msg["text"])
    emotional_sum = Enum.reduce(msg_arr, 0, fn x, acc -> emotional_val(x, emotion_dict) + acc end)
    sentiment = emotional_sum / Enum.count(msg_arr)

    GenServer.cast(@aggregator, [:aggregate, sentiment: sentiment, tweet_id: tweet_id])

    Enum.random(@worker_idle)
    |> Process.sleep()

    GenServer.cast(scaler_proc, :dec)

    {:noreply, [scaler_proc, emotion_dict]}
  end

  def handle_cast([:panic, msg], [scaler_proc, emotion_dict]) do
    Enum.random(@worker_idle)
    |> Process.sleep()

    GenServer.cast(scaler_proc, [:killonce, self()])

    {:noreply, [scaler_proc, emotion_dict]}
  end
end
