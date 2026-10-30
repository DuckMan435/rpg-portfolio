using Rpg.Core.ViewModels;

namespace Rpg.Mobile.Pages;

public partial class LandingPage : ContentPage
{
	public LandingPage(LandingViewModel viewModel)
	{
		InitializeComponent();
		BindingContext = viewModel;
	}
}
