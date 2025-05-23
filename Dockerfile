# Usamos SDK de .NET 9
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Instalamos Git
RUN apt-get update && apt-get install -y git

# Copiamos todo
COPY . .

# Inicializamos submódulos
RUN git submodule init && git submodule update --recursive

# Nos movemos a la carpeta correcta que contiene el .sln
WORKDIR /src

# Restauramos dependencias
RUN dotnet restore

# Publicamos la aplicación
RUN dotnet publish -c Release -o /app/publish

# Imagen final de ejecución (opcional, puedes usar solo 'build' en Heroku)
FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "AlmaDeMalta.Api.dll"]