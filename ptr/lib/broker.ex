defmodule MessageBroker do
  use GenServer

  def start_link(url) do
    GenServer.start_link(__MODULE__, [url], name: __MODULE__)
  end

  def init([url]) do
    :timer.send_interval(5000, :fetch, [url])
    {:ok, %{subscriptions: []}}
  end

  def handle_call(:subscribe, _from, %{subscriptions: subscriptions} = state) do
    {:reply, :ok, %{state | subscriptions: subscriptions ++ [_from]}}
  end

  def handle_cast({:publish, message}, %{subscriptions: subscriptions} = state) do
    Enum.each subscriptions, fn(subscriber) -> send(subscriber, {:message, message}) end
    {:noreply, %{state | message: message}}
  end

  def fetch(url) do
    case :httpc.request(:get, url, [], [], [], [], stream: true) do
      {:ok, %{status_code: 200, body: body}} ->
        :hackney.stream_body(body, &handle_data/1)
      {:ok, %{status_code: status_code}} ->
        IO.puts("Received #{status_code} status code")
      {:error, reason} ->
        IO.puts("Error fetching data: #{reason}")
    end
  end

  def handle_data(data) do
    publish(data)
  end

  defp publish(data) do
    {:noreply, GenServer.call(__MODULE__, {:publish, data})}
  end
end
