ARG ELIXIR_VERSION=1.15.7
ARG OTP_VERSION=26.2.1
ARG ALPINE_VERSION=3.18.4

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-alpine-${ALPINE_VERSION}"
# ARG RUNNER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-alpine-${ALPINE_VERSION}"
ARG RUNNER_IMAGE="alpine:${ALPINE_VERSION}"


###
### Fist Stage - Building the Release
###
FROM ${BUILDER_IMAGE} AS build

# install build dependencies
# git needed for getting ueberauth_steam
RUN apk add --no-cache build-base git

# prepare build dir
WORKDIR /app

# extend hex timeout
ENV HEX_HTTP_TIMEOUT=20

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV as prod
ENV MIX_ENV=prod
ENV SECRET_KEY_BASE=nokey
ENV DATABASE_URL=$DATABASE_URL

# Copy over the mix.exs and mix.lock files to load the dependencies. If those
# files don't change, then we don't keep re-fetching and rebuilding the deps.
COPY mix.exs mix.lock ./
COPY config config

RUN mix deps.get --only prod && \
    mix deps.compile

COPY priv priv
COPY assets assets

# NOTE: If using TailwindCSS, it uses a special "purge" step and that requires
# the code in `lib` to see what is being used. Uncomment that here before
# running the npm deploy script if that's the case.
COPY lib lib

# build assets
RUN mix assets.deploy
RUN mix phx.digest

# copy source here if not using TailwindCSS
COPY lib lib

# compile and build release
COPY rel rel
RUN mix do compile, release

###
### Second Stage - Setup the Runtime Environment
###

# prepare release docker image
FROM ${RUNNER_IMAGE} AS app
RUN apk add --no-cache libstdc++ openssl ncurses-libs

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/get5_api ./

ENV HOME=/app
ENV MIX_ENV=prod
ENV SECRET_KEY_BASE=nokey
ENV PORT=4000

CMD ["bin/get5_api", "start"]
