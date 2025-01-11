# Dockerfile
FROM node:16-slim AS builder

WORKDIR /app

# Copy both package.json and package-lock.json
COPY package*.json ./

# Use npm ci to install dependencies
RUN npm ci --legacy-peer-deps

# Copy the rest of the application code
COPY . .

# Build the application
RUN npm run build

# Use a smaller base image for the final stage
FROM node:16-slim AS runner

WORKDIR /app

# Copy the built files from the builder stage
COPY --from=builder /app .

# Expose the application port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
