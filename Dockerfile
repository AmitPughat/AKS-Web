FROM microsoft/aspnetcore:2.0 AS base
WORKDIR /app
EXPOSE 92
ENV ASPNETCORE_URLS http://*:92

FROM microsoft/aspnetcore-build:2.0 AS build
WORKDIR /src
COPY *.sln ./
COPY AKS-Web/AKS-Web.csproj AKS-Web/
RUN dotnet restore
COPY . .
WORKDIR /src/AKS-Web
RUN dotnet build -c Release -o /app

FROM build AS publish
RUN dotnet publish -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "AKS-Web.dll", "--server.urls", "http://*:92"]
#ENTRYPOINT ["dotnet", "run", "--server.urls", "http://*:61241"]
