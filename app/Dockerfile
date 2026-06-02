FROM node:20-alpine

WORKDIR /usr/src/app

ENV NODE_ENV=production

COPY --chown=node:node package.json package-lock.json ./

RUN npm ci --omit=dev && npm cache clean --force

COPY --chown=node:node . .

USER node

EXPOSE 3000

CMD ["node", "app.js"]
