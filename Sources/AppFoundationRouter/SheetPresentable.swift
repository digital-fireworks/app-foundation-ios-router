//
//  SheetPresentable.swift
//  AppFoundationRouter
//
//  Created by Fredrik Nannestad on 08/02/2026.
//

import SwiftUI

public struct SheetPresentation: Equatable {
    public let detents: Set<PresentationDetent>
    public let initialDetent: PresentationDetent

    public init(
        detents: Set<PresentationDetent> = [.medium, .large],
        initialDetent: PresentationDetent = .medium
    ) {
        self.detents = detents
        self.initialDetent = detents.contains(initialDetent) ? initialDetent : (detents.first ?? .medium)
    }
}

@MainActor
public protocol SheetPresentable: Identifiable, Equatable, View where ID == String {
    nonisolated var id: String { get }
    var presentation: SheetPresentation { get }
}
