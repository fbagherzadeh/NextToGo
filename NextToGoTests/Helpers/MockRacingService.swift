//
//  MockRacingService.swift
//  NextToGoTests
//
//  Created by Farhad Bagherzadeh on 27/5/2025.
//

import Foundation
@testable import NextToGo

actor MockRacingService: RacingServiceProtocol {
  var didInvokeFetchRacing: Bool = false
  let shouldThrows: Bool

  init(shouldThrows: Bool = false) {
    self.shouldThrows = shouldThrows
  }

  func fetchRacing() async throws -> [RaceSummary] {
    didInvokeFetchRacing = true

    if shouldThrows {
      throw NetworkError.invalidURL
    }

    return RaceSummary.Fixture.unsortedRaceSummaries
  }
}
