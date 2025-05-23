
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Instalar Git para poder clonar submódulos
RUN apt-get update && apt-get install -y git

# Copiar todo el código
COPY . .
RUN git submodule init && git submodule update

# Restaurar y publicar
WORKDIR /src/AlmaDeMaltaBack
RUN dotnet restore
RUN dotnet publish -c Release -o /app/publish
