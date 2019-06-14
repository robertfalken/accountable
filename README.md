# Accountable

An Elixir package to deal with a lot of the account related boilerplate such as creating users, authenticating, authorizing and such. All so you can get to the juicy parts faster, hacking on your domain logic.

My goal is to keep `Accountable` as modular as possible, so that you can get up and running in no time, and piece by piece replacing parts with your own implementations as your application grows more complicated.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `accountable` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:accountable, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/accountable](https://hexdocs.pm/accountable).

## Usage

### Quickstart guide

Accountable comes with a router that handles some basic requests, and also a `Context` plug that will assign `current_user` for you. To enable all of it, just add these lines to your `router.ex`.

```elixir
forward "/authentication", Accountable.Router
plug Accountable.Context
plug Accountable.Context, absinthe: Absinthe.Plug
```

The forward👆  will give you 2 endpoints.

- /authentication/authenticate
- /authentication/refrest

`/authentication/authenticate` accepts a JSON payload with `email` and `password`. If authentication is successful it will set an access token in a http-only cookie and return 204. If authentication is unsuccessful it will return 401.

```console
$ curl --request POST \
  --url http://localhost:4000/authentication/authenticate \
  --header 'content-type: application/json' \
  --data '{"email": "accountable@example.com", "password": "my secret password"}'
```


`/authentication/refresh` checks the access token in the cookie and either returns a fresh token in the http-cookie, or returns 401 for invalid or expired tokens.

