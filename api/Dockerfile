# --- STAGE 1: BUILDER ---
# Use a specific node version (Alpine is lighter)
FROM node:20-alpine AS builder

# Set the working directory inside the container
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
# Start fresh with a new, empty image
FROM node:20-alpine

# Set working directory
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
CMD ["npm", "run", "start:prod"]