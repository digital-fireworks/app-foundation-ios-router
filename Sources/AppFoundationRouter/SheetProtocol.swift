//
//  SheetProtocol.swift
//  AppFoundationRouter
//
//  Created by Fredrik Nannestad on 08/02/2026.
//

import SwiftUI

@MainActor
public protocol SheetProtocol: Identifiable, Equatable, View where ID == String {
    nonisolated var id: String { get }
}

public struct AnySheet: Identifiable, Equatable {

    public let id: String

    private let boxed: Any
    private let makeView: () -> AnyView
    private let isEqualToBoxed: (Any) -> Bool

    @MainActor
    public init<S: SheetProtocol>(_ sheet: S) {
        id = sheet.id
        boxed = sheet
        makeView = { AnyView(sheet) }
        isEqualToBoxed = { candidate in
            guard let typed = candidate as? S else { return false }
            return typed == sheet
        }
    }

    public static func == (lhs: AnySheet, rhs: AnySheet) -> Bool {
        lhs.isEqualToBoxed(rhs.boxed)
    }

    public var view: AnyView {
        makeView()
    }
}
