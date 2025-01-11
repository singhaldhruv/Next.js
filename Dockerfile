FROM node:16-slim AS builder

# Set working directory
WORKDIR /app

# Copy dependency files
COPY package*.json ./

# Install dependencies
RUN npm ci --legacy-peer-deps

# Copy source code
COPY . .

# Build the app (if applicable)
RUN npm run build

# Use a lighter image for production
FROM node:16-slim

# Set working directory
WORKDIR /app

# Copy build artifacts and dependencies
COPY --from=builder /app ./

# Expose the port the app runs on
EXPOSE 3000

# Start the app
CMD ["npm", "start"]
