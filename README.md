# Real Time Programming 
  _Streaming Twitter sentiment score analyzer_
# EventsourceEx

An Elixir EventSource (Server-Sent Events) client

[![EventsourceEx on Hex](https://img.shields.io/hexpm/v/eventsource_ex?style=flat-square)](https://hex.pm/packages/eventsource_ex)

## Installation

  Add eventsource_ex to your list of dependencies in `mix.exs`:

        def deps do
          [{:eventsource_ex, "~> x.x.x"}]
        end

 ## Links
  https://github.com/cwc/eventsource_ex       

## Usage
    iex(1)> {:ok, pid} = EventsourceEx.new("https://url.com/stream", stream_to: self)
     {:ok, pid} = EventsourceEx.new("http://localhost:4000", stream_to: self)
    {:ok, #PID<0.150.0>}
    iex(2)> flush
    %EventsourceEx.Message{data: "1", event: "message", id: nil}
    %EventsourceEx.Message{data: "2", event: "message", id: nil}
    %EventsourceEx.Message{data: "3", event: "message", id: nil}
    :ok
  ## About
  This application receives 2 streams of tweets from Twitter API. Every tweet is being analyzed by the sentiment score analyzer and tweet text in pair with its score is stored in database After that the tweet is being published to the client by the __tweeter__ topic.

  ## Launch (docker)
  - Run docker containers with `docker-compose up -d` in root project path;

  ## Utils
  ### Stop containers & do not preserve volumes from previous runs
  - docker-compose down -v
  ### Update images and rebuild containers
  - docker-compose up -d --force-recreate --build


