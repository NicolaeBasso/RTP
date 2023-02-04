defmodule Message do
  @moduledoc """
  Documentation for `Message`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Message.hello()
      :world

  """
  def hello do
    :world
  end
end

defmodule Message.Broker do
  def start_link do
    spawn(__MODULE__, :loop, [[], []])
  end

  def loop(subscribers, messages) do
    receive do
      {:subscribe, subscriber} ->
        loop([subscriber | subscribers], messages)
      {:publish, message} ->
        loop(subscribers, [message | messages])
        Enum.each subscribers, fn(subscriber) -> send(subscriber, message) end
    end
  end
end

defmodule Message.Subscriber do
  def start_link(broker) do
    spawn(__MODULE__, :loop, [broker, []])
  end

  def loop(broker, messages) do
    receive do
      message ->
        IO.puts("Received message: #{inspect message}")
        send broker, {:publish, message}
        loop(broker, [message | messages])
    end
  end
end

defmodule Message.Publisher do
  def publish(message_broker, msg) do
    send(message_broker, {:publish, msg})
  end
end
