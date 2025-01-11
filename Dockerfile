# Stage 1: Build the application
FROM node:20 AS builder

WORKDIR /usr/src/app

# Copy only package.json and package-lock.json to leverage Docker caching
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy the rest of the application source code
COPY . .

# Build the application
RUN npm run build:scss && npm run build

# Stage 2: Create a lightweight production image with only the necessary files
FROM node:20-alpine AS production

WORKDIR /usr/src/app

# Copy essential files and folders from the builder stage
COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY --from=builder /usr/src/app/.next ./.next
COPY --from=builder /usr/src/app/package*.json ./

# Copy the public folder if it exists
COPY --from=builder /usr/src/app/public ./public || true

# Install only production dependencies
RUN npm ci --omit=dev

# Set the application to run on port 3000
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
