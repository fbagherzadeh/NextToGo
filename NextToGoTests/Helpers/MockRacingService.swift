//
//  MockRacingService.swift
//  NextToGoTests
//
//  Created by Farhad Bagherzadeh on 27/5/2025.
//

import Foundation
@testable import NextToGo

private class BundleLocator {}

actor MockRacingService: RacingServiceProtocol {
  var didInvokeFetchRacing: Bool = false
  let shouldThrows: Bool

  init(shouldThrows: Bool = false) {
    self.shouldThrows = shouldThrows
  }

  func fetchRacing() async throws -> RaceAPIResponse {
    didInvokeFetchRacing = true

    if shouldThrows {
      throw NetworkError.invalidURL
    }

    let url = Bundle(for: BundleLocator.self).url(
      forResource: "RaceAPIResponse",
      withExtension: "json"
    )!
    let data = try Data(contentsOf: url)
    return try JSONDecoder().decode(RaceAPIResponse.self, from: data)
  }
}
