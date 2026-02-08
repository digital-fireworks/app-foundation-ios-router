//
//  RouteTests.swift
//  AppFoundationRouterTests
//
//  Created by Fredrik Nannestad on 08/02/2026.
//

import XCTest
@testable import AppFoundationRouter

final class RouteTests: XCTestCase {

    @MainActor
    func testPushPopAndPopToRoot() {
        let route = Route<String>()

        route.push("one")
        route.push("two")

        XCTAssertEqual(route.path, ["one", "two"])

        route.pop()
        XCTAssertEqual(route.path, ["one"])

        route.popToRoot()
        XCTAssertEqual(route.path, [])
        XCTAssertTrue(route.isAtRoot)
    }

    @MainActor
    func testBindingReadsAndWritesPath() {
        let route = Route<Int>()

        let binding = route.binding
        XCTAssertEqual(binding.wrappedValue, [])

        binding.wrappedValue = [1, 2, 3]
        XCTAssertEqual(route.path, [1, 2, 3])
    }
}
