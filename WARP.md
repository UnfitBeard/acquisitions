# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.
``

## Commands

- Dev server
  - npm run dev
  - Production-style start (no watcher): node src/index.js
- Linting/formatting
  - Lint: npm run lint
  - Lint (fix): npm run lint:fix
  - Format: npm run format
  - Format check: npm run format:check
- Database (Drizzle ORM)
  - Generate SQL from models: npm run db:generate
  - Apply migrations: npm run db:migrate
  - Visualize DB/schema: npm run db:studio
- Tests
  - Currently not configured (npm test exits with an error). Single-test runs are not applicable until a test runner is added.

## Architecture overview

- Runtime and entrypoints
  - ESM Node.js app ("type": "module"). Entry flow: src/index.js → src/server.js (starts HTTP server) → src/app.js (Express app setup).
- Web layer (Express)
  - Middleware: helmet, cors, express.json, urlencoded, cookie-parser, morgan (HTTP logs piped to winston).
  - Routes mounted in src/app.js. Example prefix: /api/auth (see src/routes/auth.routes.js).
- Controllers/services/validation
  - Controllers orchestrate validation and service calls (e.g., src/controllers/auth.controller.js uses zod schemas in src/validations/ and utilities in src/utils/).
  - Services (e.g., src/services/auth.service.js) contain business logic and DB access.
- Data and persistence
  - Drizzle ORM with Neon HTTP driver. Configuration in src/config/database.js and drizzle.config.js (models under src/models/\*.js).
  - Example model: users table in src/models/user.model.js using drizzle-orm/pg-core.
- Logging
  - Winston logger (src/config/logger.js). Writes to logs/error.log and logs/combined.log; console logging enabled when NODE_ENV !== 'production'. HTTP request logging via morgan -> winston.
- Module path aliases
  - package.json imports maps enable aliases like #config/_, #controllers/_, #routes/_, #services/_, #utils/_, #validations/_, #models/\*.

## Environment

- Required/used variables (set in .env or environment):
  - DATABASE_URL (Drizzle/Neon connection)
  - JWT_SECRET (JWT signing; a default is used if absent, but set your own for non-dev)
  - PORT (optional; defaults to 3000)
  - LOG_LEVEL (optional; logger level)

## Notes for future agents

- Drizzle migrations target the schema defined under src/models via drizzle.config.js. Ensure DATABASE_URL is set before running generate/migrate/studio.
- Aliased imports (e.g., import logger from '#config/logger.js') rely on package.json imports; keep paths consistent with those mappings.
