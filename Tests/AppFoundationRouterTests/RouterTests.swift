import SwiftUI
import XCTest
@testable import AppFoundationRouter

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
}
