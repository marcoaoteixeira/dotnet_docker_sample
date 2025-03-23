# Get our SDK
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build

# Setting working directory to "src"
WORKDIR /src

# Copy all necessary files
COPY --link ["*.props", "."]
COPY --link ["src/Nameless.Docker.Core/", "Nameless.Docker.Core/"]
COPY --link ["src/Nameless.Docker.Web/", "Nameless.Docker.Web/"]

# Restore the application. Remember that we are at "src" working directory,
# so there is not need to specify "src" at the begging of the path.
RUN dotnet restore "Nameless.Docker.Web/Nameless.Docker.Web.csproj"

# Build the application
RUN dotnet build "Nameless.Docker.Web/Nameless.Docker.Web.csproj" -c Release -o /app/build

# Publish our application
FROM build AS publish
RUN dotnet publish "Nameless.Docker.Web/Nameless.Docker.Web.csproj" -c Release -o /app/publish

# Run our application
FROM mcr.microsoft.com/dotnet/aspnet:9.0

# Define some arguments
ARG HTTP_PORT=5080
ARG HTTPS_PORT=5443

# Set environment variables
ENV ASPNETCORE_ENVIRONMENT=Production
ENV ASPNETCORE_URLS=http://+:${HTTP_PORT};https://+:${HTTPS_PORT}

# Expose container ports
EXPOSE ${HTTP_PORT}
EXPOSE ${HTTPS_PORT}

# Let's set "app" as our working directory from here on.
WORKDIR /app

# To use HTTPS on our app, we need a certificate inside the container
# and define some Kestrel env variables:
# ASPNETCORE_Kestrel__Certificates__Default__Path
# ASPNETCORE_Kestrel__Certificates__Default__Password
# As a recommendation, these variables should be defined by the CI/CD
# when the application is deployed and not stored here, in the Dockerfile.
ENV ASPNETCORE_Kestrel__Certificates__Default__Path=./certs/cert.pfx
ENV ASPNETCORE_Kestrel__Certificates__Default__Password=my_super_secret_password

# Creates a directory where we should store the certificate
RUN mkdir -p /certs

# Copy the certificate to the created path
COPY ["certs/cert.pfx", "certs/"]

# Copy everything inside the "publish" folder (look into Publish layer)
# to our final directory, "app"
COPY --from=publish /app/publish .

ENTRYPOINT ["dotnet", "Nameless.Docker.Web.dll"]