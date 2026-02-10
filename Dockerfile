# ---- deps stage ----
FROM node:20-alpine AS deps

WORKDIR /usr/src/app
COPY app/package.json app/package-lock.json ./
RUN npm ci --only=production


# ---- runtime stage ----
FROM node:20-alpine

WORKDIR /usr/src/app

# Create non-root user with fixed numeric UID (avoid collisions with 1000)
RUN addgroup -S appgroup \
 && adduser  -S -u 10001 -G appgroup appuser

COPY --from=deps /usr/src/app/node_modules ./node_modules
COPY app/src ./src

RUN chown -R appuser:appgroup /usr/src/app

USER 10001

EXPOSE 3000
CMD ["node", "src/index.js"]
