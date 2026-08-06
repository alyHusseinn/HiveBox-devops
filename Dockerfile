# --- Stage 1: Base & Dependencies ---
FROM node:22-alpine AS base
WORKDIR /usr/src/app
# Copy package manifests first to leverage Docker layer caching
COPY package*.json tsconfig.json  pnpm*.yaml ./
RUN corepack enable && corepack prepare pnpm@latest --activate

# --- Stage 2: Build TypeScript ---
FROM base AS builder
# Install all dependencies (including devDependencies like typescript)
# This only Run when the package.json | tsconfig changed -> that why we copy them first
RUN pnpm install --frozen-lockfile
COPY src ./src
# Compile TS to JS (typically outputs to a /dist or /build folder)
RUN pnpm run build

# --- Stage 3: Production Dependencies ---
FROM base AS production-deps
# Install ONLY production dependencies to minimize image size
RUN pnpm install --prod --frozen-lockfile

# --- Stage 4: Final Lean Runtime ---
FROM node:22-alpine AS runner
WORKDIR /usr/src/app

# Set production environment flags
ENV NODE_ENV=production

# Security: Avoid running the container as root
USER node

# Copy compiled JavaScript from builder and clean dependencies from production-deps
COPY --chown=node:node --from=production-deps /usr/src/app/node_modules ./node_modules
COPY --chown=node:node --from=builder /usr/src/app/dist ./dist
COPY --chown=node:node package.json ./

EXPOSE 3000

# Start using the compiled JavaScript file
CMD ["node", "dist/index.js"]
