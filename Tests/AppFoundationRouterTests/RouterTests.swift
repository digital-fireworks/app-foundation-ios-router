//
//  RouterTests.swift
//  AppFoundationRouterTests
//
//  Created by Fredrik Nannestad on 08/02/2026.
//

import SwiftUI
import XCTest
@testable import AppFoundationRouter

@MainActor
private enum TestSheet: SheetPresentable {
    case help
    case about

    nonisolated var id: String {
        switch self {
        case .help:
            return "help"
        case .about:
            return "about"
        }
    }

    var body: some View {
        Text(id)
    }
}

final class RouterTests: XCTestCase {

    @MainActor
    func testRouteOperationsProxyToRouteStorage() {
        let router = Router<String, TestSheet>()

        router.push("one")
        router.push("two")
        XCTAssertEqual(router.path, ["one", "two"])
        XCTAssertEqual(router.binding.wrappedValue, ["one", "two"])
        XCTAssertFalse(router.isAtRoot)

        router.pop()
        XCTAssertEqual(router.path, ["one"])

        router.popToRoot()
        XCTAssertEqual(router.path, [])
        XCTAssertTrue(router.isAtRoot)
    }

    @MainActor
    func testSheetPresentationAndDismissal() {
        let router = Router<String, TestSheet>()
        let detents: Set<PresentationDetent> = [.medium, .large]

        router.presentSheet(.help, detents: detents, initialDetent: .large)
        XCTAssertEqual(router.presentedSheet?.sheet, .help)
        XCTAssertEqual(router.presentedSheet?.detents, detents)
        XCTAssertEqual(router.presentedSheet?.initialDetent, .large)
        XCTAssertTrue(router.isPresenting(.help))
        XCTAssertFalse(router.isPresenting(.about))

        router.dismissSheet()
        XCTAssertNil(router.presentedSheet)
    }
}
