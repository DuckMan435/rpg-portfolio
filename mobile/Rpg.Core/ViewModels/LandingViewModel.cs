using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using Rpg.Core.Navigation;

namespace Rpg.Core.ViewModels;

public partial class LandingViewModel(INavigationService navigation) : ObservableObject
{
    [RelayCommand]
    private Task NewCharacterAsync() => navigation.GoToAsync(Routes.Wizard);

    [RelayCommand]
    private Task LoadCharacterAsync() => navigation.GoToAsync(Routes.Select);
}
