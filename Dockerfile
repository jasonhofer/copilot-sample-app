FROM node:12-alpine AS build

WORKDIR /app

COPY . .

# Building the project requires devDependencies.
RUN npm ci
RUN npm run build

# The production server does not require devDependencies.
RUN rm -rf node_modules
RUN npm ci --production


FROM node:12-alpine

ENV PORT=3000
ENV NODE_ENV=production

WORKDIR /app

COPY --from=build /app/__sapper__/build   __sapper__/build
COPY --from=build /app/node_modules       node_modules
COPY --from=build /app/static             static

EXPOSE 3000

CMD [ "node", "__sapper__/build" ]
