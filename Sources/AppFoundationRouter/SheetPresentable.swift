//
//  SheetPresentable.swift
//  AppFoundationRouter
//
//  Created by Fredrik Nannestad on 08/02/2026.
//

import SwiftUI

@MainActor
public protocol SheetPresentable: Identifiable, Equatable, View where ID == String {
    nonisolated var id: String { get }
}
