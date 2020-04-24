# COVID-19 stats around the world

For testing the new Phoenix LiveView feature from Phoenix 1.5,
I've created a project with the COVID-19 stats data around the world.

It works as follows:

- GenServer fetching new COVID-19 data every five minutes;
- Broadcast event for PageLive component;
- Update the content of the table with the new data.

This project uses the public APIs from https://apify.com/ for fetching
the stats.

It doesn't use database! Everything is inserted on [ets](http://erlang.org/doc/man/ets.html).

## Prerequisites
```
Erlang 20+
Elixir 1.6+
Node.js 5+
```
## Installing

### Erlang & Elixir

Both can be installed using [asdf](https://github.com/asdf-vm/asdf).
After installing them, run:

```
$ mix local.hex
```
After installing both Erlang and Elixir and cloning the project, run the following:
```
$ cd covid19
$ mix deps.get
```

And, finally:

```
mix phx.server
```

The project will be served on `localhost:4000`.


## Debugging the GenServer

You can debug the `Covid19.Server` module using [the sys module]( https://hexdocs.pm/elixir/GenServer.html#module-debugging-with-the-sys-module).

## TODO

- [ ] Tests!
- [ ] Consolidate number of cases
- [ ] Fetch data from a given country
- [ ] Print data on a map using [d3](https://d3js.org/)?
