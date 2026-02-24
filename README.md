# MyFeed

MyFeed is a self-hosted personal feed/blog engine from the AngularJS + CoffeeScript era. It lets one user publish short posts (with links/media previews) and aggregates posts from followed domains into a timeline.

## What this project does

At a high level, MyFeed provides:

- **Personal posting**: create text/link posts that are stored in local PouchDB.
- **Link enrichment**: URLs in a post are scraped for metadata and rendered as attachments.
- **Single-user auth**: one configured username/password, token-based API auth.
- **Timeline aggregation**: periodically fetches content from followed domains via either:
  - another MyFeed instance (`/api/feed` JSON), or
  - RSS feeds.
- **Server-rendered pages** (`jade`) + **AngularJS frontend** for interactive posting/login/settings.
- **RSS output** for your own profile posts (`/rss`).

## Tech stack (legacy)

- **Backend**: Node.js, Express, CoffeeScript.
- **Frontend**: AngularJS 1.x, CoffeeScript, Jade templates, Stylus.
- **Storage**: local PouchDB files (`public/_pouchdb`).
- **Auth**: passport-local + passport-token-auth with JWT.

> This is an older codebase. Expect legacy package versions and APIs.

## Repository layout

- `public/app.coffee`: main server, API routes, auth, feed pages, RSS route.
- `public/app_modules/`: backend helpers (cron polling, feed parsing, metadata helpers).
- `public/coffee/modules/Controller/`: AngularJS controllers.
- `public/coffee/modules/services/`: AngularJS shared services (`LoginService`, `PostsService`).
- `public/views/`: Jade templates.
- `public/stylus/`: Stylus styles.
- `public/index.js`: CoffeeScript bootstrap entrypoint.

## Runtime behavior

### Publishing flow

1. User logs in from `/login`.
2. Frontend stores token in `localStorage`.
3. Creating a post calls `/api/create` with token.
4. Server builds a slug-like `_id`, stores post in PouchDB, and returns JSON.

### Link scraping flow

- While composing a post, URLs in text are detected client-side.
- Frontend calls `/api/scrapethis` for each URL.
- Server delegates scraping to `myfeed-scrape` and returns attachment metadata.

### Following / timeline flow

- Followed domains are stored as `follow` docs.
- A cron-style interval (`app_modules/cronjob.coffee`) fetches each followed source.
- Parser tries MyFeed JSON first, then RSS fallback.
- Retrieved items are saved as `foreign_post` or `rss_post` docs.
- `/timeline` + `/api/feed` with `type=timeline` merges local + remote content.

## Environment configuration

MyFeed reads a `.env` file from `public/.env`.

Required keys:

- `SERVERPORT`
- `DOMAIN_URL` (recommended without trailing slash)
- `USER_EMAIL`
- `USER_PASSWORD`
- `USER_NAME`
- `SECRET`
- `USE` (optional; set `DEVELOPMENT` to enable livereload behavior)

Example:

```env
SERVERPORT=8000
DOMAIN_URL="http://localhost:8000"
USER_EMAIL="you@example.com"
USER_PASSWORD="change-me"
USER_NAME="Your Name"
SECRET="very-secret-string"
USE="DEVELOPMENT"
```

## Local development (best-effort)

Because dependencies are old, you may need an older Node version (for example via `nvm`) if install/runtime fails on modern Node.

```bash
cd public
npm install
./dev_install.sh   # optional helper to generate .env
npm start
```

App URLs:

- Feed: `http://localhost:<SERVERPORT>/`
- Timeline: `http://localhost:<SERVERPORT>/timeline`
- Login: `http://localhost:<SERVERPORT>/login`
- RSS: `http://localhost:<SERVERPORT>/rss`

## API quick reference

- `POST /api/login` -> get token.
- `POST /api/create` (token) -> create post.
- `POST /api/delete` (token) -> delete post.
- `POST /api/feed` -> fetch posts (profile or timeline).
- `POST /api/scrapethis` (token) -> scrape metadata for a URL.
- `POST /api/follow` (token) -> follow a domain.
- `GET /api/followed` -> list followed domains.
- `POST /api/remove_follow` (token) -> remove followed domain.
- `POST /api/settings/bgimage` (token) -> save background image data URI.

## Notes for maintainers

- Authentication is **single-user** and credentials come from `.env`.
- PouchDB design docs are created at startup.
- Remote feed polling runs continuously while the process is alive.
- Data is file-based in `public/_pouchdb`; back this directory up.

## Historical context

Original author metadata in `package.json` points to Robert Agthe, and the app was designed as a personal-domain “Facebook-like” stream/blog hybrid.
