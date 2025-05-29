# Etapa 1: Construir el frontend React
FROM node:16-alpine as frontend-builder

WORKDIR /app/frontend
COPY frontend/package.json frontend/package-lock.json ./
RUN npm install
COPY frontend .
RUN npm run build

# Etapa 2: Construir el backend Node.js
FROM node:16-alpine as backend-builder

WORKDIR /app/backend
COPY backend/package.json backend/package-lock.json ./
RUN npm install
COPY backend .

# Etapa 3: Imagen de producción final
FROM node:16-alpine

WORKDIR /app

# Instalar dependencias para MySQL y Nginx
RUN apk add --no-cache nginx mariadb-client

# Configurar Nginx
COPY frontend/nginx.conf /etc/nginx/nginx.conf

# Copiar frontend construido
COPY --from=frontend-builder /app/frontend/build /usr/share/nginx/html

# Copiar backend
COPY --from=backend-builder /app/backend /app/backend

# Instalar solo dependencias de producción para el backend
WORKDIR /app/backend
RUN npm install --only=production

# Variables de entorno
ENV NODE_ENV=production \
    PORT=5000 \
    DB_HOST=mysql \
    DB_PORT=3306 \
    DB_USER=root \
    DB_PASSWORD=root1 \
    DB_NAME=mern

# Exponer puertos
EXPOSE 80 5000

# Script de inicio
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

CMD ["/app/start.sh"]