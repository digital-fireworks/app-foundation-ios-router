import Observation
import SwiftUI

@MainActor
@Observable
public final class RoutePath<Route: Hashable> {

    public var path: [Route]

    public init(path: [Route] = []) {
        self.path = path
    }

    public var binding: Binding<[Route]> {
        Binding(
            get: { self.path },
            set: { self.path = $0 }
        )
    }

    public var isAtRoot: Bool {
        path.isEmpty
    }

    public func push(_ element: Route) {
        path.append(element)
    }

    public func pop() {
        guard !path.isEmpty else { return }
        _ = path.popLast()
    }

    public func popToRoot() {
        path.removeAll()
    }
}
