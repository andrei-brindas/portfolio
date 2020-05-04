FROM node:alpine as build

WORKDIR '/app'

COPY . .

RUN npm install --silent
RUN npm run build

FROM nginx:1.17.10-alpine
COPY --from=build /app/build /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/conf.d

COPY  nginx/cert.crt /etc/ssl/
COPY  nginx/cert.key /etc/ssl/
COPY  nginx/fullchain.pem /etc/ssl/
COPY  nginx/privkey.pem /etc/ssl/
COPY  nginx/cert.pem /etc/ssl
COPY  nginx/chain.pem /etc/ssl

EXPOSE 80
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]

