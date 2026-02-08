//
//  Router.swift
//  AppFoundationRouter
//
//  Created by Fredrik Nannestad on 08/02/2026.
//

import SwiftUI

public struct SheetPresentation<Sheet>: Identifiable where Sheet: SheetPresentable {
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

@Observable
public final class Router<Path, Sheet> where Path: Hashable, Sheet: SheetPresentable {

    public var route: Route<Path>
    public var presentedSheet: SheetPresentation<Sheet>?

    public init(
        route: Route<Path> = Route(),
        presentedSheet: SheetPresentation<Sheet>? = nil
    ) {
        self.route = route
        self.presentedSheet = presentedSheet
    }

    public var path: [Path] {
        get { route.path }
        set { route.path = newValue }
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

    public func presentSheet(
        _ sheet: Sheet,
        detents: Set<PresentationDetent> = [.medium, .large],
        initialDetent: PresentationDetent? = nil
    ) {
        let initial = initialDetent ?? detents.first ?? .medium
        presentedSheet = SheetPresentation(
            sheet: sheet,
            detents: detents,
            initialDetent: initial
        )
    }

    public func dismissSheet() {
        presentedSheet = nil
    }

    public func isPresenting(_ sheet: Sheet) -> Bool {
        presentedSheet?.sheet == sheet
    }
}
