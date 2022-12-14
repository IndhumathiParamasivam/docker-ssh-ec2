FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
RUN pwd
RUN ls -la
WORKDIR /App
RUN ls -la

# Copy everything
COPY . ./

# Restore as distinct layers
RUN dotnet restore
# Build and publish a release
RUN dotnet build -c release --no-restore -o out
RUN ls -la
RUN ls -la out
# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /App
COPY --from=build-env /App/out .
ENTRYPOINT ["dotnet", "helloworld.dll"]