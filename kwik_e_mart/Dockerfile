# syntax=docker/dockerfile:1

ARG ELIXIR_VERSION=1.18.1
ARG OTP_VERSION=27.2.4
ARG ALPINE_VERSION=3.21.3
ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-alpine-${ALPINE_VERSION}"
ARG RUNNER_IMAGE="alpine:${ALPINE_VERSION}"

# ── Dev stage: für docker-compose dev ────────────────────────────────────────
FROM ${BUILDER_IMAGE} AS dev

RUN apk add --no-cache \
  build-base \
  git \
  nodejs \
  npm \
  inotify-tools

WORKDIR /app

RUN mix local.hex --force && mix local.rebar --force

COPY mix.exs mix.lock ./
ENV MIX_ENV=dev

RUN mix deps.get

CMD ["mix", "phx.server"]

# ── Build stage: Deps kompilieren ─────────────────────────────────────────────
FROM ${BUILDER_IMAGE} AS build

RUN apk add --no-cache build-base git nodejs npm

WORKDIR /app

RUN mix local.hex --force && mix local.rebar --force

ENV MIX_ENV=prod

COPY mix.exs mix.lock ./
RUN mix deps.get --only prod && mix deps.compile

# Assets bauen
COPY config config/
COPY priv priv/
COPY assets assets/

RUN mix assets.deploy

# App kompilieren
COPY lib lib/
RUN mix compile

# Release erstellen
RUN mix release

# ── Runtime stage: minimales Image ───────────────────────────────────────────
FROM ${RUNNER_IMAGE} AS runtime

RUN apk add --no-cache \
  libstdc++ \
  openssl \
  ncurses-libs \
  bash \
  && addgroup -S app \
  && adduser -S app -G app

WORKDIR /app

COPY --from=build --chown=app:app /app/_build/prod/rel/kwik_e_mart ./

USER app

EXPOSE 4000

ENV PHX_SERVER=true \
  HOME=/app

CMD ["/app/bin/kwik_e_mart", "start"]
