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

    var presentation: SheetPresentation {
        switch self {
        case .help:
            return SheetPresentation(detents: [.large], initialDetent: .large)
        case .about:
            return SheetPresentation()
        }
    }
}

final class RouterTests: XCTestCase {

    @MainActor
    func testRouteOperationsProxyToRouteStorage() {
        let router = Router<String, TestSheet>()

        router.push("one")
        router.push("two")
        XCTAssertEqual(router.route.path, ["one", "two"])
        XCTAssertEqual(router.binding.wrappedValue, ["one", "two"])
        XCTAssertFalse(router.isAtRoot)

        router.pop()
        XCTAssertEqual(router.route.path, ["one"])

        router.popToRoot()
        XCTAssertEqual(router.route.path, [])
        XCTAssertTrue(router.isAtRoot)
    }

    @MainActor
    func testSheetPresentationAndDismissal() {
        let router = Router<String, TestSheet>()

        router.presentSheet(.help)
        XCTAssertEqual(router.presentedSheet, .help)
        XCTAssertEqual(router.presentedSheet?.presentation.initialDetent, .large)
        XCTAssertEqual(router.presentedSheet?.presentation.detents, [.large])
        XCTAssertTrue(router.isPresenting(.help))
        XCTAssertFalse(router.isPresenting(.about))

        router.dismissSheet()
        XCTAssertNil(router.presentedSheet)
    }
}
