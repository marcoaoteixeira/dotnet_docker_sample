# Sample Weather App using Docker

This sample is just the default template for Blazor Weather application but
I'm using Docker to run/deploy it. Think of it as a step-by-step on How To
Create a Dockerfile for Your ASP.Net Core Application.

## Starting

Instructions below will show your the way to get things working.

### Pre-requirements

First, let us create our HTTPS certificate. You'll need to create this certificate to
enable HTTPS on your application, if you don't have one. For the sake of this example,
we'll create a development certificate using the following command:

```powershell
dotnet dev-certs https -ep "$env:USERPROFILE\.aspnet\https\Nameless.Docker.Web.pfx" -p <YOUR_PASSWORD_HERE> --trust
```
The command above will create the certificate inside the folder _%USERPROFILE%\\.aspnet\https_ and
secure it using the specified password. If you have already a certificate, just change the `.env` file
inside the repository folder with the necessary information.

Now, for the "User Secrets". From the root folder:

```powershell
dotnet user-secrets init -p ./src/Nameless.Docker.Web/Nameless.Docker.Web.csproj
dotnet user-secrets -p ./src/Nameless.Docker.Web/Nameless.Docker.Web.csproj set "Kestrel:Certificates:Default:Password" <YOUR_PASSWORD_HERE>
```

What the command above will do? It'll add a ["User Secrets"](https://learn.microsoft.com/en-us/aspnet/core/security/app-secrets?view=aspnetcore-9.0&tabs=windows) ID to your application.
The next line create a new entry in the secrets file for the HTTPS certificate. You can also manage
your user secrets through Visual Studio. Just right-click in your project then find the option
**Manage User Secrets**

Ok, I think we're good to go.

Run Docker compose command in Terminal like this:

```powershell
docker compose up -d
```

If you want more info about how to set a Dockerfile to your ASP.Net Core app,
please refer this documentation: [Run ASP.Net Core Docker HTTPS](https://github.com/dotnet/dotnet-docker/blob/main/samples/run-aspnetcore-https-development.md)

## Coding Styles

Nothing written into stone, use your ol'good common sense. But you can refere
to this page, if you like: [Common C# Coding Conventions](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/coding-style/coding-conventions).

## Contribuition

Just me, at the moment.

## Authors

- **Marco Teixeira (marcoaoteixeira)** - _initial work_

## License

MIT

## Acknowledgement

- Hat tip to anyone whose code was used.