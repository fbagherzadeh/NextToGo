//
//  NextToGoViewModelTests.swift
//  NextToGoTests
//
//  Created by Farhad Bagherzadeh on 27/5/2025.
//

import Testing
import Combine
@testable import NextToGo

@MainActor
class NextToGoViewModelTests {
  let mockRacingService: MockRacingService = .init()
  var cancellable: [AnyCancellable] = []

  @Test func initialisation() async throws {
    let viewModel = NextToGoViewModel(racingService: mockRacingService)
    #expect(viewModel.viewState == .loading)
    #expect(viewModel.selectedFilter == .all)
  }

  @Test("Testing loadRaces with success scenario")
  func loadRaces_withSuccess() async throws {
    let viewModel = NextToGoViewModel(racingService: mockRacingService)
    await viewModel.loadRaces()
    if case let .loaded(races) = viewModel.viewState {
      #expect(races.count == 5)
      #expect(races.map { $0.raceID } == ["raceID4", "raceID7", "raceID10", "raceID8", "raceID6"])
    } else {
      Issue.record("viewState must be loaded")
    }
  }

  @Test("Testing both loadRaces with error scenario and when called, viewState must emit loading first")
  func loadRaces_withError() async throws {
    let viewModel = NextToGoViewModel(racingService: MockRacingService(shouldThrows: true))
    await confirmation { confirmation in
      viewModel.$viewState
        .dropFirst()
        .sink { state in
          if state == .loading {
            confirmation()
          }
        }
        .store(in: &cancellable)

      await viewModel.loadRaces()
    }

    #expect(viewModel.viewState == .somethingWentWrong)
  }
}

extension NextToGoViewState: @retroactive Equatable {
  public static func == (lhs: NextToGoViewState, rhs: NextToGoViewState) -> Bool {
    switch (lhs, rhs) {
    case (.loading, .loading),
      (.empty, .empty),
      (.somethingWentWrong, .somethingWentWrong):
      true
    case let (.loaded(lhsRaces), .loaded(rhsRaces)):
      lhsRaces == rhsRaces
    default:
      false
    }
  }
}
