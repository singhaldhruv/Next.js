# Use a slim version of Node.js
FROM node:14-slim AS builder

# Set working directory
WORKDIR /app

# Copy only package files to leverage Docker's caching
COPY package*.json ./

# Install dependencies
RUN npm ci --legacy-peer-deps

# Copy application files
COPY . .

# Build the application
RUN npm run build

# Use a lightweight production image
FROM node:14-alpine AS production

WORKDIR /app

COPY --from=builder /app /app

# Install production dependencies only
RUN npm ci --only=production

# Expose port and run
EXPOSE 3000
CMD ["npm", "start"]
