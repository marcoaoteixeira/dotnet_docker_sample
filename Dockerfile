# Get our SDK
FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:9.0 AS build

# Define layer arguments
ARG TARGETARCH # this argument is provided by Docker
ARG BUILD_CONFIG=Release

# Setting working directory to "src"
WORKDIR /src

# Copy all necessary files
COPY --link ["*.props", "."]
COPY --link ["src/Nameless.Docker.Core/", "Nameless.Docker.Core/"]
COPY --link ["src/Nameless.Docker.Web/", "Nameless.Docker.Web/"]

# Restore the main project. Remember that we are at "src" working directory,
# so there is not need to specify "src" at the begging of the path.
RUN dotnet restore "Nameless.Docker.Web/Nameless.Docker.Web.csproj" -a ${TARGETARCH}

# Publish our application
RUN dotnet publish "Nameless.Docker.Web/Nameless.Docker.Web.csproj" -c ${BUILD_CONFIG} -a ${TARGETARCH} --no-restore -o /app

# Run our application
FROM mcr.microsoft.com/dotnet/aspnet:9.0

# Expose container port
EXPOSE 5443

# Let's set "app" as our working directory from here on.
WORKDIR /app

# Copy everything inside the "publish" folder (look into Publish layer)
# to our final directory, "app"
COPY --from=build /app .

USER ${APP_UID}

# Start our application
ENTRYPOINT ["dotnet", "Nameless.Docker.Web.dll"]