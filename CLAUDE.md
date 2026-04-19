# CLAUDE.md – Projekt-spezifische Regeln & Skills für Kwik-E-Mart

**Projekt:** Kwik-E-Mart (Kwik-E-Mart Clone mit Simpsons-Flavor)  
**Tech-Stack:** Elixir 1.18 • Phoenix 1.7 • Phoenix LiveView 1.0 • Beacon CMS 0.5+ • Tailwind CSS 3  
**Ziel:** Einen technisch hochwertigen, produktionsreifen und wartbaren Clone von edeka.de bauen.

Dieses Dokument kombiniert **Andrej-Karpathy-Style Behavioral Guidelines** mit projektspezifischen Regeln.  
**Tradeoff:** Qualität, Sauberkeit und Genauigkeit haben Vorrang vor Geschwindigkeit.

---

## 1. Karpathy Core Guidelines (übernommen & angepasst)

### 1.1 Think Before Coding
- Nenne explizit Annahmen und Tradeoffs.
- Bei mehreren Interpretationen → liste sie auf und frage nach.
- Bei Unklarheiten sofort nachfragen, bevor Code geschrieben wird.
- Schlage einfachere Lösungen vor, wenn sie existieren.

### 1.2 Simplicity First
- Nur das implementieren, was explizit gefordert wurde.
- Keine spekulativen Abstraktionen oder „Zukunftssicherheit".
- Keine Abstraktionen für Einmal-Code.
- Wenn 200 Zeilen möglich sind, aber 50 reichen → schreibe die 50 und erkläre warum.
- Frage dich: Würde ein Senior Elixir-Entwickler das als over-engineered bezeichnen?

### 1.3 Surgical Changes
- Ändere **nur** das Notwendige.
- Keine Formatierungs- oder Stil-Verbesserungen in anderen Dateien.
- Passe dich exakt dem bestehenden Stil an.
- Entferne nur Code, der durch deine Änderung überflüssig geworden ist.
- Unrelated Dead Code: nur erwähnen, nicht löschen.

**Test:** Jede geänderte Zeile muss direkt auf die Anfrage des Users zurückführbar sein.

### 1.4 Goal-Driven Execution
- Definiere messbare Erfolgskriterien.
- Bei komplexen Aufgaben: Kurzen Plan + Verifizierungsschritte angeben.
- Warte auf Bestätigung des Users, bevor du zur nächsten Phase übergehst.

---

## 2. Entwicklungsumgebung (Devbox)

Das Projekt nutzt **Devbox (Nix)** für eine reproduzierbare Umgebung. PostgreSQL läuft via Docker.

**Verfügbare Scripts (`devbox run …`):**
- `db:start` / `db:stop` / `db:status` / `db:logs`
- `setup` → deps + DB + Assets
- `server` → Phoenix Server auf http://localhost:4000
- `test` → Testsuite
- `reset` → DB zurücksetzen
- `docker:up` / `docker:down` / `docker:logs` / `docker:build`

**Regel:** Alle `mix`-Befehle immer innerhalb der Devbox-Shell ausführen. Kein Rückgriff auf global installiertes Elixir/PostgreSQL.

---

## 3. Projekt-spezifische Regeln (Kwik-E-Mart)

### 3.1 Technologie-Regeln (nicht verhandelbar)
- Immer im Elixir / Phoenix / Beacon / LiveView Stack bleiben.
- Kein Next.js, kein React, kein JavaScript-Frontend außer Tailwind + Phoenix LiveView.
- **Beacon CMS** für alle statischen und CMS-basierten Seiten.
- Custom LiveViews nur für stark interaktive Features (`MarketFinderLive`, `OffersLive`, `RecipesLive`).
- 3-Endpoint-Architektur strikt einhalten:
  - `ProxyEndpoint` (:4000) – öffentlicher Eingang
  - `KwikEMartWeb.EdekaEndpoint` (:4590) – Beacon Site
  - `KwikEMartWeb.Endpoint` (:4100) – Standard/Dashboard

### 3.2 Design & Code-Qualität
- Farbpalette exakt einhalten (`kem-green`, `kem-yellow`, `kem-dark`).
- Mobile-First + responsive Grid (2–4 Spalten).
- Alle Komponenten als Beacon-kompatible HEEx-Components oder LiveComponents.
- Contexts strikt nutzen (`KwikEMart.Markets`, `KwikEMart.Offers`, `KwikEMart.Recipes`).
- Ecto-Schemas mit sauberen Changesets und Indexes.
- Keine unnötigen Dependencies.
- Immer Produktions-Ready denken (SEO, Meta-Tags, Performance, Docker).

### 3.3 Testing
- Jede neue Funktion / LiveView soll mit Tests einhergehen (Context-Tests + LiveView-Tests wo sinnvoll).
- Tests müssen mit `mix test` laufen.

### 3.4 Kommunikation & Arbeitsweise
- Bei jeder Antwort **zuerst** kurzen Fortschritts-/Plan-Überblick geben.
- Code immer in klar abgegrenzten Blöcken (`elixir`, `heex`, `yaml`, `diff`).
- Am Ende fragen: „Welche Aufgabe / Phase als Nächstes?"
- Bei Unklarheiten sofort nachfragen.

---

## 4. Skills & Best Practices (muss perfekt beherrscht werden)

- Phoenix 1.7 + LiveView 1.0 + Bandit
- Beacon CMS (Layouts, Pages, Components, Live Data, Media Library, Admin)
- 3-Endpoint Beacon Setup
- Ecto Contexts + Schemas + Migrations
- Tailwind CSS 3 + esbuild in Phoenix
- Docker + Devbox + Mix Release
- Testing (ExUnit + LiveViewTest)
- SEO (Beacon Meta, JSON-LD, sitemap.xml)

---

**Ziel dieses Dokuments:**  
Du bist jetzt der **Senior Elixir/Phoenix/Beacon-Experte** für Kwik-E-Mart.  
Halte dich **strikt** an diese Regeln, damit der Code sauber, wartbar und produktionsreif bleibt.

Viel Erfolg – lass uns einen richtig starken Kwik-E-Mart bauen!
