Para instrumentar o código com métricas do Prometheus, você pode usar o pacote [Prometheus-net](https://github.com/prometheus-net/prometheus-net) para .NET. Ele permite expor métricas para serem coletadas pelo Prometheus diretamente da sua aplicação. Vou guiar os passos para adicionar a instrumentação no seu projeto.

### Passos para instrumentar o código com Prometheus:

1. **Instalar o pacote Prometheus**:
   Adicione o pacote `prometheus-net.AspNetCore` ao seu projeto utilizando o NuGet:
   ```bash
   dotnet add package prometheus-net.AspNetCore
   ```

2. **Configurar o middleware do Prometheus**:
   Você pode configurar o middleware no arquivo `Program.cs` para expor métricas. Isso adicionará um endpoint que o Prometheus pode usar para coletar métricas.

   Modifique o código para incluir a configuração do Prometheus. No seu caso, isso ficaria assim:

   ```csharp
   using Prometheus;

   var builder = WebApplication.CreateBuilder(args);

   // Adicione serviços aqui

   var app = builder.Build();

   // Middleware de monitoramento Prometheus
   app.UseHttpMetrics();

   // Expor métricas na rota /metrics
   app.UseEndpoints(endpoints =>
   {
       endpoints.MapMetrics(); // Rota de métricas Prometheus
   });

   app.UseHttpsRedirection();
   app.UseAuthentication();
   app.UseAuthorization();

   app.MapControllers();
   app.Run();
   ```

3. **Adicionar métricas personalizadas**:
   Se quiser adicionar métricas específicas, como contadores ou histogramas para medir operações importantes, adicione isso diretamente ao seu código onde necessário. Por exemplo, para contar quantas vezes um endpoint específico foi chamado:

   ```csharp
   using Prometheus;

   var processCounter = Metrics.CreateCounter("myapp_process_operations_total", "Contador de operações de processo.");

   app.MapGet("/minha-rota", () =>
   {
       processCounter.Inc(); // Incrementar contador
       return "Operação concluída!";
   });
   ```

4. **Configurar coleta de métricas HTTP**:
   O método `app.UseHttpMetrics()` automaticamente coleta métricas HTTP, como a quantidade de requisições, latência e códigos de resposta, o que é útil para monitorar a performance dos seus endpoints.

### Considerações finais:
- **Endpoint de métricas**: O Prometheus fará scraping das métricas acessando o endpoint `/metrics` na sua aplicação.
- **Métricas adicionais**: Além das métricas HTTP padrão, você pode adicionar mais métricas específicas do seu sistema, como tempos de processamento de uma requisição ou contagem de falhas.

Com essas configurações, sua aplicação estará preparada para expor métricas que podem ser coletadas e monitoradas via Prometheus.
