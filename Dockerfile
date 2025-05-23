# Etapa 1: Construir la aplicación
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY . ./
#COPY AlmaDeMalta.Api/*.csproj ./AlmaDeMalta.Api/
RUN dotnet restore
#COPY AlmaDeMalta.Api/. ./AlmaDeMalta.Api/
WORKDIR /src/Api/AlmaDeMalta.Api
RUN dotnet publish -c Release -o /app/publish

# Etapa 2: Imagen final de ejecución
FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app
COPY --from=build /app/publish .
EXPOSE 80
ENTRYPOINT ["dotnet", "AlmaDeMalta.Api.dll"]