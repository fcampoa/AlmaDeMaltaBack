# Etapa 1: Construcción
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /app

# # Copiar la solución y los archivos de proyecto
# COPY *.sln ./
# COPY ./Api/AlmaDeMalta.Api/AlmaDeMalta.Api.csproj ./Api/AlmaDeMalta.Api/
# COPY ./Common/AlmaDeMalta.Common.Contracts/AlmaDeMalta.Common.Contracts.csproj ./Common/AlmaDeMalta.Common.Contracts/
# COPY ./Common/AlmaDeMalta.Common.DatabaseConnection/AlmaDeMalta.Common.DatabaseConnection.csproj ./Common/AlmaDeMalta.Common.DatabaseConnection/
# COPY ./Common/migrations/AlmaDeMalta.Migrations/AlmaDeMalta.Migrations.csproj ./Common/migrations/AlmaDeMalta.Migrations/


COPY . ./

RUN echo "=== Contenido del directorio raíz ===" && ls -la
RUN echo "=== Estructura de directorios ===" && find . -type d -name "*" | head -20

# Buscar todos los archivos .csproj
RUN find . -name "*.csproj"

# Buscar todos los archivos .sln
RUN find . -name "*.sln"

# Ver contenido de directorios específicos
RUN ls -la ./Api/ || echo "Directorio Api/ no existe"
RUN ls -la ./Common/ || echo "Directorio Common/ no existe"

# Verificar si archivos específicos existen
RUN test -f "./Api/AlmaDeMalta.Api/AlmaDeMalta.Api.csproj" && echo "Archivo existe" || echo "Archivo NO existe"

RUN dotnet restore
# RUN ls -la
# RUN ls -la Api/
# RUN ls -la Api/AlmaDeMalta.Api/
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