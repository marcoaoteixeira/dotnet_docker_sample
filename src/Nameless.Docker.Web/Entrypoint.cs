using Nameless.Docker.Web.Components;

namespace Nameless.Docker.Web;

/// <summary>
/// Application Entrypoint Class
/// </summary>
public sealed class Entrypoint {
    /// <summary>
    /// Application Entrypoint method.
    /// </summary>
    /// <param name="args">Arguments</param>
    public static void Main(string[] args) {
        var builder = WebApplication.CreateBuilder(args);

        // Add services to the container.
        builder.Services
               .AddRazorComponents()
               .AddInteractiveServerComponents();

        if (builder.Environment.IsDevelopment()) {
            builder.Configuration.AddUserSecrets<Entrypoint>();
        }

        var app = builder.Build();

        // Configure the HTTP request pipeline.
        if (!app.Environment.IsDevelopment()) {
            app.UseExceptionHandler("/Error");
            // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
            app.UseHsts();
        }

        app.UseHttpsRedirection();

        app.UseAntiforgery();

        app.MapStaticAssets();
        app.MapRazorComponents<App>()
           .AddInteractiveServerRenderMode();

        app.Run();
    }
}