//
//  Router.swift
//  AppFoundationRouter
//
//  Created by Fredrik Nannestad on 08/02/2026.
//

import SwiftUI

@Observable
public final class Router<Path, Sheet> where Path: Hashable, Sheet: SheetPresentable {

    public var route: Route<Path>
    public var presentedSheet: Sheet?

    public init(
        route: Route<Path> = Route(),
        presentedSheet: Sheet? = nil
    ) {
        self.route = route
        self.presentedSheet = presentedSheet
    }

    public var binding: Binding<[Path]> {
        route.binding
    }

    public var isAtRoot: Bool {
        route.isAtRoot
    }

    public func push(_ route: Path) {
        self.route.push(route)
    }

    public func pop() {
        route.pop()
    }

    public func popToRoot() {
        route.popToRoot()
    }

    public func presentSheet(_ sheet: Sheet) {
        presentedSheet = sheet
    }

    public func dismissSheet() {
        presentedSheet = nil
    }

    public func isPresenting(_ sheet: Sheet) -> Bool {
        presentedSheet == sheet
    }
}
