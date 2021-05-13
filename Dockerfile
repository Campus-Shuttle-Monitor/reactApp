FROM node:lts-alpine as builder

WORKDIR /app

COPY package.json .
COPY package-lock.json .
RUN npm ci

COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=builder /app/build /usr/share/nginx/html
COPY prod.nginx template.conf
ENV PORT 80
EXPOSE 80
CMD sh -c "envsubst '\$PORT' < template.conf > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"
