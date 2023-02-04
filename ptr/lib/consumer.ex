defmodule Consumer do
  def start_link do
    :gen_server.start_link(fn -> loop() end, [], name: __MODULE__)
  end

  def loop() do
    MessageBroker.subscribe
    receive do
      {:message, message} ->
        IO.puts("Received message: #{message}")
        loop()
    end
  end
end
