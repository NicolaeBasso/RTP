defmodule Schemas.User do
  use Ecto.Schema

  schema "user" do
    field(:username, :string)
    field(:followers_count, :integer)
    field(:friends_count, :integer)
    field(:statuses_count, :integer)
    field(:listed_count, :integer)

    field(:created_at, :integer)
  end
end
