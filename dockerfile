# Usar la imagen base de PHP 8.2 con FPM
FROM php:8.2-fpm

# Instalar dependencias necesarias para PHP y herramientas de desarrollo
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    libzip-dev \
    gnupg \
    build-essential \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Instalar Node.js y npm desde NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && apt-get install -y nodejs

# Verificar instalación de Node.js y npm
RUN node --version && npm --version

# Instalar Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Configurar el directorio de trabajo
WORKDIR /var/www

# Copiar archivos de package.json antes del resto del proyecto
# Esto permite aprovechar la caché de Docker
COPY package*.json ./

# Instalar dependencias de npm
RUN npm install

# Copiar el resto del proyecto
COPY . .

# Compilar los assets para producción
RUN npm run build

# Dar permisos adecuados
RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 /var/www

# Exponer el puerto 9000
EXPOSE 9000

# Comando por defecto
CMD ["php-fpm"]
