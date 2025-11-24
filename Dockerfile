# --------------------------------------------------------------------------
# BASE STAGE: Sets up node user and production dependencies
# --------------------------------------------------------------------------
FROM node:18-alpine AS base

ENV NPM_CONFIG_STRICT=false

WORKDIR /app

# 1. Copy package files first
COPY package*.json ./

# 2. Install production dependencies
RUN npm ci --only=production

# 4. Copy application source code
COPY . .

EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD node -e "require('http').get('http://localhost:3000', (res) => { process.exit(res.statusCode === 200 ? 0 : 1) }).on('error', () => { process.exit(1)})"

# --------------------------------------------------------------------------
# DEVELOPMENT STAGE: Installs dev deps and uses the runtime Entrypoint fix
# --------------------------------------------------------------------------
FROM base AS development

# Install ALL dependencies.
RUN npm ci

# The final command to execute (executed by the entrypoint as user nodejs)
CMD [ "npm", "run", "dev" ]

# --------------------------------------------------------------------------
# PRODUCTION STAGE: Runs the final application
# --------------------------------------------------------------------------
FROM base AS production

# The base image is already set up to run as nodejs with production dependencies.
CMD [ "node", "start" ]