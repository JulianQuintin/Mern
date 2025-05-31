# Etapa 1: Construir el cliente (React)
FROM node:18-alpine as client-builder

WORKDIR /app/client
COPY client/package.json client/package-lock.json ./
RUN npm install
COPY client .
RUN npm run build

# Etapa 2: Construir el servidor (Node.js)
FROM node:18-alpine as server-builder

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
COPY . .

# Etapa 3: Imagen de producción final
FROM node:18-alpine

WORKDIR /app

# Instalar dependencias necesarias
RUN apk add --no-cache nginx

# Configurar Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Copiar cliente construido
COPY --from=client-builder /app/client /usr/share/nginx/html

# Copiar servidor
COPY --from=server-builder /app /app

# Instalar solo dependencias de producción para el servidor
WORKDIR /app/server
RUN npm install --only=production

# Variables de entorno (pueden ser sobrescritas en docker-compose)
ENV NODE_ENV=production \
    PORT=5000 \
    DB_HOST=mysql \
    DB_PORT=3306 \
    DB_USER=root \
    DB_PASSWORD=root1 \
    DB_NAME=mern

# Exponer puertos (Nginx en 80, Node en 5000)
EXPOSE 80 5000

# Script de inicio
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

CMD ["/app/start.sh"]