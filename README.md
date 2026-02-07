# AppFoundationRouter

A small SwiftUI-first routing package that provides:

- `RoutePath<Route>` for stack navigation state
- `Router<Route, Sheet>` as a combined navigation + sheet coordinator

The router is generic, so downstream apps define their own route and sheet types.

## Installation

Add the local package dependency:

- Path: `Packages/AppFoundationRouter`
- Product: `AppFoundationRouter`

## Conceptual Usage

```swift
import SwiftUI
import AppFoundationRouter

enum AppRoute: Hashable {
    case list
    case details(id: UUID)
}

enum AppSheet: Equatable {
    case settings
    case help
}

typealias AppRouter = Router<AnyHashable, AppSheet>

private struct RouterKey: EnvironmentKey {
    static let defaultValue = AppRouter()
}

extension EnvironmentValues {
    var appRouter: AppRouter {
        get { self[RouterKey.self] }
        set { self[RouterKey.self] = newValue }
    }
}

struct RootView: View {
    @Environment(\.appRouter) private var router

    var body: some View {
        NavigationStack(path: Bindable(router).routePath.binding) {
            VStack {
                Button("Go to details") {
                    router.push(AnyHashable(AppRoute.details(id: UUID())))
                }

                Button("Open settings") {
                    router.presentSheet(.settings)
                }
            }
            .navigationDestination(for: AnyHashable.self) { value in
                if let route = value.base as? AppRoute {
                    switch route {
                    case .list:
                        Text("List")
                    case .details(let id):
                        Text("Details: \(id.uuidString)")
                    }
                }
            }
            .sheet(item: Bindable(router).presentedSheetPresentation) { presentation in
                switch presentation.sheet {
                case .settings:
                    Text("Settings")
                case .help:
                    Text("Help")
                }
            }
        }
    }
}
```

## Notes

- Use `router.push(_:)`, `router.pop()`, and `router.popToRoot()` for navigation.
- Use `router.presentSheet(_:detents:initialDetent:)` and `router.dismissSheet()` for modal presentation.
- If you prefer strongly typed destinations, you can also use `RoutePath<YourRoute>` directly.
