# Etapa 1: Construcción
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /app

# Copiar la solución y los archivos de proyecto
COPY *.sln ./
COPY Api/AlmaDeMalta.Api/*.csproj ./Api/AlmaDeMalta.Api/
COPY Common/AlmaDeMalta.Common.Contracts/*.csproj ./Common/AlmaDeMalta.Common.Contracts/
COPY Common/AlmaDeMalta.Common.DatabaseConnection/*.csproj ./Common/AlmaDeMalta.Common.DatabaseConnection/
COPY Common/migrations/AlmaDeMalta.Migrations/*.csproj ./Common/migrations/AlmaDeMalta.Migrations/

# Restaurar dependencias
RUN dotnet restore

# Copiar el resto del código fuente
COPY . ./

# Publicar la aplicación desde la raíz del workspace
RUN dotnet publish "./Api/AlmaDeMalta.Api/AlmaDeMalta.Api.csproj" -c Release -o /out --no-restore

# Etapa 2: Ejecución
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app

# Copiar archivos publicados
COPY --from=build /out ./

# Configuración específica para Heroku
EXPOSE $PORT
ENV ASPNETCORE_URLS=http://+:$PORT

# Configurar la entrada del contenedor
ENTRYPOINT ["dotnet", "AlmaDeMalta.Api.dll"]