using Rpg.Core.Navigation;
using Rpg.Mobile.Pages;

namespace Rpg.Mobile;

public partial class AppShell : Shell
{
	public AppShell()
	{
		InitializeComponent();

		// Pages not built yet all point at the placeholder; swap each for its real page as it lands.
		Routing.RegisterRoute(Routes.Wizard, typeof(PlaceholderPage));
		Routing.RegisterRoute(Routes.Select, typeof(PlaceholderPage));
		Routing.RegisterRoute(Routes.Sheet, typeof(PlaceholderPage));
	}
}
