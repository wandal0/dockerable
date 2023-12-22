FROM mcr.microsoft.com/dotnet/runtime:3.1-nanoserver-1809 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:3.1-nanoserver-1809 AS build
ARG configuration=Release
WORKDIR /src
COPY ["dockerable.csproj", "./"]
RUN dotnet restore "dockerable.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "dockerable.csproj" -c $configuration -o /app/build

FROM build AS publish
ARG configuration=Release
RUN dotnet publish "dockerable.csproj" -c $configuration -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "dockerable.dll"]
