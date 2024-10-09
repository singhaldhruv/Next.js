# Stage 1: Build the application
FROM node:14 AS builder

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build:scss
RUN npm run build

# Stage 2: Create a production image with only the necessary files
FROM node:14-alpine AS production

WORKDIR /usr/src/app

COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY --from=builder /usr/src/app/.next ./.next
COPY --from=builder /usr/src/app/package*.json ./

# Check if public folder exists and copy only if it does
RUN if [ -d /usr/src/app/public ]; then cp -r /usr/src/app/public ./public; fi

RUN npm install --only=production

EXPOSE 3000

CMD ["npm", "run", "start"]