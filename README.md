# Get5Api

***Project status: Pre alpha aka a lot of stuff is not working yet***

This will be a web panel for the [splewis/get5](https://github.com/splewis/get5) CSGO sourcemod plugin.

Get5Api aims to replace parts of [splewis/get5-web] and [PhlexPlexico/G5API] 
and implement new feature as needs arise.

This application is written in Elixir with Phoenix, Graphql and Postresql, with 
the frontend written in [Elm](https://elm-lang.org/).

# Plan (short version)

1. [ ] Make the basics it work
2. [ ] Make it pretty
3. [ ] Make more stuff work
4. [ ] ???
5. [ ] World domination

# Why

[Splewis/get5-web] is a proof-of-concept web panel for get5 and was a 
starting point for a lot of similar projects. It is now old and unmaintained
so a fresh start is needed.

This project is inspired by [PhlexPlexico/G5API] but with the wish to use other 
technologies it made sense to create a seperate project. I prefere functional 
progamming and side projects should be fun so I chose some of my favourite 
languages, Elixir and Elm. 😄


[PhlexPlexico/G5API]: https://github.com/PhlexPlexico/G5API
[splewis/get5-web]: https://github.com/splewis/get5-web


# Gettings started

For now setup is a bit more involved but as the project matures there will be 
docker images ready to be used in production. 

The easies way to get started is to build and run with [docker-compose]:

### Dev mode

1. Clone and enter repo: `git clone https://github.com/ringvold/get5_api.git && cd get5_api`
2. Start app and db: `docker-compose up`
3. On first start only: Run db migrations and add test data with `docker-compose run web mix ecto.setup`
3. Go to http://localhost:4000

Note: In dev mode frontend is continously build and served by elm-spa on a 
seperate port. The backend will link to this when you to 
http://localhost:4000.
In production mode the frontend is pre-build and served by the backend.

### Production mode

The project is not yet ready for production so there will be no detailed guide 
for now, but for the brave ones, here is the short of it:

1. Have a Postresql database with a connection url ready
2. Build with the default Dockerfile. Ex `docker build . -t your-name/get5_api`
3. Run image with environment variables DATABASE_URL and SECRET_KEY_BASE set

Check out [fly.io](https://fly.io) for running the application and database. This repo 
already has the dockerfile and phoenix changes done so start from 
[Install Flyctl and Login](https://fly.io/docs/getting-started/elixir/#install-flyctl-and-login) in the 
[Build, Deploy and Run an Elixir Application](https://fly.io/docs/getting-started/elixir/) docs.

[docker-compose]: https://docs.docker.com/compose/

# Contribution

Help is always welcome! 🙌  
Create a fork of this repo, make your changes, and submit a PR. 
Before starting any work it might be good to open an issue and explain what you 
need and want to implement to be sure we find the best solution and that it is 
in alignment with the projects plans. 😄

## Backend

### Docker only

1. Start the database and server with `docker-compose up`. This might take a while. 
Enjoy some quiet time while downloading and compiling. 😄
2. Migrate and seed database with `docker-compose run web mix ecto.setup`
3. Go to http://localhost:4000
4. Make some changes and check how it looks!


### Backend natively and db in docker

To start your Phoenix server (requires elixir installed locally):

  * Install dependencies with `mix deps.get`
  * Start database server with `docker-compose up`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`
  * Make your desired changes

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

This also starts a dev server for the frontend.

### Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

## Frontend

The project uses [yarn V1](https://classic.yarnpkg.com/lang/en/) (for now) to manage npm packages and 
[elm-tooling](https://elm-tooling.github.io/elm-tooling-cli/) for managing Elm-related tooling. [Elm-spa](https://www.elm-spa.dev/) is used to 
simplify SPA setup with Elm.

As the backend dev server also starts the frontend dev server you might not 
need to do these steps but this is how you run the frontend seperately:

1. `yarn install`
2. `yarn setup`
3. `yarn start`
4. Go to http://localhost:1234

### Learn more

  * Official Elm language guide: https://guide.elm-lang.org/
  * elm-spa: https://www.elm-spa.dev/
  * elm-tooling: https://elm-tooling.github.io/elm-tooling-cli/
