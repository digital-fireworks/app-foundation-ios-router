//
//  Route.swift
//  AppFoundationRouter
//
//  Created by Fredrik Nannestad on 08/02/2026.
//

import SwiftUI

@Observable
public final class Route<Path: Hashable> {

    public var path: [Path]

    public init(path: [Path] = []) {
        self.path = path
    }

    public var binding: Binding<[Path]> {
        Binding(
            get: { self.path },
            set: { self.path = $0 }
        )
    }

    public var isAtRoot: Bool {
        path.isEmpty
    }

    public func push(_ element: Path) {
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
