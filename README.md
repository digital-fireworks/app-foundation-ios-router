# AppFoundationRouter

`AppFoundationRouter` is a small SwiftUI-first routing package with typed navigation
and typed sheet state.

## What it provides

- `Route<Path>`: stack navigation state and helpers.
- `Router<Path, Sheet>`: combines `Route` with sheet presentation state.
- `SheetPresentable`: protocol for app-defined sheet enums.

## Core types

```swift
@Observable
public final class Route<Path: Hashable> {
    public var path: [Path]
    public var binding: Binding<[Path]> { ... }
    public var isAtRoot: Bool { ... }
    public func push(_ element: Path)
    public func pop()
    public func popToRoot()
}

@Observable
public final class Router<Path, Sheet>
where Path: Hashable, Sheet: SheetPresentable {
    public var route: Route<Path>
    public var presentedSheet: Sheet?
    public var binding: Binding<[Path]> { ... }
    public var isAtRoot: Bool { ... }
    public func push(_ route: Path)
    public func pop()
    public func popToRoot()
    public func presentSheet(_ sheet: Sheet)
    public func dismissSheet()
    public func isPresenting(_ sheet: Sheet) -> Bool
}
```

## Conceptual usage

```swift
import SwiftUI
import AppFoundationRouter

enum AppRoute: Hashable {
    case list
    case details(id: UUID)
}

enum AppSheet: SheetPresentable {
    case settings
    case help

    nonisolated var id: String {
        switch self {
        case .settings: return "settings"
        case .help: return "help"
        }
    }

    var body: some View {
        switch self {
        case .settings: Text("Settings")
        case .help: Text("Help")
        }
    }
}

typealias AppRouter = Router<AnyHashable, AppSheet>

private struct AppRouterKey: EnvironmentKey {
    static let defaultValue = AppRouter()
}

extension EnvironmentValues {
    var appRouter: AppRouter {
        get { self[AppRouterKey.self] }
        set { self[AppRouterKey.self] = newValue }
    }
}

struct RootView: View {
    @Environment(\.appRouter) private var appRouter

    var body: some View {
        NavigationStack(path: Bindable(appRouter).route.binding) {
            VStack {
                Button("Go to details") {
                    appRouter.push(AnyHashable(AppRoute.details(id: UUID())))
                }

                Button("Open settings") {
                    appRouter.presentSheet(.settings)
                }
            }
            .navigationDestination(for: AnyHashable.self) { value in
                if let route = value.base as? AppRoute {
                    switch route {
                    case .list:
                        Text("List")
                    case .details(let id):
                        Text("Details \(id.uuidString)")
                    }
                }
            }
            .sheet(item: Bindable(appRouter).presentedSheet) { sheet in
                sheet
            }
        }
    }
}
```

## Notes

- App code owns the environment key (for example `\.appRouter`).
- Route type choice is up to the app (`AnyHashable` for mixed destinations, or a concrete enum).
- For reusable view-level APIs, accept `Router<Path, Sheet>` or `Route<Path>` as input.
