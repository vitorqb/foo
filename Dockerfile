FROM node:carbon AS build
WORKDIR /qrt_client
COPY package*.json ./
#RUN JOBS=max npm install --production --unsafe-perm
RUN npm install
COPY . .
#ENV NODE_ENV=production
RUN npm run build

FROM nginx:alpine AS production
WORKDIR /usr/share/nginx/html
COPY --from=build /qrt_client/dist .
COPY --from=build /qrt_client/config/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]