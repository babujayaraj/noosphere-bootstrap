# ---- deps stage ----
FROM node:20-alpine AS deps
WORKDIR /usr/src/app
COPY app/package.json app/package-lock.json ./
RUN npm ci --only=production

# ---- runtime stage ----
FROM node:20-alpine
WORKDIR /usr/src/app

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=deps /usr/src/app/node_modules ./node_modules
COPY app/src ./src

RUN chown -R appuser:appgroup /usr/src/app
USER appuser

EXPOSE 3000
CMD ["node", "src/index.js"]