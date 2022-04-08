FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.sln .
COPY src/*.csproj ./src/
RUN dotnet restore

# copy everything else and build app
COPY src/. ./src/
WORKDIR /source/src
RUN dotnet publish -c release -o /app --self-contained false --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:6.0-alpine AS base
WORKDIR /app
COPY --from=build /app ./

CMD ["./testdotnet6"]