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
  let raceSummaries: [RaceSummary]

  init(
    shouldThrows: Bool = false,
    raceSummaries: [RaceSummary] = RaceSummary.Fixture.unsortedRaceSummaries
  ) {
    self.shouldThrows = shouldThrows
    self.raceSummaries = raceSummaries
  }

  func resetFetchRacingInvocation() {
    didInvokeFetchRacing = false
  }

  func fetchRacing() async throws -> [RaceSummary] {
    didInvokeFetchRacing = true

    if shouldThrows {
      throw NetworkError.invalidURL
    }

    return raceSummaries
  }
}
