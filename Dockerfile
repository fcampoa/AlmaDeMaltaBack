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
WORKDIR /src/AlmaDeMaltaBack/Api/AlmaDeMalta.Api
RUN dotnet publish -c Release -o /app/publish

# Etapa 2: Imagen final de ejecución
FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "AlmaDeMalta.Api.dll"]