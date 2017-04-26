# SunshinesBattleacademy

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Install on Linux

Set environment to prod by `export MIX_ENV=prod`.

Set port by `export PORT=80`.

Copy `config/prod.secret.exs.example` to `config/prod.secret.exs`.

Run `mix phx.gen.secret` and copy the code to the `secret_key_base` in `config/prod.secret.exs`.

Modify `url: [host: "example.com", port: 80]` to point to your host `example.com` in `config/prod.exs`.

Compile phoenix by `mix compile`.

Start phoenix by `mix phx.server`.

Use your favorite service manager.

## Docker image generator

```
mix archive.install https://git.io/edib-0.10.0.ez
mix release.init
mix edib
```

## Install CockroachDB

```
# Start cockroakdb database
docker run --rm -p 26257:26257 -p 8080:8080 cockroachdb/cockroach:beta-20170420 start --insecure
# Create the database
mix ecto.create 

```
## Inspired by

* https://github.com/OgarProject/Ogar
* https://github.com/huytd/agar.io-clone

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
