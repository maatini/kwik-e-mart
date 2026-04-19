# Kwik-E-Mart

![Elixir](https://img.shields.io/badge/Elixir-1.18-4B275F?style=for-the-badge&logo=elixir&logoColor=white)
![Phoenix](https://img.shields.io/badge/Phoenix-1.7-FD4F00?style=for-the-badge&logo=elixir&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Tailwind CSS](https://img.shields.io/badge/Tailwind_CSS-38B2AC?style=for-the-badge&logo=tailwind-css&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white)
![DevBox](https://img.shields.io/badge/DevBox-Nix-blue?style=for-the-badge)

<br/>
<div align="center"><img src="./docs/assets/github_banner.png" alt="Kwik-E-Mart Banner" width="100%" /></div>
<br/>

Ein produktionsreifer Clone von [edeka.de](https://www.edeka.de), gebaut mit **Elixir**, **Phoenix LiveView** und **Beacon CMS**.

---

## Inhalt

- [Überblick](#überblick)
- [Tech-Stack](#tech-stack)
- [Architektur](#architektur)
- [Voraussetzungen](#voraussetzungen)
- [Schnellstart (Devbox)](#schnellstart-devbox)
- [Schnellstart (Docker)](#schnellstart-docker)
- [Projektstruktur](#projektstruktur)
- [Contexts & Datenmodell](#contexts--datenmodell)
- [LiveViews](#liveviews)
- [Beacon CMS](#beacon-cms)
- [Design-System](#design-system)
- [Konfiguration](#konfiguration)
- [Tests](#tests)
- [Deployment](#deployment)

---

## Überblick

Kwik-E-Mart implementiert die zentralen Features von edeka.de:

| Feature | Implementierung |
|---|---|
| Startseite mit Hero-Banner & Angebots-Teasern | Beacon CMS Page |
| Wochenangebote mit Kategorie-Filter | `OffersLive` |
| Rezepte (saisonal, Kategorie, Tag-Filter) | `RecipesLive` |
| Marktsuche (Ort, PLZ, Geolocation) | `MarketFinderLive` |
| CMS-Verwaltung (Seiten, Layouts, Komponenten) | Beacon Live Admin |
| Responsive Design (Mobile First) | Tailwind CSS 3 |

---

## Tech-Stack

| Schicht | Technologie |
|---|---|
| Sprache | Elixir 1.18 (OTP 27) |
| Web-Framework | Phoenix 1.7 |
| Realtime UI | Phoenix LiveView 1.0 |
| CMS | Beacon 0.5 + Beacon Live Admin 0.4 |
| Datenbank | PostgreSQL 16 |
| ORM | Ecto 3 |
| CSS | Tailwind CSS 3 |
| JS-Bundler | esbuild |
| HTTP-Server | Bandit |
| E-Mail | Swoosh |
| Dev-Umgebung | Devbox (Nix) |
| Container | Docker + Docker Compose |

---

## Architektur

### Drei-Endpoint-Modell (Beacon-Anforderung)

```
Browser :4000
    └── ProxyEndpoint          # öffentlicher Eingang, leitet weiter
            ├── KwikEMartEndpoint :4590   # Beacon-Site "edeka"
            └── Endpoint :4100            # Phoenix-Standard (Dashboard etc.)
```

Beacon benötigt zwei separate Endpoints: einen internen für die CMS-Site und einen Proxy, der den Datenverkehr nach außen bündelt.

### Context-Architektur

```
KwikEMart.Markets   →  Market (PLZ, Koordinaten, Öffnungszeiten)
KwikEMart.Offers    →  Offer + Category (Preis, Gültigkeitszeitraum)
KwikEMart.Recipes   →  Recipe + Category (saisonal, Zutaten, Tags)
```

---

## Voraussetzungen

### Option A – Devbox (empfohlen)

- [Devbox](https://www.jetify.com/devbox/docs/installing_devbox/) installiert
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) läuft (für PostgreSQL)

### Option B – Manuell

- Elixir 1.18 + OTP 27
- Node.js 20
- PostgreSQL 16 (lokal oder via Docker)

---

## Schnellstart (Devbox)

```bash
# 1. Devbox-Shell starten (installiert Elixir, Node, etc. automatisch)
devbox shell

# 2. PostgreSQL via Docker starten
devbox run db:start

# 3. Dependencies installieren, DB anlegen, Assets bauen
devbox run setup

# 4. Server starten → http://localhost:4000
devbox run server
```

### Verfügbare Devbox-Scripts

| Script | Beschreibung |
|---|---|
| `devbox run db:start` | PostgreSQL-Container starten |
| `devbox run db:stop` | PostgreSQL-Container stoppen |
| `devbox run db:status` | Container-Status anzeigen |
| `devbox run db:logs` | PostgreSQL-Logs streamen |
| `devbox run setup` | `mix setup` (deps + DB + Assets) |
| `devbox run server` | Phoenix-Entwicklungsserver |
| `devbox run test` | Testsuite ausführen |
| `devbox run reset` | DB zurücksetzen (`mix ecto.reset`) |
| `devbox run docker:up` | App + DB vollständig in Docker |
| `devbox run docker:down` | Docker-Stack herunterfahren |
| `devbox run docker:build` | App-Image neu bauen |
| `devbox run docker:logs` | App-Logs streamen |

---

## Schnellstart (Docker)

Vollständiger Stack (App + Datenbank) in Docker:

```bash
# Starten
docker compose up -d

# Logs beobachten
docker compose logs -f app

# Stoppen
docker compose down
```

Die App ist unter `http://localhost:4000` erreichbar.

> **Hinweis:** PostgreSQL läuft intern auf Port 5432, ist aber auf dem Host unter **5433** erreichbar (vermeidet Konflikte mit lokalen Installationen).

---

## Projektstruktur

```
kwik-e-mart/                      # Repo-Root
├── kwik_e_mart/                   # Phoenix-Applikation
│   ├── assets/
│   │   ├── css/app.css            # Edeka-spezifische CSS-Komponenten
│   │   ├── js/app.js              # LiveView + Geolocation-Hook
│   │   └── tailwind.config.js     # Edeka-Farben, Fonts, Screens
│   ├── config/
│   │   ├── config.exs             # Basis-Konfiguration
│   │   ├── dev.exs                # Entwicklung (DATABASE_URL, Watcher)
│   │   ├── prod.exs               # Produktion
│   │   ├── runtime.exs            # Laufzeit-Env-Vars + Beacon-Site
│   │   └── test.exs               # Test-DB
│   ├── lib/
│   │   ├── kwik_e_mart/
│   │   │   ├── application.ex     # Supervision-Tree (3 Endpoints + Beacon)
│   │   │   ├── markets.ex         # Context: Marktsuche, Geolocation
│   │   │   ├── markets/market.ex  # Schema
│   │   │   ├── offers.ex          # Context: Angebote filtern
│   │   │   ├── offers/offer.ex    # Schema
│   │   │   ├── offers/category.ex # Schema (gemeinsam für Offers + Recipes)
│   │   │   ├── recipes.ex         # Context: Rezepte filtern
│   │   │   └── recipes/recipe.ex  # Schema
│   │   └── kwik_e_mart_web/
│   │       ├── live/
│   │       │   ├── market_finder_live.ex
│   │       │   ├── offers_live.ex
│   │       │   ├── recipes_live.ex
│   │       │   └── components/    # Header, Footer, OfferCard, RecipeTeaser
│   │       ├── endpoint.ex        # Phoenix-Standard-Endpoint (:4100)
│   │       ├── edeka_endpoint.ex  # Beacon-Endpoint (:4590)
│   │       ├── proxy_endpoint.ex  # Öffentlicher Proxy (:4000)
│   │       └── router.ex
│   ├── priv/
│   │   ├── repo/
│   │   │   ├── migrations/        # 5 Migrations (Beacon + Domains)
│   │   │   └── seeds.exs          # 5 Märkte, 20 Angebote, 10 Rezepte
│   │   └── static/
│   ├── test/
│   │   ├── kwik_e_mart/           # Context-Tests (Markets, Offers, Recipes)
│   │   └── kwik_e_mart_web/       # Controller-Tests
│   ├── Dockerfile                 # Multi-Stage (dev / build / runtime)
│   └── mix.exs
├── docker-compose.yml             # Dev-Stack
├── docker-compose.prod.yml        # Prod-Stack
├── devbox.json                    # Devbox-Umgebung
└── .gitignore
```

---

## Contexts & Datenmodell

### `KwikEMart.Markets`

```
markets
├── id, name, address, city, zip, region
├── latitude, longitude             # für Geolocation-Suche
├── phone, email, website
└── opening_hours (map)
```

Wichtige Funktionen:
- `search_markets/1` — sucht nach Name, PLZ, Stadt (mind. 2 Zeichen)
- `find_nearby_markets/3` — Haversine-Formel, Standard-Radius 25 km
- `list_markets_by_city/1`, `list_markets_by_zip/1`, `list_markets_by_region/1`

### `KwikEMart.Offers`

```
categories
├── id, name, slug, type ("offer" | "recipe"), icon

offers
├── id, title, description, original_price, sale_price
├── image_url, valid_from, valid_until
├── market_id (FK), category_id (FK)
└── featured (boolean)
```

Wichtige Funktionen:
- `list_current_offers/1` — nur Angebote im Gültigkeitszeitraum
- `list_featured_offers/0` — Hero-Teaser auf der Startseite
- `list_offers_by_market/2` — marktspezifische Angebote

### `KwikEMart.Recipes`

```
recipes
├── id, title, description, instructions
├── ingredients (string[]), tags (string[])
├── prep_time (Minuten), image_url
├── seasonal (boolean)
└── category_id (FK)
```

Wichtige Funktionen:
- `list_seasonal_recipes/0` — aktuelle Saisonrezepte
- `list_recipes/1` — mit Filtern: `category_id`, `seasonal`, `tag`
- `list_all_tags/0` — für Tag-Filter-UI

---

## LiveViews

### `/markt-waehlen` — `MarketFinderLive`

- Freitextsuche (Name, PLZ, Stadt)
- „Meinen Standort verwenden"-Button (Browser Geolocation API via JS-Hook)
- Auswahl speichert Markt in der Session

### `/angebote/live` — `OffersLive`

- Listet alle aktuell gültigen Angebote
- Kategorie-Filter via `push_patch` (ohne Seiten-Reload)
- Preisformatierung als `XX,XX €`

### `/rezepte/live` — `RecipesLive`

- Saisonal-Toggle
- Kategorie- und Tag-Filter (kombinierbar)
- Vorschau-Karte mit Bild, Titel, Zubereitungszeit

---

## Beacon CMS

Beacon verwaltet alle CMS-Seiten (`/`, `/angebote`, `/rezepte`, `/region` etc.).

### Admin-Zugang

```
http://localhost:4000/admin
```

Zugangsdaten werden über Umgebungsvariablen gesetzt (siehe [Konfiguration](#konfiguration)).

### Beacon-Konzepte im Projekt

| Konzept | Zweck |
|---|---|
| Site `:edeka` | CMS-Site-Identifier |
| Layouts | Basis-HTML mit Header/Footer |
| Pages | Einzelne CMS-Seiten (Startseite, Angebote, …) |
| Components | Wiederverwendbare HEEx-Snippets |
| Live Data | Datenbankdaten in Beacon-Seiten einbinden |

---

## Design-System

### Farben

| Name | Hex | Verwendung |
|---|---|---|
| `edeka-green` | `#00A651` | Primärfarbe, CTAs, Header |
| `edeka-yellow` | `#FFED00` | Akzente, Preisbadges |
| `edeka-dark` | `#1a1a1a` | Text, Footer |

### CSS-Komponenten (`app.css`)

- `.edeka-header` — Sticky Navigation
- `.offer-card` — Angebotskarte mit Hover-Effekt
- `.recipe-card` — Rezept-Teaser
- `.edeka-cta-primary` / `.edeka-cta-secondary` — Buttons
- `.edeka-badge` — Preis- und Saison-Badges

### Typografie

Inter (Google Fonts) als primäre Schriftart, via Tailwind `font-sans` konfiguriert.

---

## Konfiguration

Kopiere `.env.example` nach `.env` und passe die Werte an:

```bash
cp kwik_e_mart/.env.example kwik_e_mart/.env
```

| Variable | Beschreibung | Standard (Dev) |
|---|---|---|
| `DATABASE_URL` | PostgreSQL-Verbindungs-URL | `postgres://postgres:postgres@localhost:5433/kwik_e_mart_dev` |
| `SECRET_KEY_BASE` | Phoenix Session-Secret (64+ Zeichen) | — |
| `ADMIN_USERNAME` | Beacon Admin Benutzername | `admin` |
| `ADMIN_PASSWORD` | Beacon Admin Passwort | — |
| `PHX_HOST` | Hostname für Produktion | `localhost` |
| `PORT` | HTTP-Port | `4000` |

Secret generieren:
```bash
mix phx.gen.secret
```

---

## Tests

```bash
# Via Devbox
devbox run test

# Direkt (in devbox shell)
cd kwik_e_mart && mix test

# Mit Coverage
mix test --cover
```

### Testabdeckung

| Modul | Tests |
|---|---|
| `KwikEMart.MarketsTest` | Suche, Geolocation, CRUD |
| `KwikEMart.OffersTest` | Filter, Datumslogik, Preisvalidierung |
| `KwikEMart.RecipesTest` | Saisonal, Tags, Kategorie-Filter |

---

## Deployment

### Docker (empfohlen)

```bash
# Prod-Stack starten (erfordert ausgefüllte .env)
docker compose -f docker-compose.prod.yml up -d

# Migrationen ausführen
docker compose -f docker-compose.prod.yml exec app bin/kwik_e_mart eval "KwikEMart.Release.migrate()"
```

### Mix Release (manuell)

```bash
MIX_ENV=prod mix deps.get --only prod
MIX_ENV=prod mix assets.deploy
MIX_ENV=prod mix release

# Starten
_build/prod/rel/kwik_e_mart/bin/kwik_e_mart start
```

### Fly.io

```bash
fly launch --name kwik-e-mart
fly secrets set SECRET_KEY_BASE=$(mix phx.gen.secret)
fly secrets set DATABASE_URL=<connection-string>
fly secrets set ADMIN_PASSWORD=<sicheres-passwort>
fly deploy
```
