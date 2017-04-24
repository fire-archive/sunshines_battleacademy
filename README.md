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

Set port by `export PORT=800`.

Copy `config/prod.secret.exs.example` to `config/prod.secret.exs`.

Copy mix phx.gen.secret to the `secret_key_base`.

Compile phoneix by `mix compile`.

Start phoenix by `mix phx.server`.

Use your favorite service manager.

## Inspired by

* https://github.com/OgarProject/Ogar
* https://github.com/huytd/agar.io-clone

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
