FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build-env
WORKDIR /app

# Copia la solución y los archivos de proyecto
COPY *.sln ./
COPY **/*.csproj ./
COPY Directory.Build.props* ./
COPY Directory.Packages.props* ./

# Restaura las dependencias
RUN dotnet restore

# Copia todo el código fuente
COPY . ./

# Publica el proyecto específico (ajusta la ruta según tu estructura)
RUN dotnet publish "./Api/AlmaDeMalta.Api/AlmaDeMalta.Api.csproj" -c Release -o out --no-restore

# Usa la imagen runtime más ligera para ejecutar la aplicación
FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app

# Copia los archivos publicados desde la etapa anterior
COPY --from=build-env /app/out .

# Expone el puerto (ajusta según tu aplicación)
EXPOSE 8080

# Establece la variable de entorno para el puerto
ENV ASPNETCORE_URLS=http://+:8080

# Define el comando de entrada
ENTRYPOINT ["dotnet", "AlmaDeMalta.Api.dll"]