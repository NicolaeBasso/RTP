defmodule Schemas.Tweets do
  use Ecto.Schema

  schema "tweets" do
    field(:sentiment, :decimal)
    field(:engagement, :decimal)
    field(:favorite_count, :integer)
    field(:retweet_count, :integer)
    field(:text, :string)
    field(:created_at, :string)
    belongs_to(:user, Schemas.User)
  end
end
