# Get5Api

***Project status: Pre alpha aka a lot of stuff is not working yet***

This will be a web panel for the [splewis/get5](https://splewis.github.io/get5) CSGO sourcemod plugin.

Get5Api aims to replace parts of [splewis/get5-web] and [PhlexPlexico/G5API]/[PhlexPlexico/G5V] 
and implement new features as needs arise. It is actually not much of an API at 
the moment so the name is a bit misleading for now. The focus is on getting a 
solid base functionality down first through the web app and then focus on the 
API. There will be a GraphQL-based API further down the road for chat bots 
and other use cases.

This application is written with [Phoenix](https://www.phoenixframework.org/) and PostgreSQL.

## Plan (short version)

1. [ ] Make the basics it work
2. [ ] Make it pretty
3. [ ] Make more stuff work
4. [ ] ???
5. [ ] World domination

## Why

[Splewis/get5-web] was a proof-of-concept web panel for get5 and was a 
starting point for a lot of similar projects. It is now old and unmaintained
so a fresh start is needed.

This project is inspired by [PhlexPlexico/G5API] but with the wish to use other 
technologies it made sense to create a seperate project. I prefer functional 
progamming and Elixir has a great web framework in Phoenix. Using this project 
to get familiar with LiveView. 😄

[splewis/get5-web]: https://github.com/splewis/get5-web
[PhlexPlexico/G5API]: https://github.com/PhlexPlexico/G5API
[PhlexPlexico/G5V]: https://github.com/PhlexPlexico/G5V


## Getting started

For now setup is a bit more involved but as the project matures there will be 
docker images ready to be used in production. 

The easies way to get started is to build and run with [docker-compose]:

### Dev mode

1. Clone and enter repo: `git clone https://github.com/ringvold/get5_api.git && cd get5_api`
2. Start app and db: `docker-compose up`
3. On first start only: Run db migrations and add test data with `docker-compose run web mix ecto.setup`
3. Go to http://localhost:4000

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


## Contribution

Help is always welcome! 🙌  
Create a fork of this repo, make your changes, and submit a PR. 
Before starting any work it might be good to open an issue and explain what you 
need and want to implement to be sure we find the best solution and that it is 
in alignment with the projects plans. 😄


### All in docker

Run both app and database (and csgo server) in docker.

1. Start the database and server with `docker-compose up`. This might take a while. 
Enjoy some quiet time while downloading and compiling. 😄
2. Migrate and seed database with `docker-compose run web mix ecto.setup`
3. Go to http://localhost:4000
4. Make some changes and check how it looks!

If you also wish to run a CSGO server configured with Get5 you can uncomment
the csgo service in `docker-compose.yml`. ***Note:** this image does not work on 
M1/Apple Silicon and the server needs to be serves somewhere else.*
Check out the repo for that image on more information about how it works: https://github.com/ringvold/csgo


### Elixir natively and db in docker

To start your Phoenix server (requires elixir installed locally, see 
"Installing Elixir and Erlang with asdf"):

  * Install dependencies with `mix deps.get`
  * Start database server with `docker-compose up`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`
  * Make your desired changes

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.


### Installing Elixir and Erlang with asdf

Using the docker image is the easiest way to get started, but installing Elixir 
locally on you machine can also be beneficial.

Follow the steps outlined below:

```
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.2

# The following steps are for bash. If you’re using something else, do the
# equivalent for your shell.
echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bashrc
echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc # optional
source ~/.bashrc
# for zsh based systems run the following
echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.zshrc
echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.zshrc
source ~/.zshrc

asdf plugin-add erlang
asdf plugin-add elixir

asdf install elixir 1.14.2-otp-25
asdf install erlang 25.1.2

# Set the installed versions av default
asdf global erlang 25.1.2
asdf global elixir 1.14.2-otp-25

mix local.hex
mix local.rebar
```

## Learn more about Phoenix

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

