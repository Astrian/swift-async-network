import XCTest
@testable import SwiftAsyncNetwork

final class SwiftAsyncNetworkTests: XCTestCase {
  
  // MARK: - Test GET method
  func testGet() async throws {
    let params: SANReqParams = SANReqParams(
      query: ["hello": "world"],
      body: ["hello": "world"],
      header: ["Content-Type": "application/json", "Accept": "application/json"]
    )
    let (_, res) = try await SAN.request("GET", "https://httpstat.us/200", params: params)
    XCTAssertEqual(res?.statusCode, 200)
  }
}
