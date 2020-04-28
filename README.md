# COVID-19's outbreak worldwide

For testing the new Phoenix LiveView features,
I've created a project that shows data from the COVID-19's outbreak.

This project uses the public APIs available on https://apify.com/ for gathering
data.

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
- [ ] Print data on a map using [d3](https://d3js.org/)?
