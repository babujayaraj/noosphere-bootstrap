FROM node:18-alpine

# Create app directory
WORKDIR /usr/src/app

# Add non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy package manifests first to leverage layer caching
COPY app/package.json app/package-lock.json* ./

# Install dependencies
RUN npm ci --only=production

# Copy app source
COPY app/src ./src

# Ensure logs written to stdout
ENV NODE_ENV=production

# Change ownership
RUN chown -R appuser:appgroup /usr/src/app
USER appuser

EXPOSE 3000
CMD ["node", "src/index.js"]
