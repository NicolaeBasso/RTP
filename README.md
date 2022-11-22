## Real Time Programming
Receive, process & re-stream chosen topic messages to subscribed clients

### Useful elixir cmds:
mix new ptr --module Broker
mix deps.get
mix
iex
iex -S mix

iex(1)> 
{:ok, pid} = EventsourceEx.new("https://url.com/stream", stream_to: self)
{:ok, #PID<0.150.0>}

{:ok, pid} = EventsourceEx.new("localhost:4000/tweets/1", stream_to: self)
flush

%EventsourceEx.Message{data: "1", event: "message", id: nil}
%EventsourceEx.Message{data: "2", event: "message", id: nil}
%EventsourceEx.Message{data: "3", event: "message", id: nil}
:ok

### Useful docker cmds:
Detached:
docker-compose up -d --build

Non-detached:
docker-compose up --build

Delete all containers using the following command:
docker rm -f $(docker ps -a -q)