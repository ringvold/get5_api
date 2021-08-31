# Get5Api

This will be a web panel for the [splewis/get5](https://github.com/splewis/get5) CSGO sourcemod plugin.

Get5Api aims to replace parts of [splewis/get5-web](https://github.com/splewis/get5-web) and [PhlexPlexico/G5API](https://github.com/PhlexPlexico/G5API) and 
implement new feature as needs arise.

This application is written in Elixir with Phoenix, Graphql and Postresql, with 
the frontend written in [Elm](https://elm-lang.org/).

# Getting started 
  

## Frontend

The project uses [yarn V1](https://classic.yarnpkg.com/lang/en/) (for now) to manage npm packages and [elm-tooling](https://elm-tooling.github.io/elm-tooling-cli/) for managing 
Elm-related tooling. [Elm-spa](https://www.elm-spa.dev/) is used to simplify 
SPA setup with Elm.

Setup:
1. `yarn install`
2. `yarn elm-tooling install`
2. `yarn elm-spa dev`

### Learn more

  * Official Elm language guide: https://guide.elm-lang.org/
  * elm-spa: https://www.elm-spa.dev/
  * elm-tooling: https://elm-tooling.github.io/elm-tooling-cli/

## Backend

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

### Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
