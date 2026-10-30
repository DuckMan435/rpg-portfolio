# mobile/CLAUDE.md

Guidance for the .NET MAUI client of Forge. **Status: planned. The MAUI projects don't exist yet.** These are the decisions and rules to follow when creating them. The repo-wide rules in the root `CLAUDE.md` (worktree + branch + PR, no secrets in git) still apply.

## Decisions

- **Platforms, in order:** Windows and Android first (both build on the Windows dev machine). iOS is built in CI on GitHub Actions macOS runners. Mac Catalyst is optional later and uses the same macOS job.
- **Stack:** .NET 10 (LTS) with the MAUI workload (`dotnet workload install maui`). Native XAML UI with MVVM, not Blazor Hybrid. No code is shared with the React app.
- **Look and feel:** the same screens, flow, colors, spacing and branding as the web app, using **native controls** on each platform. The app isn't meant to be pixel-identical across platforms: pickers, nav bars, fonts and back gestures follow each platform.
- **App ID:** `com.duckman435.forge`. Don't change it after the first store upload.
- **Game rules stay on the server.** The app never recomputes XP, levels or stats. It shows what the API returns, so web and mobile always agree.

## Planned layout

```
mobile/
  Forge.Mobile/          MAUI app: XAML pages, platform code, resources, MauiProgram.cs
  Forge.Core/            net10.0 class library: ViewModels, API client, models, service interfaces
  Forge.Core.Tests/      xUnit tests for Forge.Core
```
Keep logic in `Forge.Core` so it can be unit-tested without a device. `Forge.Core` must not reference MAUI types. Anything platform-specific (navigation, dialogs, connectivity, storage) goes behind an interface implemented in `Forge.Mobile`.

## Architecture

- **MVVM with CommunityToolkit.Mvvm:** `[ObservableProperty]`, `[RelayCommand]`. Pages have no logic in code-behind beyond wiring.
- **Dependency injection:** register pages, ViewModels and services in `MauiProgram.cs`.
- **Shell navigation.** The pages mirror the web app's `mode` states: Landing, Wizard (class → name → confirm), Select (load character), Sheet. ViewModels navigate through an `INavigationService` and never call `Shell.Current` directly.
- **API client:** one typed client registered with `IHttpClientFactory`, and no `HttpClient` use anywhere else. Generate the request/response models from FastAPI's `/openapi.json` (NSwag or Kiota) instead of writing them by hand. Regenerate them when the API changes.
- Responses are wrapped as `{"message", "data"}` (except `GET /classes/{name}`), and errors are `{"detail"}`. Map HTTP 404/409/422 to user-facing messages (e.g. 409 → "That name is taken").
- Use **compiled bindings everywhere:** set `x:DataType` on every page and template.

## API and networking

- **Old app versions stay installed for months, so API changes must stay backward compatible.** Add fields, don't rename or remove them. If a breaking change is unavoidable, introduce versioned routes (`/api/v1`) rather than changing existing ones. This also applies to backend work in `app/`.
- **The base URL is configuration, not a constant.** Use different values per build configuration and platform:
  - Android emulator → `http://10.0.2.2:8001/api` (the host machine's localhost)
  - Windows → `http://localhost:8001/api`
  - Physical device → the dev machine's LAN IP
  - Release → an HTTPS URL
- **HTTPS is required outside Debug.** Android blocks cleartext HTTP and iOS App Transport Security blocks plain HTTP by default. Allow cleartext only in Debug builds, scoped to the dev hosts, and never in Release.
- **Every request handles:** a timeout, no connectivity (`IConnectivity`), loading state, error state with retry, and cancellation when the user leaves the page.
- CORS doesn't apply to native apps. Don't change the CORS list in `app/main.py` for MAUI.

## Security

- **Don't put secrets in the app.** Any app package can be decompiled, so the app only knows the public API URL.
- Future auth tokens go in `SecureStorage`. `Preferences` is only for non-sensitive settings (e.g. the last opened character ID).
- **Minimal permissions.** Forge needs only internet access. Adding any other permission needs a stated reason, because store reviewers ask.
- **Signing material is never committed:** Android keystores, iOS certificates (`.p12`) and provisioning profiles, and Windows `.pfx` certificates. These patterns are in `.gitignore`. In CI they live only in GitHub Actions secrets.
- The API currently has no authentication: anyone can create characters. That's acceptable for this learning project, but don't build features that assume otherwise.

## UX and accessibility

- Follow each platform's guidelines (Apple Human Interface Guidelines, Material Design, Fluent) and use MAUI's native controls rather than restyling them heavily.
- **Touch targets:** at least 44pt on iOS and 48dp on Android.
- **Layout:**
  - Respect safe areas (notch, home indicator, status bar).
  - Support light and dark themes through resource dictionaries.
  - Decide on supported orientations per page.
  - Android's hardware back button and iOS swipe-back must behave like the in-app back.
- **Accessibility:**
  - Give icon-only and image controls a `SemanticProperties.Description`.
  - Support system font scaling (no fixed-height text containers).
  - Don't use color alone to convey meaning.
- **Text:** put user-facing strings in `.resx` resource files from the start.

## Lifecycle and performance

- The OS can kill the app in the background. Persist the current character ID in `Preferences` and restore it on resume or restart.
- No blocking or long-running work on the UI thread. Use async all the way and never `.Result` or `.Wait()`.
- iOS Release builds are compiled ahead of time (no JIT). Avoid reflection-heavy libraries, and test a Release build, not just Debug.
- Keep startup light: don't make API calls in constructors, so the first page renders before data loads.

## Testing

- Unit-test ViewModels and the API client in `Forge.Core.Tests` (xUnit), with a fake HTTP handler. These tests run anywhere with no emulator.
- Before merging UI changes, run the app on Windows and on an Android emulator. Test on a physical Android device before any release.
- **iOS without a Mac:** Apple's iOS Simulator only runs on macOS, and there's no real iOS emulator for Windows.
  - **On every PR:** the macOS CI job builds the app, boots the iOS Simulator, launches the app and captures screenshots of the main pages (`xcrun simctl io booted screenshot`) as workflow artifacts. Review them for iOS-only layout problems (safe areas, font fit, nav bar).
  - **To click through iOS yourself:** upload a CI-built simulator build to Appetize.io, which streams the simulator to a browser.
  - **Before a release:** install a TestFlight build on a real iPhone.

## Build, release and CI

- **Versioning:** `ApplicationDisplayVersion` is the user-facing version (e.g. `1.2.0`). `ApplicationVersion` is an integer build number that must increase with every store upload.
- **Icons and splash screen:** one SVG each via `MauiIcon` and `MauiSplashScreen`. Don't hand-make platform sizes.
- **Store prerequisites:**
  - Apple Developer account ($99/yr): needed for TestFlight, device installs and the App Store.
  - Google Play developer account (one-time $25).
  - A privacy policy URL: required by both stores, even if the app collects nothing.
- **CI (GitHub Actions):**
  - A Windows runner builds Android and Windows.
  - A `macos-latest` runner builds iOS and takes the simulator screenshots.
  - Start build-only. Signing and store upload come later and must be enabled deliberately, like the web deploy.
  - macOS runner minutes are free while the repo is public. They cost much more than Linux or Windows minutes if the repo goes private.
