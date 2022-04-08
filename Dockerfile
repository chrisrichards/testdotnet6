FROM mcr.microsoft.com/dotnet/aspnet:6.0-alpine AS base

RUN addgroup -S dotnet && adduser -S dotnet -G dotnet \
    && apk add --no-cache dumb-init

FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine AS build

ENV NODE_VERSION=16.13.1
RUN curl -fsSLO --compressed "https://unofficial-builds.nodejs.org/download/release/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64-musl.tar.xz"; \
        tar -xJf "node-v$NODE_VERSION-linux-x64-musl.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
          && ln -s /usr/local/bin/node /usr/local/bin/nodejs;

WORKDIR /app
RUN chown dotnet /app
COPY --chown=dotnet:dotnet-group --from=publish /app/publish .

USER dotnet
CMD ["dumb-init", "dotnet", "testdotnet6.dll"]