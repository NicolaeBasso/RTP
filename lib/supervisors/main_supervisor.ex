defmodule SSE.Supervisor.Main do
  @moduledoc """
  module created to run all children supervisors,
  Essentially, it is a main supervisor.
  """

  use Supervisor

  # @tweet1 "http://127.0.0.1:4000/tweets/1"
  # @tweet2 "http://127.0.0.1:4000/tweets/2"

  @tweet1 "localhost:4000/tweets/1"
  @tweet2 "localhost:4000/tweets/2"

  # @tweet1 "stream_processor-twitter_api-1:4000/tweets/1"
  # @tweet2 "stream_processor-twitter_api-1:4000/tweets/2"

  # @tweet1 "twitter_api:4000/tweets/1"
  # @tweet2 "twitter_api:4000/tweets/2"

  # localhost:4000

  @listener_sup :listener_sup
  @pool_sup1 [
    pool_sup: :pool_sup1,
    worker_sup: :worker_sup1,
    disp_proc: :disp_proc1,
    scaler_proc: :scaler_proc1,
    type: :sentiment
  ]

  @pool_sup2 [
    pool_sup: :pool_sup2,
    worker_sup: :worker_sup2,
    disp_proc: :disp_proc2,
    scaler_proc: :scaler_proc2,
    type: :engagement
  ]
  @disp_list [@pool_sup1[:disp_proc], @pool_sup2[:disp_proc]]

  @aggregator :aggregator
  @sink :sink

  @doc """
  runs the main supervisor
  """
  def start_link([]) do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    IO.puts("main supervisor starts up...")

    children = [
      Supervisor.child_spec({SSE.Supervisor.Pool, @pool_sup1}, id: @pool_sup1[:pool_sup]),
      Supervisor.child_spec({SSE.Supervisor.Pool, @pool_sup2}, id: @pool_sup2[:pool_sup]),
      Supervisor.child_spec({SSE.Supervisor.Listener, [[@tweet1, @tweet2], @disp_list]},
        id: @listener_sup
      ),
      Supervisor.child_spec({SSE.Process.Aggregator, @aggregator}, id: @aggregator),
      Supervisor.child_spec({SSE.Process.Sink, @sink}, id: @sink)
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end
