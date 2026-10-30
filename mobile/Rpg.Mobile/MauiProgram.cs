using Microsoft.Extensions.Logging;
using Rpg.Core.Api;
using Rpg.Core.Navigation;
using Rpg.Core.ViewModels;
using Rpg.Mobile.Pages;
using Rpg.Mobile.Services;

namespace Rpg.Mobile;

public static class MauiProgram
{
	public static MauiApp CreateMauiApp()
	{
		var builder = MauiApp.CreateBuilder();
		builder
			.UseMauiApp<App>()
			.ConfigureFonts(fonts =>
			{
				fonts.AddFont("OpenSans-Regular.ttf", "OpenSansRegular");
				fonts.AddFont("OpenSans-Semibold.ttf", "OpenSansSemibold");
			});

		builder.Services.AddSingleton(new ApiOptions { BaseUrl = GetApiBaseUrl() });
		builder.Services.AddSingleton<INavigationService, ShellNavigationService>();

		builder.Services.AddTransient<LandingViewModel>();
		builder.Services.AddTransient<LandingPage>();
		builder.Services.AddTransient<PlaceholderPage>();

#if DEBUG
		builder.Logging.AddDebug();
#endif

		return builder.Build();
	}

	// Local dev API (uvicorn or docker compose on port 8001). Release builds need an HTTPS URL.
	private static Uri GetApiBaseUrl()
	{
#if DEBUG
		// The Android emulator reaches the host machine's localhost at 10.0.2.2.
		return DeviceInfo.Platform == DevicePlatform.Android
			? new Uri("http://10.0.2.2:8001/api")
			: new Uri("http://localhost:8001/api");
#else
		throw new InvalidOperationException("Set the production HTTPS API URL before building Release.");
#endif
	}
}
