[![CircleCI](https://circleci.com/gh/robertfalken/accountable.svg?style=svg)](https://circleci.com/gh/robertfalken/accountable)

# Accountable

An Elixir package to deal with a lot of the account related boilerplate such as creating users, authenticating, authorizing and such. All so you can get to the juicy parts faster, hacking on your domain logic.

My goal is to keep `Accountable` as modular as possible, so that you can get up and running in no time, and piece by piece replacing parts with your own implementations as your application grows more complicated.

## Installation

Accountable can be installed by adding `accountable` to your list of dependencies in `mix.exs`:

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

**Caveat:** For this to work (for now at least), you will need to have a `users` table in your database, with `email` and `password_hash` columns.

#### Config

First of all, you will need to tell Accountable what repo to use to fetch your users.

Since Accountable is using the fantastic [Guardian](https://github.com/ueberauth/guardian) for authentication, you also need to provide a Guardian secret. Throw this into your config:


```elixir
# config.ex
config :accountable, :ecto_repo, MyApp.Repo

config :accountable, Accountable.Guardian,
  issuer: "my-app",
  secret_key: "guardian-secret"
```

#### Router

Accountable comes with a router that handles some basic requests, and also a `Context` plug that will assign `current_user` for you. To enable all of it, just add these lines to your router:

```elixir
# router.ex
forward "/authentication", Accountable.Router
plug Accountable.Context # Checks the access token header and puts current_user in your conn.assigns
plug Accountable.Context, absinthe: Absinthe.Plug # Puts current_user in your Absinthe context
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

