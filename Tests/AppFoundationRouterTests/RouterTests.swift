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
private enum TestSheet: SheetProtocol {
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
        let router = Router<String, String>()

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
        let router = Router<String, String>()
        let detents: Set<PresentationDetent> = [.medium, .large]

        router.presentSheet("help", detents: detents, initialDetent: .large)
        XCTAssertEqual(router.presentedSheetPresentation?.sheet, "help")
        XCTAssertEqual(router.presentedSheetPresentation?.detents, detents)
        XCTAssertEqual(router.presentedSheetPresentation?.initialDetent, .large)

        router.dismissSheet()
        XCTAssertNil(router.presentedSheetPresentation)
    }

    @MainActor
    func testDefaultRouterHelpersUseTypedSheetProtocol() {
        let router = DefaultRouter()
        let detents: Set<PresentationDetent> = [.medium, .large]

        router.presentSheet(TestSheet.help, detents: detents, initialDetent: .large)

        XCTAssertTrue(router.isPresenting(TestSheet.help))
        XCTAssertFalse(router.isPresenting(TestSheet.about))
        XCTAssertEqual(router.presentedSheetPresentation?.detents, detents)
        XCTAssertEqual(router.presentedSheetPresentation?.initialDetent, .large)
    }
}
