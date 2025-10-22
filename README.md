# Acquisitions API

A minimal Express (ESM) service with authentication, PostgreSQL via Drizzle ORM (Neon HTTP), structured logging, and request validation.

## Contents

- Overview
- Quick start
- Commands
- Architecture
- API reference (auth + health)
- Database & migrations
- Troubleshooting

## Overview

- Runtime: Node.js (type: module)
- Web: Express with helmet, cors, cookie-parser, morgan → winston
- DB: Drizzle ORM + Neon HTTP driver
- Validation: zod
- Logging: winston (files + console in non-production)

## Quick start

1. Install dependencies

```bash path=null start=null
npm install
```

2. Configure environment

```dotenv path=null start=null
# Required
DATABASE_URL=postgres://<user>:<password>@<host>/<db>
JWT_SECRET=replace-with-a-secure-secret

# Optional
PORT=3000
LOG_LEVEL=info
NODE_ENV=development
```

3. Run the app

```bash path=null start=null
# Dev (watch)
npm run dev

# Production-style (no watcher)
node src/index.js
```

- Default base URL: http://localhost:3000

## Commands

- Lint: `npm run lint`
- Lint (fix): `npm run lint:fix`
- Format: `npm run format`
- Format check: `npm run format:check`
- Drizzle generate SQL: `npm run db:generate`
- Drizzle migrate: `npm run db:migrate`
- Drizzle studio: `npm run db:studio`

Tests are not configured (npm test exits with an error).

## Architecture

- Entry flow: `src/index.js` → `src/server.js` (starts HTTP server) → `src/app.js` (Express app/middleware/routes)
- Routes: mounted in `src/app.js` (e.g., `/api/auth`)
- Controllers: `src/controllers/*.js` orchestrate validation and services
- Services: `src/services/*.js` implement business logic and DB access
- Validation: `src/validations/*.js` (zod schemas)
- Models: `src/models/*.js` (Drizzle schema)
- Config: `src/config/*` (database, logger)
- Utils: `src/utils/*` (cookies, jwt, formatting)
- Logging: winston writes to `logs/error.log` and `logs/combined.log`; console logging when `NODE_ENV !== 'production'`
- Module aliases (from `package.json#imports`): `#config/*`, `#controllers/*`, `#routes/*`, `#services/*`, `#utils/*`, `#validations/*`, `#models/*`

### Directory sketch

```text path=null start=null
src/
  app.js            # Express app/middleware
  server.js         # HTTP server bootstrap
  routes/           # Route modules
  controllers/      # Request handlers
  services/         # Business logic + DB calls
  validations/      # zod schemas
  models/           # Drizzle table definitions
  config/           # logger, database
  utils/            # cookies, jwt, format
```

## API reference

Base URL: `http://localhost:${PORT || 3000}`

- Health
  - GET `/health` → `{ status, timestamp, uptime }`

- Root
  - GET `/` → Hello text
  - GET `/api` → API status text

- Auth (JSON bodies)
  - POST `/api/auth/sign-up`
    - Body: `{ name, email, password, role? }`
    - Sets `token` httpOnly cookie on success
  - POST `/api/auth/sign-in`
    - Body: `{ email, password }`
    - Sets `token` httpOnly cookie on success
  - POST `/api/auth/sign-out`
    - Clears `token` cookie

Example requests

```bash path=null start=null
# Sign up
curl -i -X POST http://localhost:3000/api/auth/sign-up \
  -H 'Content-Type: application/json' \
  -d '{"name":"Alice","email":"alice@example.com","password":"secret123"}'

# Sign in
curl -i -X POST http://localhost:3000/api/auth/sign-in \
  -H 'Content-Type: application/json' \
  -d '{"email":"alice@example.com","password":"secret123"}'

# Sign out
curl -i -X POST http://localhost:3000/api/auth/sign-out
```

Cookie behavior

- Cookies are `httpOnly`, `sameSite=strict`, `secure` only in production by default (`src/utils/cookies.js`).
- For browsers making cross-origin requests, enable CORS with credentials and configure the client to send credentials.

## Database & migrations

- Schema location: `src/models/*.js`
- Drizzle config: `drizzle.config.js`

Common flows

```bash path=null start=null
# Generate SQL from current models
npm run db:generate

# Apply migrations to the database
npm run db:migrate

# Visualize DB/schema
npm run db:studio
```

## Security

- Arcjet config: `./src/config/arcjet.js`
- MiddleWare config: `./src/app.js` as `app.use(securityMiddleware)`

Arcjet behavior

- **Rate Limiting** set using `slidingWindow` Algorithm, `mode: 'LIVE'`, `max: 5` for maximum of 5 requests per minute.
- **Protects against bots** using `isBot()`
- **Protects against Other attacks** using `isShield()`
-

## Troubleshooting

- Cookies not appearing in browser
  - Ensure client sends credentials and server CORS is configured for credentials + allowed origin
  - `sameSite=strict` may block cross-site usage; adjust if needed
- `DATABASE_URL` missing or invalid → set a valid Neon/Postgres URL
- Logs
  - Check `logs/error.log` and `logs/combined.log` for details

## License

ISC
