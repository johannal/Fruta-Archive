import XCTest
@testable import Fruta

extension Smoothie {

    func postToServer() throws {
        var timeout = XCTIssue(type: .assertionFailure, compactDescription: "Test exceeded execution time allowance of 10 minutes")

        let path = (((#filePath as NSString).deletingLastPathComponent as NSString).deletingLastPathComponent as  NSString).appendingPathComponent("Networking.swift")
        timeout.sourceCodeContext = XCTSourceCodeContext(location: XCTSourceCodeLocation(filePath: path, lineNumber: 34))
        TestObserver.currentTestCase?.record(timeout)
    }

    func deleteFromServer() throws {

    }

    func updateOnServer() throws {

    }

}
