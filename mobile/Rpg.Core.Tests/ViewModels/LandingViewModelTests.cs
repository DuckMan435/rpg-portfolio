using Rpg.Core.Navigation;
using Rpg.Core.ViewModels;

namespace Rpg.Core.Tests.ViewModels;

public class LandingViewModelTests
{
    private sealed class FakeNavigationService : INavigationService
    {
        public List<string> Visited { get; } = [];

        public Task GoToAsync(string route)
        {
            Visited.Add(route);
            return Task.CompletedTask;
        }
    }

    [Fact]
    public async Task NewCharacter_navigates_to_wizard()
    {
        var navigation = new FakeNavigationService();
        var viewModel = new LandingViewModel(navigation);

        await viewModel.NewCharacterCommand.ExecuteAsync(null);

        Assert.Equal([Routes.Wizard], navigation.Visited);
    }

    [Fact]
    public async Task LoadCharacter_navigates_to_select()
    {
        var navigation = new FakeNavigationService();
        var viewModel = new LandingViewModel(navigation);

        await viewModel.LoadCharacterCommand.ExecuteAsync(null);

        Assert.Equal([Routes.Select], navigation.Visited);
    }
}
