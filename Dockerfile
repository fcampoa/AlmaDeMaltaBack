# Etapa 1: Construcción
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Instalar Git para submódulos
RUN apt-get update && apt-get install -y git

# Copiar todo el código
COPY . .

# Inicializar y actualizar submódulos
RUN git submodule init && git submodule update --recursive

# Restaurar dependencias y publicar
WORKDIR /src/AlmaDeMaltaBack
RUN dotnet restore
RUN dotnet publish -c Release -o /app/publish