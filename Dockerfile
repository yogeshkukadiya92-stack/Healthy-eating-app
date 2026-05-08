FROM node:20-alpine

WORKDIR /app

# Only copy what we need to run the preview server
COPY package.json ./package.json
COPY preview ./preview

ENV NODE_ENV=production

EXPOSE 3000

# Railway provides PORT; default to 3000
CMD ["sh", "-c", "PORT=${PORT:-3000} node preview/server.js"]

