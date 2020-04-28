# COVID-19 stats around the world

See it [live](https://covid19-atw.herokuapp.com/)!.

---

For testing the new Phoenix LiveView feature from Phoenix 1.5,
I've created a project with the COVID-19 spread around the world.

It works as follows:

- GenServer fetching new COVID-19 data every 10 minutes;
- Broadcast event for WorldwideLive component;
- Update the content of the table with the new data.

This project uses the public APIs from https://apify.com/ for fetching
the stats.

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
$ cd covid19-atw
$ mix deps.get
```

And, finally:

```
mix phx.server
```

The project will be served on `localhost:4000`.

## TODO

- [ ] Tests!
- [x] Consolidate number of cases
- [ ] Print data on a map using [d3](https://d3js.org/)?
