defmodule Producer do
  def start_link do
    :gen_server.start_link(fn -> loop() end, [], name: __MODULE__)
  end

  def loop() do
    IO.puts("Enter message to publish: ")
    message = IO.gets()
    MessageBroker.publish(message)
    loop()
  end
end
