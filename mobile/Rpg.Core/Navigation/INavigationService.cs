namespace Rpg.Core.Navigation;

/// <summary>Navigation abstraction so ViewModels never touch Shell directly. Implemented in Rpg.Mobile.</summary>
public interface INavigationService
{
    Task GoToAsync(string route);
}
