# mern/Dockerfile

# Usa una imagen oficial de Node.js
FROM node:18-alpine

# Directorio de trabajo en el contenedor
WORKDIR /usr/src/app

# Copia package.json y package-lock.json para instalar dependencias
COPY package*.json ./

# Instala las dependencias
RUN npm install

# Copia el resto del código del backend
COPY . .

# Puerto en el que corre el backend (ajusta según tu configuración)
EXPOSE 4000