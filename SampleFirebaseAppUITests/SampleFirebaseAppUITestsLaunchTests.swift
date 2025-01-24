//
//
// SampleFirebaseAppUITestsLaunchTests.swift
// SampleFirebaseAppUITests
//
// Created by Shubh Magdani on 02/01/25
// Copyright © 2025 Differenz System Pvt. Ltd. All rights reserved.
//


import XCTest

final class SampleFirebaseAppUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
