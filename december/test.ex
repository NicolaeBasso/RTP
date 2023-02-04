# https://dev.to/finiam/simulations-with-elixir-and-the-actor-model-2lmf
# https://samuelmullen.com/articles/elixir-processes-send-and-receive/

defmodule Solution.Broker do
  def start_link do
    spawn(__MODULE__, :loop, [])
  end

  def loop do
    receive do
      {:subscribe, sender} ->
        subscribers = [sender | subscribers]
        loop
      {:publish, msg} ->
        for subscriber <- subscribers do
          send(subscriber, msg)
        end
        loop
    end
  end
end

defmodule Solution.Subscriber do
  def start_link do
    spawn(__MODULE__, :loop, [])
  end

  def loop do
    receive do
      msg ->
        IO.puts("Received message: #{inspect(msg)}")
        send(self(), :print_list)
        loop
      :print_list ->
        IO.puts("Message List: #{inspect(messages)}")
        loop
    end
  end
end

defmodule Solution.Publisher do
  def publish(message_broker, msg) do
    send(message_broker, {:publish, msg})
  end
end
