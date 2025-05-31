# Etapa 1: construir el frontend si existe
FROM node:18 AS builder

WORKDIR /app

COPY . .

# Instala dependencias
RUN npm install

# Compila React si existe (no es obligatorio)
RUN npm run build || echo "No hay frontend para compilar"

# Etapa 2: entorno de producción
FROM node:18

WORKDIR /app

# Copia todo desde la etapa de construcción
COPY --from=builder /app /app

# Expone el puerto del backend (Express)
EXPOSE 4000

# Comando para arrancar la app
CMD ["npm", "start"]