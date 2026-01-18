# --- STAGE 1: BUILDER ---
# Use a specific node version (Alpine is lighter)
FROM node:20-alpine AS builder

# Create/Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json first
# This allows Docker to cache the dependency installation layer
COPY package*.json ./

# Install ALL dependencies (including devDependencies like TypeScript)
# 'npm ci' is faster and more reliable than 'npm install' for CI/CD
RUN npm ci

# Copy the rest of the application source code
COPY . .

# Build the application (transpile TS to JS in /dist folder)
RUN npm run build

# Remove development dependencies to keep the image small
# We only need dependencies defined in 'dependencies', not 'devDependencies'
RUN npm prune --production

# --- STAGE 2: PRODUCTION RUNNER ---
# This starts "Stage 2" (Production).
# The 'FROM' command discards everything from the previous stage and starts a fresh, empty container.
# We must redefine 'WORKDIR /app' because this is a brand new environment where that folder doesn't exist yet.
# Using 'COPY --from=builder', we pull ONLY the necessary artifacts (dist folder, node_modules)
# from the first stage, leaving behind heavy tools (TypeScript, source code) to keep the image small and secure.
FROM node:20-alpine

# Create/Set the working directory inside the container
WORKDIR /app

# Set environment to production (optimizes performance)
ENV NODE_ENV production

# Copy built assets and production modules from the 'builder' stage
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./

# Expose the application port (documentation only)
EXPOSE 8000

# Security: Run the app as a non-root user ('node' user comes with the image)
USER node

# Start the application
# Using "npm", "run", "start:prod" is also valid, but
# is less efficient because it spawns an extra shell process.
# Using "sh", "-c" so that '&&' operator can be used.
# First we do the migration, and it executes successfully (&&),
# meaning the DB is ready, then start the application. So if migration fails,
# the app won't start (which is desired). That's why DB migration was moved here
# from the api-deploy workflow SSH bash script.
# Using 'exec' before 'node dist/main.js' replaces the shell with the node process,
# ensuring proper signal handling (e.g., for graceful shutdowns).
CMD ["sh", "-c", "npm run db:migration:run:prod && exec node dist/main.js"]