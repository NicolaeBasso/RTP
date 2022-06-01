defmodule EventsourceExTest do
  use ExUnit.Case

  import Mox

  setup :set_mox_from_context

  test "follows events" do
    EventsourceExTest.HTTPoisonMock
    |> expect(:get!, fn url, _headers, options ->
      assert url == "https//localhost:4000"
      target = options[:stream_to]

      [
        ":ok\n\n",
        "event: message\n",
        "data: 1\n\n",
        "event: message\n",
        "data: 2\n\n"
      ]
      |> Enum.map(&send(target, %{chunk: &1}))
    end)

    EventsourceEx.new("https//localhost:4000",
      stream_to: self(),
      adapter: EventsourceExTest.HTTPoisonMock
    )

    assert_receive(%EventsourceEx.Message{data: "1", event: "message"})
    assert_receive(%EventsourceEx.Message{data: "2", event: "message"})

    verify!()
  end
end
