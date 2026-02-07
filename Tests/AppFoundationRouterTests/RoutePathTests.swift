import XCTest
@testable import AppFoundationRouter

final class RoutePathTests: XCTestCase {

    @MainActor
    func testPushPopAndPopToRoot() {
        let routePath = RoutePath<String>()

        routePath.push("one")
        routePath.push("two")

        XCTAssertEqual(routePath.path, ["one", "two"])

        routePath.pop()
        XCTAssertEqual(routePath.path, ["one"])

        routePath.popToRoot()
        XCTAssertEqual(routePath.path, [])
        XCTAssertTrue(routePath.isAtRoot)
    }

    @MainActor
    func testBindingReadsAndWritesPath() {
        let routePath = RoutePath<Int>()

        let binding = routePath.binding
        XCTAssertEqual(binding.wrappedValue, [])

        binding.wrappedValue = [1, 2, 3]
        XCTAssertEqual(routePath.path, [1, 2, 3])
    }
}
