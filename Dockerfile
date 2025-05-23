# Etapa 1: Construcción
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /app

# Copiar la solución y los archivos de proyecto
COPY *.sln .
COPY ./Api/AlmaDeMalta.Api/*.csproj ./Api/AlmaDeMalta.Api/
COPY ./Common/AlmaDeMalta.Common.Contracts/*.csproj ./Common/AlmaDeMalta.Common.Contracts/
COPY ./Common/AlmaDeMalta.Common.DatabaseConnection/*.csproj ./Common/AlmaDeMalta.Common.DatabaseConnection/
COPY ./Common/migrations/AlmaDeMalta.Migrations/*.csproj ./Common/migrations/AlmaDeMalta.Migrations/
RUN dotnet restore

# Copiar el resto del código fuente y compilar
COPY . .
WORKDIR /app/Api/AlmaDeMalta.Api
RUN dotnet publish -c Release -o /out

# Etapa 2: Ejecución
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app
COPY --from=build /out .

# Configurar la entrada del contenedor
ENTRYPOINT ["dotnet", "AlmaDeMalta.Api.dll"]