# Use a imagem base do SDK .NET 8.0
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Defina o diretório de trabalho
WORKDIR /app

# Copie o arquivo .csproj e restaure as dependências
COPY *.csproj ./
RUN dotnet restore

# Copie o restante dos arquivos e compile a aplicação
COPY . ./
RUN dotnet publish -c Release -o out

# Use a imagem base do runtime .NET 8.0 para a imagem final
FROM mcr.microsoft.com/dotnet/aspnet:8.0

# Defina o diretório de trabalho
WORKDIR /app

# Copie os arquivos compilados da imagem de build
COPY --from=build /app/out .

# Exponha a porta que a aplicação usará
EXPOSE 5070

# Defina o comando para iniciar a aplicação
ENTRYPOINT ["dotnet", "testApi.dll"]
