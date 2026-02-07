import Observation
import SwiftUI

public struct SheetPresentation<Sheet>: Identifiable where Sheet: Equatable {
    public let id = UUID()
    public let sheet: Sheet
    public let detents: Set<PresentationDetent>
    public let initialDetent: PresentationDetent

    public init(
        sheet: Sheet,
        detents: Set<PresentationDetent>,
        initialDetent: PresentationDetent
    ) {
        self.sheet = sheet
        self.detents = detents
        self.initialDetent = initialDetent
    }
}

public typealias DefaultRouter = Router<AnyHashable, AnyHashable>

extension EnvironmentValues {
    @Entry public var defaultRouter: DefaultRouter = DefaultRouter()
}

@Observable
public final class Router<Route, Sheet> where Route: Hashable, Sheet: Equatable {

    public var routePath: RoutePath<Route>
    public var presentedSheetPresentation: SheetPresentation<Sheet>?

    public init(
        routePath: RoutePath<Route> = RoutePath(),
        presentedSheetPresentation: SheetPresentation<Sheet>? = nil
    ) {
        self.routePath = routePath
        self.presentedSheetPresentation = presentedSheetPresentation
    }

    public var path: [Route] {
        get { routePath.path }
        set { routePath.path = newValue }
    }

    public var binding: Binding<[Route]> {
        routePath.binding
    }

    public var isAtRoot: Bool {
        routePath.isAtRoot
    }

    public func push(_ route: Route) {
        routePath.push(route)
    }

    public func pop() {
        routePath.pop()
    }

    public func popToRoot() {
        routePath.popToRoot()
    }

    public func presentSheet(
        _ sheet: Sheet,
        detents: Set<PresentationDetent> = [.medium, .large],
        initialDetent: PresentationDetent? = nil
    ) {
        let initial = initialDetent ?? detents.first ?? .medium
        presentedSheetPresentation = SheetPresentation(
            sheet: sheet,
            detents: detents,
            initialDetent: initial
        )
    }

    public func dismissSheet() {
        presentedSheetPresentation = nil
    }
}
