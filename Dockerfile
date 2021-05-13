FROM node:lts-alpine as builder

WORKDIR /app

COPY package.json .
COPY package-lock.json .
RUN npm ci

COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=builder /app/build /usr/share/nginx/html
COPY prod.nginx /etc/nginx/conf.d/default.conf
