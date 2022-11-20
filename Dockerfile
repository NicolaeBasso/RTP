FROM elixir:1.14
WORKDIR /app
COPY . .
RUN mix local.rebar --force && \
    mix local.hex --force
RUN mix deps.get
CMD mix run --no-halt
# CMD iex -S mix