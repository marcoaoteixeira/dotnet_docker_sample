# Get our SDK
FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:9.0 AS build

# Get image host architecture.
ARG TARGETARCH

# Setting working directory to "src"
WORKDIR /src

# We are using global build properties file, let's copy them.
COPY ["*.props", "."]

# Now, copy the project files
COPY ["Nameless.Docker.Core/*.csproj", "Nameless.Docker.Core/"]
COPY ["Nameless.Docker.Web/*.csproj", "Nameless.Docker.Web/"]

# Restore the application. Remember that we are at "src" working directory,
# so there is not need to specify "src" at the begging of the path.
RUN dotnet restore "Nameless.Docker.Web/Nameless.Docker.Web.csproj"

# Copy all source code
COPY . .

# Build the application
RUN dotnet build "Nameless.Docker.Web/Nameless.Docker.Web.csproj" -c Release -o /app/build

# Publish our application
FROM build AS publish
RUN dotnet publish "Nameless.Docker.Web/Nameless.Docker.Web.csproj" -c Release -o /app/publish

# Run our application
FROM mcr.microsoft.com/dotnet/aspnet:9.0

# Set environment variables
ENV ASPNETCORE_ENVIRONMENT=Production
ENV ASPNETCORE_APPLICATIONNAME="Blazor Weather App"
ENV ASPNETCORE_HTTPS_PORTS=5443

# Expose container ports
EXPOSE 5443

# Let's set "app" as our working directory from here on.
WORKDIR /app

# Copy everything inside the "publish" folder (look into Publish layer)
# to our final directory, "app"
COPY --from=publish /app/publish .

ENTRYPOINT ["dotnet", "Nameless.Docker.Web.dll"]