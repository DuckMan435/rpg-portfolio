using Rpg.Core.Navigation;

namespace Rpg.Mobile.Services;

public class ShellNavigationService : INavigationService
{
	public Task GoToAsync(string route) => Shell.Current.GoToAsync(route);
}
