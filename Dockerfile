# ---------- Stage 1: Angular Build ----------
FROM node:18-alpine AS build

WORKDIR /app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm ci

# Copy source and build
COPY . .
RUN npm run build -- --configuration production


# ---------- Stage 2: Nginx ----------
FROM nginx:alpine

# Copy Angular build output
COPY --from=build /app/dist/angular-jenkins-demo/browser /usr/share/nginx/html

# Copy nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
