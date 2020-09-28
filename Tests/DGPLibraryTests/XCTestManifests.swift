import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DGPLibraryTests.allTests),
    ]
}
#endif
