namespace Rpg.Core.Api;

/// <summary>API connection settings. The base URL is set per platform and build configuration in MauiProgram.</summary>
public sealed class ApiOptions
{
    /// <summary>Base URL including the /api prefix, e.g. http://localhost:8001/api.</summary>
    public required Uri BaseUrl { get; init; }
}
